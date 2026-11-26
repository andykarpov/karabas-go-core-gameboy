`timescale 1ns / 1ps
`default_nettype wire
/*
 gb_mem.v

 The cartridge bus of gb_machine on ch3 of gb_sdram, as ch0 of the MiSTer sdram.sv in Gameboy.sv:
 an access starts at the rising edge of mem_rd (the gb sdram_rd = ~phi_early: high for the first
 half of every bus cycle, at least 8 clk_sys in GBC double speed) or of mem_wr (a cartridge RAM
 write; cram_wr is high for the write cycle). The address is the MBC ROM address or, for the
 cartridge RAM, CRAM_BASE + cram_addr (as sdram_addr of Gameboy.sv). The read byte goes to mem_q
 when the controller answers (~3..5 clk_sys); the machine samples it at the end of the cycle.

 A write that rises while a read is still in the controller waits for its answer. doRefresh lets the
 controller refresh while the machine has no read half-cycle (MiSTer: "for SDRAM read & refresh").
 Nothing is started while a cartridge loads (ch1 writes the ROM then).
*/
module gb_mem #(
	parameter [25:0] CRAM_BASE = 26'h0800000   // the cartridge RAM above 8 MB of ROM
) (
	input  wire        clk,
	input  wire        loading,

	input  wire        mem_rd,
	input  wire        mem_wr,
	input  wire        mem_cram,
	input  wire [22:0] mem_addr,
	input  wire [16:0] mem_cram_addr,
	input  wire [7:0]  mem_din,
	output reg  [7:0]  mem_q = 8'hFF,

	output reg  [25:1] sdr_addr = 25'd0,
	output reg  [15:0] sdr_din = 16'd0,
	output reg  [1:0]  sdr_be = 2'b11,
	output reg         sdr_req = 1'b0,
	output reg         sdr_rnw = 1'b1,
	input  wire [15:0] sdr_dout,
	input  wire        sdr_ready,
	output wire        refresh
);

wire [25:0] byte_addr = mem_cram ? (CRAM_BASE | { 9'd0, mem_cram_addr }) : { 3'd0, mem_addr };

reg rd_d = 1'b0, wr_d = 1'b0;
reg busy = 1'b0;           // an access is in the controller
reg busy_rd = 1'b0;        // ... and it is a read
reg lo_byte = 1'b0;        // the byte of the read: 0 = [7:0]
reg wr_pend = 1'b0;
reg [25:0] wr_addr = 26'd0;
reg [7:0]  wr_data = 8'd0;

assign refresh = ~mem_rd & ~busy;

always @(posedge clk) begin
	rd_d <= mem_rd;
	wr_d <= mem_wr & mem_cram;
	sdr_req <= 1'b0;           // a one-clk_sys pulse: the controller takes its rising edge

	if (mem_wr & mem_cram & ~wr_d & ~loading) begin
		wr_pend <= 1'b1;
		wr_addr <= byte_addr;
		wr_data <= mem_din;
	end

	if (busy) begin
		if (sdr_ready) begin
			busy <= 1'b0;
			if (busy_rd) mem_q <= lo_byte ? sdr_dout[15:8] : sdr_dout[7:0];
		end
	end
	else if (mem_rd & ~rd_d & ~loading) begin
		sdr_addr <= byte_addr[25:1];
		lo_byte <= byte_addr[0];
		sdr_rnw <= 1'b1;
		sdr_be <= 2'b11;
		sdr_req <= 1'b1;
		busy <= 1'b1;
		busy_rd <= 1'b1;
	end
	else if (wr_pend) begin
		wr_pend <= 1'b0;
		sdr_addr <= wr_addr[25:1];
		sdr_din <= { wr_data, wr_data };
		sdr_be <= wr_addr[0] ? 2'b10 : 2'b01;
		sdr_rnw <= 1'b0;
		sdr_req <= 1'b1;
		busy <= 1'b1;
		busy_rd <= 1'b0;
	end
end

endmodule

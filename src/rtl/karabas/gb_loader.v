`timescale 1ns / 1ps
`default_nettype wire
/*
 gb_loader.v

 The cartridge: the bytes of the file loader of kg_mcu2 (LD kind 1, a .gb / .gbc file) into the
 SDRAM from address 0 as 16-bit words (little endian: the even byte low), one write per odd byte on
 ch1 of gb_sdram (req = one clk pulse, the address and data held until the next word; a byte comes
 every 250 ns at most, a write takes about 60 ns). The same words go to cart_top of gb_machine as the
 MiSTer ioctl download (dl high while the file comes, dl_wr per word at its even byte address): it
 reads the header (mapper, ROM / RAM size, CGB flag) and builds the ROM mask from the addresses.

 cart_ready from the end of the first file on; loading while a file comes (the top holds the machine
 in reset meanwhile).
*/
module gb_loader (
	input  wire        clk,

	input  wire        file_active,
	input  wire        file_wr,
	input  wire [31:0] file_addr,
	input  wire [7:0]  file_data,

	output reg  [25:1] sdr_addr = 25'd0,
	output reg  [15:0] sdr_din = 16'd0,
	output reg         sdr_req = 1'b0,

	output reg         dl = 1'b0,
	output reg         dl_wr = 1'b0,
	output reg  [24:0] dl_addr = 25'd0,
	output reg  [15:0] dl_data = 16'd0,

	output reg         loading = 1'b0,
	output reg         cart_ready = 1'b0
);

reg [7:0] lo = 8'd0;
reg       active_d = 1'b0;

always @(posedge clk) begin
	sdr_req <= 1'b0;
	dl_wr <= 1'b0;
	active_d <= file_active;
	loading <= file_active;
	dl <= file_active;

	if (file_wr) begin
		if (!file_addr[0])
			lo <= file_data;
		else begin
			sdr_addr <= file_addr[25:1];
			sdr_din <= { file_data, lo };
			sdr_req <= 1'b1;
			dl_addr <= { file_addr[24:1], 1'b0 };
			dl_data <= { file_data, lo };
			dl_wr <= 1'b1;
		end
	end

	if (!file_active && active_d)
		cart_ready <= 1'b1;
end

endmodule

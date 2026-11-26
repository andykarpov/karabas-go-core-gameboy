`timescale 1ns / 1ps
`default_nettype none

/*
 gb_bk.v (after ws_bk.v of karabas-go-core-wonderswan)

 The memory port of kg_bk_ram (bytes, clk_sys) on the .sav of the cartridge, laid out as the MiSTer
 Gameboy core does it:
 - sectors 0 .. ram_secs - 1: the cartridge RAM in the SDRAM (gb_mem: byte CRAM_BASE + offset), on
   ch2 of gb_sdram (a request edge, ready one clk_ram). The SDRAM takes whole words: kg_bk_ram loads
   a sector byte by byte from offset 0 up, so an even byte is kept here (acked at once) and written
   with the odd byte after it; a read takes the word and gives its byte. clk_ram = 3 x clk_sys from
   one PLL, the edges aligned: the requests cross as toggles without synchronisers (the ucf
   FROM-TO clk_sys <-> clk_ram);
 - sector ram_secs (MBC3 + TIMER only): the RTC sector, the 16-bit words of sd_buff_din in
   Gameboy.sv, little endian: bytes 0..3 RTC_timestampOut (Unix seconds of the save), 4..9
   RTC_savedtimeOut (the MBC3 registers then), the rest FF. A read takes both values at byte 0 (one
   consistent pair). A load keeps bytes 0..9 and, at the last byte of the sector, gives them to
   cart_top as bk_rtc_wr words 0..4 (word 4 makes mbc3.v load them and count the seconds since) -
   unless the time is 0 or FFFFFFFF (a new file: the RTC starts from zero then).
*/

module gb_bk #(
	parameter [25:0] CRAM_BASE = 26'h0800000
) (
	input  wire        clk,          // clk_sys
	input  wire        clk_ram,
	input  wire [8:0]  ram_secs,     // sectors of the cartridge RAM in the .sav

	input  wire        mem_req,
	input  wire        mem_we,
	input  wire [17:0] mem_addr,
	input  wire [7:0]  mem_din,
	output reg         mem_ack = 1'b0,
	output reg  [7:0]  mem_dout = 8'd0,

	input  wire [31:0] rtc_timestamp,
	input  wire [47:0] rtc_savedtime,
	output reg         bk_rtc_wr = 1'b0,
	output reg  [16:0] bk_addr = 17'd0,
	output reg  [15:0] bk_data = 16'd0,

	output reg  [25:1] sdr_addr = 25'd0,
	output reg  [15:0] sdr_din = 16'd0,
	output reg         sdr_req = 1'b0,
	output reg         sdr_rnw = 1'b1,
	input  wire [15:0] sdr_dout,
	input  wire        sdr_ready
);

// ---------------- clk_sys ----------------

wire is_rtc = mem_addr[17:9] >= ram_secs;
wire [8:0] off = mem_addr[8:0];

reg pend = 1'b0, req_t = 1'b0, done_seen = 1'b0;
reg [7:0] lo = 8'd0;
reg [17:0] a_r = 18'd0;
reg we_r = 1'b0;
reg [15:0] wd = 16'd0;
reg done_t = 1'b0;
reg [15:0] rd = 16'd0;

reg [79:0] rtc_snap = 80'd0;     // bytes 0..9 of the RTC sector, byte 0 in [7:0]
reg [79:0] rtc_in = 80'd0;
reg [2:0]  rtc_w = 3'd0;         // words still to give to cart_top (5 .. 1)

always @(posedge clk) begin
	mem_ack <= 1'b0;
	bk_rtc_wr <= 1'b0;

	if (!pend && mem_req && !mem_ack) begin
		if (is_rtc) begin
			mem_ack <= 1'b1;
			if (mem_we) begin
				if (off < 9'd10) rtc_in[off[3:0] * 8 +: 8] <= mem_din;
				if (off == 9'd511 && rtc_in[31:0] != 32'd0 && rtc_in[31:0] != 32'hFFFFFFFF)
					rtc_w <= 3'd5;
			end
			else if (off == 9'd0) begin
				rtc_snap <= { rtc_savedtime, rtc_timestamp };
				mem_dout <= rtc_timestamp[7:0];
			end
			else
				mem_dout <= off < 9'd10 ? rtc_snap[off[3:0] * 8 +: 8] : 8'hFF;
		end
		else if (mem_we && !mem_addr[0]) begin
			lo <= mem_din;
			mem_ack <= 1'b1;
		end
		else begin
			a_r <= mem_addr;
			we_r <= mem_we;
			wd <= { mem_din, lo };
			pend <= 1'b1;
			req_t <= ~req_t;
		end
	end
	if (pend && done_t != done_seen) begin
		done_seen <= done_t;
		pend <= 1'b0;
		mem_ack <= 1'b1;
		mem_dout <= a_r[0] ? rd[15:8] : rd[7:0];
	end

	// the RTC sector to cart_top: words 0..4, one a clock
	if (rtc_w != 3'd0) begin
		bk_rtc_wr <= 1'b1;
		bk_addr <= { 14'd0, 3'd5 - rtc_w };
		bk_data <= rtc_in[(5 - rtc_w) * 16 +: 16];
		rtc_w <= rtc_w - 3'd1;
	end
end

// ---------------- clk_ram ----------------

localparam S_IDLE = 2'd0, S_SDR = 2'd1, S_DONE = 2'd2;
reg [1:0] st = S_IDLE;
reg req_seen = 1'b0;
wire [25:0] sdr_byte = CRAM_BASE | { 8'd0, a_r };

always @(posedge clk_ram) begin
	case (st)
		S_IDLE:
			if (req_t != req_seen) begin
				req_seen <= req_t;
				sdr_addr <= sdr_byte[25:1];
				sdr_din <= wd;
				sdr_rnw <= ~we_r;
				sdr_req <= 1'b1;
				st <= S_SDR;
			end
		S_SDR:
			if (sdr_ready) begin
				sdr_req <= 1'b0;
				rd <= sdr_dout;
				st <= S_DONE;
			end
		default: begin       // S_DONE
			done_t <= ~done_t;
			st <= S_IDLE;
		end
	endcase
end

endmodule

`timescale 1ns / 1ps
`default_nettype wire
/*
 gb_rtc.v

 The time of the firmware RTC as the TIMESTAMP of the MiSTer hps_io for the MBC3 clock of cart_top:
 rtc_time = { toggle, Unix seconds }, the toggle flips with every new value (mbc3.v takes the
 seconds when it flips, and counts by itself in between; the time matters only as the difference
 between a save and the next load of the .sav).

 The firmware RTC (core.json rtc_mode 2: MC146818 registers, BCD, 24 h) through the RTC port of
 kg_mcu2: the address on rtc_a, the byte on rtc_do a clock later. Registers 0 seconds, 2 minutes,
 4 hours, 7 day, 8 month, 9 year (00..99 = 2000..2099). They are read round and round; a value is
 computed after every round (the date in days since 1970-01-01, then the seconds) and published
 when two rounds in a row agree (a round across a change of the registers gives a mix) and it
 differs from the last one. Nothing is published while the registers read as zero (no RTC
 answer: the month is 0).
*/
module gb_rtc (
	input  wire        clk,
	output wire [7:0]  rtc_a,
	input  wire [7:0]  rtc_do,
	output reg  [32:0] rtc_time = 33'd0,
	output reg         valid = 1'b0      // a time has been published
);

reg [2:0] ri = 3'd0;      // the register being addressed: 0 s, 1 min, 2 h, 3 day, 4 month, 5 year
reg [2:0] rq = 3'd0;      // the one whose byte is on rtc_do
assign rtc_a = ri == 3'd0 ? 8'h00 : ri == 3'd1 ? 8'h02 : ri == 3'd2 ? 8'h04 :
               ri == 3'd3 ? 8'h07 : ri == 3'd4 ? 8'h08 : 8'h09;

function [6:0] bcd;
	input [7:0] b;
	begin
		bcd = { 3'd0, b[7:4] } * 7'd10 + { 3'd0, b[3:0] };
	end
endfunction

wire [6:0] b = bcd(rtc_do);

reg [5:0] sec = 6'd0, min = 6'd0;
reg [4:0] hour = 5'd0, day = 5'd0;
reg [3:0] mon = 4'd0;
reg [6:0] yy = 7'd0;

// days before the month (not a leap year)
function [8:0] cum;
	input [3:0] m;
	begin
		case (m)
			4'd1: cum = 9'd0;   4'd2: cum = 9'd31;  4'd3: cum = 9'd59;  4'd4: cum = 9'd90;
			4'd5: cum = 9'd120; 4'd6: cum = 9'd151; 4'd7: cum = 9'd181; 4'd8: cum = 9'd212;
			4'd9: cum = 9'd243; 4'd10: cum = 9'd273; 4'd11: cum = 9'd304; default: cum = 9'd334;
		endcase
	end
endfunction

// the computation, one step a clock after a round of reads
reg [2:0]  step = 3'd0;
reg [15:0] days = 16'd0;
reg [31:0] ts = 32'd0;
reg [31:0] ts_prev = 32'd0;   // the value of the round before

always @(posedge clk) begin
	rq <= ri;
	ri <= ri == 3'd5 ? 3'd0 : ri + 3'd1;
	case (rq)
		3'd0: sec <= b[5:0];
		3'd1: min <= b[5:0];
		3'd2: hour <= b[4:0];
		3'd3: day <= b[4:0];
		3'd4: mon <= b[3:0];
		default: begin
			yy <= b;
			if (step == 3'd0) step <= 3'd1;
		end
	endcase

	case (step)
		3'd1: begin   // 1970..1999 = 10957 days, then the years since 2000 (2000 is a leap year)
			days <= 16'd10957 + { 9'd0, yy } * 16'd365 + { 11'd0, (yy + 7'd3) >> 2 };
			step <= 3'd2;
		end
		3'd2: begin
			days <= days + { 7'd0, cum(mon) } + ((yy[1:0] == 2'b00 && mon > 4'd2) ? 16'd1 : 16'd0)
				+ { 11'd0, day } - 16'd1;
			step <= 3'd3;
		end
		3'd3: begin
			ts <= { 16'd0, days } * 32'd86400;
			step <= 3'd4;
		end
		3'd4: begin
			ts <= ts + { 27'd0, hour } * 32'd3600 + { 26'd0, min } * 32'd60 + { 26'd0, sec };
			step <= 3'd5;
		end
		3'd5: begin
			ts_prev <= ts;
			if (mon != 4'd0 && ts == ts_prev && ts != rtc_time[31:0]) begin
				rtc_time <= { ~rtc_time[32], ts };
				valid <= 1'b1;
			end
			step <= 3'd0;
		end
		default: ;
	endcase
end

endmodule

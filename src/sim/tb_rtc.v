`timescale 1ns / 1ps
`default_nettype wire

/*
 tb_rtc.v - iverilog check of gb_rtc.v (sim/run_bk.sh, a second): a model of the RTC port of
 kg_mcu2 (MC146818 registers in BCD, the byte a clock after the address) set to dates around leap
 years and the ends of months / years / the century; the published rtc_time must equal the Unix
 seconds (calendar.timegm of Python) and its toggle must flip once per new value. Registers all
 zero (no RTC) publish nothing. Prints "tb_rtc: 0 errors".
*/

module tb_rtc;

reg clk = 1'b0;
always #15 clk = ~clk;

integer errors = 0;

reg [7:0] regs [0:15];
wire [7:0] rtc_a;
reg  [7:0] rtc_do = 8'd0;
always @(posedge clk) rtc_do <= regs[rtc_a[3:0]];

wire [32:0] rtc_time;
wire valid;
gb_rtc dut (.clk(clk), .rtc_a(rtc_a), .rtc_do(rtc_do), .rtc_time(rtc_time), .valid(valid));

function [7:0] tobcd;
	input integer v;
	begin
		tobcd = ((v / 10) % 10) * 16 + v % 10;
	end
endfunction

integer i;
reg tg;
task set_and_check(input integer y, input integer mo, input integer d, input integer h, input integer mi,
                   input integer s, input [31:0] want);
	begin
		regs[0] = tobcd(s); regs[2] = tobcd(mi); regs[4] = tobcd(h);
		regs[7] = tobcd(d); regs[8] = tobcd(mo); regs[9] = tobcd(y % 100);
		tg = rtc_time[32];
		repeat (40) @(posedge clk);
		if (rtc_time[31:0] !== want || rtc_time[32] === tg || !valid) begin
			$display("ERROR %0d-%0d-%0d %0d:%0d:%0d: got %0d (toggle %b -> %b, valid %b), want %0d",
				y, mo, d, h, mi, s, rtc_time[31:0], tg, rtc_time[32], valid, want);
			errors = errors + 1;
		end
		tg = rtc_time[32];
		repeat (40) @(posedge clk);
		if (rtc_time[32] !== tg) begin
			$display("ERROR %0d-%0d-%0d: toggle flipped with no new time", y, mo, d);
			errors = errors + 1;
		end
	end
endtask

initial begin
	for (i = 0; i < 16; i = i + 1) regs[i] = 8'd0;
	repeat (40) @(posedge clk);
	if (valid) begin $display("ERROR: published with the registers at zero"); errors = errors + 1; end
	set_and_check(2026, 11, 26, 17, 5, 42, 32'd1795712742);
	set_and_check(2000, 1, 1, 0, 0, 0, 32'd946684800);
	set_and_check(2000, 3, 1, 12, 0, 0, 32'd951912000);
	set_and_check(2012, 2, 29, 23, 59, 59, 32'd1330559999);
	set_and_check(2024, 12, 31, 23, 59, 59, 32'd1735689599);
	set_and_check(2099, 12, 31, 23, 59, 59, 32'd4102444799);
	set_and_check(2023, 3, 1, 0, 0, 1, 32'd1677628801);
	$display("tb_rtc: %0d errors", errors);
	$finish;
end

endmodule

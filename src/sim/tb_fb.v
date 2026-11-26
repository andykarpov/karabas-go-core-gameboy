`timescale 1ns / 1ps
`default_nettype wire

/*
 tb_fb.v - iverilog check of gb_fb.v (sim/run_fb.sh, ~30 s each, after tb_fb.v of core-wonderswan):
 three pattern frames (frame f, pixel x, y -> RGB555 { x[4:0] + f, y[4:0] + 2f, (x + y)[4:0] + 3f },
 -DGB=1: shade (x + y + f) & 3) written as gb_machine does it (lcd_vsync, then one pixel per
 lcd_ce & lcd_clkena, lcd_ce every 8 clk_sys), an asynchronous SRAM model (10 ns), then the 800 x 600
 output of the next whole frame compared pixel by pixel (-DBLEND=0/1): 4 x 4 blocks at (80, 12),
 the mean of the last 1..2 frames, black around; de 800 x 600.
*/

`ifndef BLEND
`define BLEND 0
`endif
`ifndef GB
`define GB 0
`endif

module tb_fb;

reg clk = 0, clk_vid = 0;
always #14.894 clk = ~clk;       // 33.571 MHz
always #12.5 clk_vid = ~clk_vid; // 40 MHz

reg lcd_ce = 0, lcd_clkena = 0, lcd_vsync = 0;
reg [14:0] lcd_data = 0;
reg [1:0] lcd_data_gb = 0;

wire [20:0] MA;
wire [15:0] MD;
wire [1:0] MWR_N, MRD_N;
wire [23:0] rgb;
wire hs, vs, de;

gb_fb dut (
	.clk(clk), .lcd_ce(lcd_ce), .lcd_clkena(lcd_clkena), .lcd_data(lcd_data), .lcd_data_gb(lcd_data_gb),
	.lcd_on(1'b1), .lcd_vsync(lcd_vsync), .is_gbc(`GB == 0), .blend(`BLEND == 1), .palette(2'd0), .cc(1'b0),
	.MA(MA), .MD(MD), .MWR_N(MWR_N), .MRD_N(MRD_N),
	.clk_vid(clk_vid), .rgb(rgb), .hs(hs), .vs(vs), .de(de)
);

// the SRAM: 2M x 16, asynchronous
reg [15:0] sram [0:(1 << 21) - 1];
assign #10 MD = (MRD_N == 2'b00 && MWR_N == 2'b11) ? sram[MA] : 16'bzzzzzzzzzzzzzzzz;
always @(posedge MWR_N[0]) sram[MA] <= MD;

// a pixel as RGB555 { r, g, b } (the GBC lcd_data is BGR555: r in [4:0])
function [14:0] pat;
	input integer x, y, f;
	reg [4:0] r, g, b, s;
	begin
		if (`GB) begin
			s = (x + y + f) & 3;
			s = s == 0 ? 31 : s == 1 ? 21 : s == 2 ? 10 : 0;
			pat = { s, s, s };
		end
		else begin
			r = x[4:0] + f[4:0]; g = y[4:0] + 2 * f[4:0]; b = x[4:0] + y[4:0] + 3 * f[4:0];
			pat = { r, g, b };
		end
	end
endfunction

// a channel of the mean of the last n frames (as gb_fb: 1 frame v * 33 / 4, 2 frames s * 33 / 8)
function [7:0] mixc;
	input integer s, n;
	integer m;
	begin
		if (n == 1) m = (s * 33) / 4; else m = (s * 33) / 8;
		mixc = m[7:0];
	end
endfunction

function [23:0] want_px;
	input integer sx, sy;
	integer f, n, sr, sg, sb;
	reg [14:0] q;
	begin
		n = `BLEND + 1; sr = 0; sg = 0; sb = 0;
		for (f = 3 - n; f < 3; f = f + 1) begin
			q = pat(sx, sy, f);
			sr = sr + q[14:10]; sg = sg + q[9:5]; sb = sb + q[4:0];
		end
		want_px = { mixc(sr, n), mixc(sg, n), mixc(sb, n) };
	end
endfunction

// the writer: one frame (lcd_ce every 8 clocks, lcd_clkena on the pixels)
integer x, y, k;
reg [14:0] p;
task write_frame(input integer f);
	begin
		@(posedge clk); lcd_vsync <= 1;
		repeat (4) @(posedge clk);
		lcd_vsync <= 0;
		for (y = 0; y < 144; y = y + 1) begin
			for (x = 0; x < 160; x = x + 1) begin
				p = pat(x, y, f);
				lcd_data <= { p[4:0], p[9:5], p[14:10] };   // BGR555
				lcd_data_gb <= (x + y + f) & 3;
				lcd_clkena <= 1;
				lcd_ce <= 1;
				@(posedge clk);
				lcd_ce <= 0;
				for (k = 0; k < 7; k = k + 1) @(posedge clk);
			end
			lcd_clkena <= 0;
			repeat (64) @(posedge clk);      // some of the h-blank
		end
	end
endtask

// the output: counted in clk_vid on de; checked in the frame after the one where the writer finished
integer ox = 0, oy = 0, errors = 0, checked = 0, frames = 0;
reg de_d = 0, vs_d = 0;
reg check = 0;
reg [23:0] want;
always @(posedge clk_vid) begin
	de_d <= de;
	vs_d <= vs;
	if (vs && !vs_d) begin
		frames = frames + 1;
		oy = 0;
	end
	if (de) begin
		if (check) begin
			if (ox >= 80 && ox < 80 + 640 && oy >= 12 && oy < 12 + 576)
				want = want_px((ox - 80) / 4, (oy - 12) / 4);
			else
				want = 24'd0;
			if (rgb !== want) begin
				if (errors < 10) $display("pixel %0d,%0d: %06x, want %06x", ox, oy, rgb, want);
				errors = errors + 1;
			end
			checked = checked + 1;
		end
		ox = ox + 1;
	end
	if (!de && de_d) begin
		if (ox != 800) begin $display("line %0d: %0d pixels of de", oy, ox); errors = errors + 1; end
		ox = 0;
		oy = oy + 1;
	end
end

integer f0;
initial begin
	write_frame(0);
	write_frame(1);
	write_frame(2);
	// the reader takes the buffer at the next frame start: check the frame after that
	f0 = frames;
	wait (frames == f0 + 1);
	check = 1;
	wait (frames == f0 + 2);
	check = 0;
	if (checked != 800 * 600) begin $display("checked %0d pixels, want %0d", checked, 800 * 600); errors = errors + 1; end
	if (errors == 0) $display("PASS gb %0d blend %0d", `GB, `BLEND); else $display("FAIL gb %0d blend %0d: %0d errors", `GB, `BLEND, errors);
	$finish;
end

endmodule

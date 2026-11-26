`timescale 1ns / 1ps
`default_nettype wire

/*
 gb_fb.v (after ws_fb.v of karabas-go-core-wonderswan)

 The 160 x 144 LCD of gb_machine through a frame buffer in the SRAM of the board, out as 800 x 600
 at 60 Hz (VESA, 40 MHz), every source pixel 4 x 4 (640 x 576) at (80, 12). The output does not
 follow the 59.73 Hz of the Game Boy: the writer goes round a ring of 8 frame buffers, the reader
 shows the last complete frame (one is shown twice now and then), so no frame is torn.

 blend (taken at the start of an output frame): 0 the last frame; 1 the mean of the last two (the
 LCD ghosting some games count on for transparency, "frame blend" of MiSTer).
 palette (GB): the four shades as 0 grey, 1 green (DMG), 2 Pocket, 3 light green (BGB);
 cc (GBC): 1 = the LCD colour correction of Gambatte (R = (13 r + 2 g + b) / 2, G = (3 g + b) * 2,
 B = (3 r + 2 g + 11 b) / 2 of the 5-bit channels, to 8 bits), 0 = the raw BGR555.
 Both are applied to the pixel when it is written (a change shows from the next frame).

 Write side (clk = clk_sys): a pixel is lcd_ce & lcd_clkena (as lcd.v of MiSTer) while the LCD is on,
 in raster order from lcd_vsync; GBC: lcd_data BGR555, GB: lcd_data_gb shade 0..3 (light .. dark)
 through the palette. One SRAM word each (RGB555) at { buffer (3 bits), y * 160 + x (15) }; pixel 23039
 ends a frame: that buffer becomes the last complete one, the writer takes the next of the ring. In
 one output frame the writer completes at most one frame, so it never reaches the two shown. A pixel
 comes every 8 clocks at most.

 SRAM (2M x 16, 10 ns, asynchronous) on clk (33.57 MHz, 29.8 ns): a read holds the address two clocks
 and takes MD at the second edge (reads go back to back, two clocks each); a write is four clocks
 (/OE off with the address, MD driven and /WE low, /WE high, MD released). A source line (160 pixels)
 takes 1..2 reads a pixel: at most 640 clocks of the 3540 of 4 output lines.

 Read side (clk_vid, 40 MHz): the VESA timing 1056 x 628 (800 + 40 + 128 + 88, 600 + 1 + 4 + 23),
 positive syncs. A source line is read from the SRAM into a line buffer (block RAM, two lines of
 24-bit pixels, the frames already mixed) while the line before is shown: line 0 eight output lines
 before the picture, line 1 at its start, line n + 2 after the last output line of n. The requests
 cross to clk with a toggle (the line, buffer and mode held stable meanwhile); the frame number
 crosses as two agreeing samples.

 hs / vs / de are positive, rgb is 8:8:8. The picture area is black until the first complete frame.
*/

module gb_fb (
	input  wire        clk,
	input  wire        lcd_ce,
	input  wire        lcd_clkena,
	input  wire [14:0] lcd_data,
	input  wire [1:0]  lcd_data_gb,
	input  wire        lcd_on,
	input  wire        lcd_vsync,
	input  wire        is_gbc,
	input  wire        blend,
	input  wire [1:0]  palette,
	input  wire        cc,

	output reg  [20:0] MA = 21'd0,
	inout  wire [15:0] MD,
	output reg  [1:0]  MWR_N = 2'b11,
	output reg  [1:0]  MRD_N = 2'b11,

	input  wire        clk_vid,
	output reg  [23:0] rgb = 24'd0,
	output reg         hs = 1'b0,
	output reg         vs = 1'b0,
	output reg         de = 1'b0
);

// ================================================================== write side (clk)

reg [2:0] wbuf = 3'd0;
reg [2:0] last = 3'd0;
reg       have = 1'b0;                 // a complete frame exists

// the pixel position
reg        vs_d = 1'b0;
reg [14:0] pix_a = 15'd0;              // y * 160 + x

// the colour of a pixel: RGB555
function [14:0] pal;            // palette p, shade n: RGB555 of the RGB888 values
	input [1:0] p;
	input [1:0] n;
	reg [23:0] c;
	begin
		case ({ p, n })
			4'h0: c = 24'hFFFFFF; 4'h1: c = 24'hAAAAAA; 4'h2: c = 24'h555555; 4'h3: c = 24'h000000;
			4'h4: c = 24'h9BBC0F; 4'h5: c = 24'h8BAC0F; 4'h6: c = 24'h306230; 4'h7: c = 24'h0F380F;
			4'h8: c = 24'hC4CFA1; 4'h9: c = 24'h8B956D; 4'hA: c = 24'h4D533C; 4'hB: c = 24'h1F1F1F;
			4'hC: c = 24'hE0F8D0; 4'hD: c = 24'h88C070; 4'hE: c = 24'h346856; default: c = 24'h081820;
		endcase
		pal = { c[23:19], c[15:11], c[7:3] };
	end
endfunction
wire [4:0] c_r = lcd_data[4:0], c_g = lcd_data[9:5], c_b = lcd_data[14:10];
wire [8:0] cc_r = ({ 4'd0, c_r } * 9'd13 + { 4'd0, c_g } * 9'd2 + { 4'd0, c_b }) >> 1;
wire [8:0] cc_g = ({ 4'd0, c_g } * 9'd3 + { 4'd0, c_b }) << 1;
wire [8:0] cc_b = ({ 4'd0, c_r } * 9'd3 + { 4'd0, c_g } * 9'd2 + { 4'd0, c_b } * 9'd11) >> 1;
wire [14:0] gbc_rgb = cc ? { cc_r[7:3], cc_g[7:3], cc_b[7:3] } : { c_r, c_g, c_b };
wire [14:0] pix_rgb = is_gbc ? gbc_rgb : pal(palette, lcd_data_gb);

// line requests from clk_vid (the toggle and the line / buffer / mode it asks for)
wire       req_t_v;
wire [7:0] req_line_v;
wire       req_lbuf_v;
wire [2:0] req_fbuf_v;
wire       req_n_v;

// pending pixel
reg        pw = 1'b0;
reg [17:0] pw_addr = 18'd0;
reg [14:0] pw_data = 15'd0;

localparam S_IDLE = 3'd0, S_W1 = 3'd1, S_W2 = 3'd2, S_W3 = 3'd3, S_R1 = 3'd4;
reg [2:0]  st = S_IDLE;
reg        md_oe = 1'b0;
reg [15:0] md_out = 16'd0;
assign MD = md_oe ? md_out : 16'bzzzzzzzzzzzzzzzz;
wire sram_wr_take = st == S_IDLE && pw;

always @(posedge clk) begin
	vs_d <= lcd_vsync;
	if (sram_wr_take) pw <= 1'b0;
	if (lcd_vsync && !vs_d)
		pix_a <= 15'd0;
	else if (lcd_ce && lcd_clkena && lcd_on && pix_a != 15'd23040) begin
		pw <= 1'b1;
		pw_addr <= { wbuf, pix_a };
		pw_data <= pix_rgb;
		pix_a <= pix_a + 15'd1;
		if (pix_a == 15'd23039) begin
			last <= wbuf;
			have <= 1'b1;
			wbuf <= wbuf + 3'd1;
		end
	end
end

// ------------------------------------------------------------------ line requests, SRAM

reg [2:0]  req_s = 3'd0;
reg        job = 1'b0;
reg [14:0] job_a = 15'd0;          // the source address of the pixel
reg [7:0]  job_x = 8'd0;
reg        job_k = 1'b0;           // the frame of the pixel being read: last - k
reg        job_n = 1'b0;           // frames - 1
reg        job_lbuf = 1'b0;
reg [2:0]  job_fbuf = 3'd0;

// the tags of a read, two stages (the data comes two edges after the address)
reg        t_v = 1'b0, t_v_d = 1'b0;
reg        t_k = 1'b0, t_k_d = 1'b0;
reg        t_end = 1'b0, t_end_d = 1'b0;   // the last frame of the pixel
reg [8:0]  t_wa = 9'd0, t_wa_d = 9'd0;
reg        t_n = 1'b0, t_n_d = 1'b0;
// a third stage: MD into a register first (TS_SRAM_IN 10 ns), mixed a clock later
reg        t_v_q = 1'b0, t_end_q = 1'b0, t_k_q = 1'b0, t_n_q = 1'b0;
reg [8:0]  t_wa_q = 9'd0;
reg [14:0] md_q = 15'd0;

reg [5:0]  acc_r = 6'd0, acc_g = 6'd0, acc_b = 6'd0;
reg        lb_we = 1'b0;
reg [8:0]  lb_wa = 9'd0;
reg [23:0] lb_wd = 24'd0;

wire [5:0] s_r = (t_k_q ? acc_r : 6'd0) + { 1'b0, md_q[14:10] };
wire [5:0] s_g = (t_k_q ? acc_g : 6'd0) + { 1'b0, md_q[9:5] };
wire [5:0] s_b = (t_k_q ? acc_b : 6'd0) + { 1'b0, md_q[4:0] };

// a channel to 8 bits: 1 frame v * 33 / 4 (31 -> 255), 2 frames s * 33 / 8 (62 -> 255)
function [7:0] mix;
	input [5:0] v;
	input       n;
	reg [11:0] m;
	begin
		m = { 6'd0, v } * 12'd33;
		mix = n ? m[10:3] : m[9:2];
	end
endfunction

always @(posedge clk) begin
	req_s <= { req_s[1:0], req_t_v };
	if (req_s[2] != req_s[1]) begin
		job <= 1'b1;
		job_lbuf <= req_lbuf_v;
		job_fbuf <= req_fbuf_v;
		job_n <= req_n_v;
		job_x <= 8'd0;
		job_k <= 1'b0;
		job_a <= { req_line_v, 7'd0 } + { 2'd0, req_line_v, 5'd0 };   // * 160
	end

	t_v <= 1'b0;
	case (st)
	S_IDLE:
		if (pw) begin
			MRD_N <= 2'b11;
			MA <= { 3'b000, pw_addr };
			md_out <= { 1'b0, pw_data };
			st <= S_W1;
		end
		else if (job) begin
			MRD_N <= 2'b00;
			MA <= { 3'b000, job_fbuf - { 2'b00, job_k }, job_a };
			t_v <= 1'b1;
			t_k <= job_k;
			t_end <= job_k == job_n;
			t_wa <= { job_lbuf, job_x };
			t_n <= job_n;
			if (job_k == job_n) begin
				job_k <= 1'b0;
				if (job_x == 8'd159) job <= 1'b0;
				job_x <= job_x + 8'd1;
				job_a <= job_a + 15'd1;
			end
			else
				job_k <= 1'b1;
			st <= S_R1;
		end
		else
			MRD_N <= 2'b11;
	S_W1: begin
		md_oe <= 1'b1;
		MWR_N <= 2'b00;
		st <= S_W2;
	end
	S_W2: begin
		MWR_N <= 2'b11;
		st <= S_W3;
	end
	S_W3: begin
		md_oe <= 1'b0;
		st <= S_IDLE;
	end
	S_R1: st <= S_IDLE;
	default: st <= S_IDLE;
	endcase

	// the read data: the address was set two edges ago (S_IDLE -> S_R1 -> here)
	t_v_d <= t_v;
	t_k_d <= t_k;
	t_end_d <= t_end;
	t_wa_d <= t_wa;
	t_n_d <= t_n;
	t_v_q <= t_v_d;
	t_k_q <= t_k_d;
	t_end_q <= t_end_d;
	t_wa_q <= t_wa_d;
	t_n_q <= t_n_d;
	md_q <= MD[14:0];
	lb_we <= 1'b0;
	if (t_v_q) begin       // reads of one pixel are two clocks apart at least: acc is ready
		acc_r <= s_r;
		acc_g <= s_g;
		acc_b <= s_b;
		if (t_end_q) begin
			lb_we <= 1'b1;
			lb_wa <= t_wa_q;
			lb_wd <= { mix(s_r, t_n_q), mix(s_g, t_n_q), mix(s_b, t_n_q) };
		end
	end
end

// ================================================================== line buffer

wire [23:0] lb_q;
reg  [8:0]  lb_ra = 9'd0;
kg_sdpram #(.DW(24), .AW(9)) line_buf (
	.clka(clk),
	.wea(lb_we),
	.addra(lb_wa),
	.dina(lb_wd),
	.clkb(clk_vid),
	.enb(1'b1),
	.addrb(lb_ra),
	.doutb(lb_q)
);

// ================================================================== read side (clk_vid)

localparam H_TOTAL = 11'd1056, H_SYNC0 = 11'd840, H_SYNC1 = 11'd968, H_ACT = 11'd800;
localparam V_TOTAL = 10'd628,  V_SYNC0 = 10'd601, V_SYNC1 = 10'd605, V_ACT = 10'd600;
localparam X0 = 11'd80, XE = 11'd720, Y0 = 10'd12;   // 640 x 576
localparam [7:0] NL = 8'd144;

reg [10:0] hc = 11'd0;
reg [9:0]  vc = 10'd0;

// the frame of the writer, two agreeing samples
wire [3:0] pub = { have, last };
reg  [3:0] pub_s1 = 4'd0, pub_s2 = 4'd0, pub_cur = 4'd0;
reg  [2:0] rbuf = 3'd0;
reg        rhave = 1'b0;

// the mode of the frame (blend from clk, sampled twice; quasi-static)
reg        mode_s1 = 1'b0, mode_s2 = 1'b0;
reg        f_n = 1'b0;

reg        req_t = 1'b0;
reg [7:0]  req_line = 8'd0;
reg        req_lbuf = 1'b0;
assign req_t_v = req_t;
assign req_line_v = req_line;
assign req_lbuf_v = req_lbuf;
assign req_fbuf_v = rbuf;
assign req_n_v = f_n;

reg        in_img = 1'b0;
reg [7:0]  sy = 8'd0;
reg [1:0]  sub = 2'd0;
reg [7:0]  pidx = 8'd0;         // the source pixel of the line
reg [1:0]  pxs = 2'd0;

reg p1_de = 1'b0, p1_hs = 1'b0, p1_vs = 1'b0, p1_pic = 1'b0;
reg p2_de = 1'b0, p2_hs = 1'b0, p2_vs = 1'b0, p2_pic = 1'b0;
reg p1_have = 1'b0, p2_have = 1'b0;

always @(posedge clk_vid) begin
	pub_s1 <= pub;
	pub_s2 <= pub_s1;
	if (pub_s1 == pub_s2) pub_cur <= pub_s2;
	mode_s1 <= blend;
	mode_s2 <= mode_s1;

	if (hc == H_TOTAL - 11'd1) begin
		hc <= 11'd0;
		vc <= vc == V_TOTAL - 10'd1 ? 10'd0 : vc + 10'd1;
	end
	else
		hc <= hc + 11'd1;

	// the start of a frame: the last complete buffer, the mode
	if (hc == 11'd0 && vc == V_SYNC1) begin
		rhave <= pub_cur[3];
		rbuf <= pub_cur[2:0];
		f_n <= mode_s2;
	end

	// lines: at the end of the line before (hc = H_SYNC0, the picture of the line is out)
	if (hc == H_SYNC0) begin
		if (vc == Y0 - 10'd8) begin   // line 0: 8 output lines before the picture
			req_line <= 8'd0;
			req_lbuf <= 1'b0;
			req_t <= ~req_t;
		end
		if (vc == Y0 - 10'd1) begin
			in_img <= 1'b1;
			sy <= 8'd0;
			sub <= 2'd0;
			req_line <= 8'd1;
			req_lbuf <= 1'b1;
			req_t <= ~req_t;
		end
		else if (in_img) begin
			if (sub == 2'd3) begin
				sub <= 2'd0;
				if (sy + 8'd1 == NL)
					in_img <= 1'b0;
				else begin
					sy <= sy + 8'd1;
					if (sy + 8'd2 < NL) begin
						req_line <= sy + 8'd2;
						req_lbuf <= sy[0];       // = (sy + 2) & 1
						req_t <= ~req_t;
					end
				end
			end
			else
				sub <= sub + 2'd1;
		end
	end

	// stage 1: the address of the source pixel
	if (hc == X0 - 11'd1) begin
		pidx <= 8'd0;
		pxs <= 2'd0;
	end
	else if (hc >= X0 && hc < XE) begin
		if (pxs == 2'd3) begin
			pxs <= 2'd0;
			pidx <= pidx + 8'd1;
		end
		else
			pxs <= pxs + 2'd1;
	end
	lb_ra <= { sy[0], pidx };
	p1_de <= hc < H_ACT && vc < V_ACT;
	p1_hs <= hc >= H_SYNC0 && hc < H_SYNC1;
	p1_vs <= vc >= V_SYNC0 && vc < V_SYNC1;
	p1_pic <= in_img && hc >= X0 && hc < XE;
	p1_have <= rhave;

	// stage 2: the pixel (lb_q is the data of lb_ra of the clock before)
	p2_de <= p1_de;
	p2_hs <= p1_hs;
	p2_vs <= p1_vs;
	p2_pic <= p1_pic;
	p2_have <= p1_have;

	de <= p2_de;
	hs <= p2_hs;
	vs <= p2_vs;
	// the picture; black there until the machine has finished a frame
	rgb <= !p2_pic || !p2_have ? 24'd0 : lb_q;
end

endmodule

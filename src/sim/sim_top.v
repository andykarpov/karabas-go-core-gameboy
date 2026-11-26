`timescale 1ns / 1ps
`default_nettype wire

/*
 sim_top.v - the machine part of karabas_minig_top.v for the verilator simulation: gb_loader (the
 file bytes from the harness), gb_machine (the VHDL through ghdl --synth), gb_mem + gb_sdram on
 sdram_model. The frame buffer and the board video are left out: the harness takes the LCD pixels.

 clk_sys and clk_ram (3 x) are driven by the harness, rising together.
*/

module sim_top (
	input  wire        clk_sys,
	input  wire        clk_ram,
	input  wire        init,

	input  wire        file_active,
	input  wire        file_wr,
	input  wire [31:0] file_addr,
	input  wire [7:0]  file_data,

	input  wire [1:0]  model,
	input  wire        fast_boot,
	input  wire [7:0]  joy,

	output wire        lcd_ce,
	output wire        lcd_clkena,
	output wire [14:0] lcd_data,
	output wire [1:0]  lcd_data_gb,
	output wire        lcd_on,
	output wire        lcd_vsync,
	output wire        is_gbc,
	output wire [15:0] audio_l,
	output wire [15:0] audio_r,
	output wire        cart_ready,
	output wire [31:0] sdram_errors,
	output wire        mem_rd,
	output wire [22:0] mem_addr,
	output wire [7:0]  mem_q
);

wire [25:1] ld_sdr_addr;
wire [15:0] ld_sdr_din;
wire ld_sdr_req, dl, dl_wr, loading;
wire [24:0] dl_addr;
wire [15:0] dl_data;
gb_loader loader (
	.clk(clk_sys),
	.file_active(file_active), .file_wr(file_wr), .file_addr(file_addr), .file_data(file_data),
	.sdr_addr(ld_sdr_addr), .sdr_din(ld_sdr_din), .sdr_req(ld_sdr_req),
	.dl(dl), .dl_wr(dl_wr), .dl_addr(dl_addr), .dl_data(dl_data),
	.loading(loading), .cart_ready(cart_ready), .has_timer()
);

reg [7:0] rst_cnt = 8'd0;
reg gb_reset = 1'b1;
always @(posedge clk_sys) begin
	if (init || loading || !cart_ready)
		rst_cnt <= 8'd0;
	else if (rst_cnt != 8'hFF)
		rst_cnt <= rst_cnt + 8'd1;
	gb_reset <= rst_cnt != 8'hFF;
end

wire mem_wr, mem_cram;
wire [16:0] mem_cram_addr;
wire [7:0] mem_din;
gb_machine gb (
	.clk_sys(clk_sys), .reset(gb_reset), .model(model), .fast_boot(fast_boot), .joy(joy),
	.dl(dl), .dl_wr(dl_wr), .dl_addr(dl_addr), .dl_data(dl_data), .dl_wait(),
	.mem_rd(mem_rd), .mem_wr(mem_wr), .mem_cram(mem_cram), .mem_addr(mem_addr),
	.mem_cram_addr(mem_cram_addr), .mem_din(mem_din), .mem_q(mem_q),
	.ram_mask_file(), .has_save(), .bram_save(),
	.rtc_time(33'd0), .bk_rtc_wr(1'b0), .bk_addr(17'd0), .bk_data(16'd0), .rtc_timestamp(), .rtc_savedtime(),
	.lcd_ce(lcd_ce), .lcd_clkena(lcd_clkena), .lcd_data(lcd_data), .lcd_data_gb(lcd_data_gb),
	.lcd_mode(), .lcd_on(lcd_on), .lcd_vsync(lcd_vsync), .is_gbc(is_gbc),
	.audio_l(audio_l), .audio_r(audio_r), .speed()
);

wire [25:1] m_sdr_addr;
wire [15:0] m_sdr_din, m_sdr_dout;
wire [1:0] m_sdr_be;
wire m_sdr_req, m_sdr_rnw, m_sdr_ready, refresh;
gb_mem mem (
	.clk(clk_sys), .loading(loading),
	.mem_rd(mem_rd), .mem_wr(mem_wr), .mem_cram(mem_cram), .mem_addr(mem_addr),
	.mem_cram_addr(mem_cram_addr), .mem_din(mem_din), .mem_q(mem_q),
	.sdr_addr(m_sdr_addr), .sdr_din(m_sdr_din), .sdr_be(m_sdr_be), .sdr_req(m_sdr_req),
	.sdr_rnw(m_sdr_rnw), .sdr_dout(m_sdr_dout), .sdr_ready(m_sdr_ready), .refresh(refresh)
);

wire [15:0] dq;
wire [12:0] a;
wire [1:0] ba;
wire dqml, dqmh, cs_n, we_n, ras_n, cas_n;
gb_sdram sdram (
	.init(init), .clk(clk_ram), .doRefresh(refresh),
	.SDRAM_DQ(dq), .SDRAM_A(a), .SDRAM_DQML(dqml), .SDRAM_DQMH(dqmh), .SDRAM_BA(ba),
	.SDRAM_nCS(cs_n), .SDRAM_nWE(we_n), .SDRAM_nRAS(ras_n), .SDRAM_nCAS(cas_n),
	.ch1_addr(ld_sdr_addr), .ch1_dout(), .ch1_din(ld_sdr_din), .ch1_req(ld_sdr_req), .ch1_rnw(1'b0), .ch1_ready(),
	.ch2_addr(25'd0), .ch2_dout(), .ch2_din(16'd0), .ch2_req(1'b0), .ch2_rnw(1'b1), .ch2_ready(),
	.ch3_addr(m_sdr_addr), .ch3_dout(m_sdr_dout), .ch3_din(m_sdr_din), .ch3_be(m_sdr_be),
	.ch3_req(m_sdr_req), .ch3_rnw(m_sdr_rnw), .ch3_ready(m_sdr_ready)
);

sdram_model chip (
	.clk(clk_ram), .dq(dq), .a(a), .ba(ba), .cs_n(cs_n), .ras_n(ras_n), .cas_n(cas_n), .we_n(we_n),
	.dqml(dqml), .dqmh(dqmh), .errors(sdram_errors)
);

endmodule

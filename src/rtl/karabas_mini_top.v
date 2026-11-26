`timescale 1ns / 1ps
`default_nettype wire

/*
 Nintendo Game Boy / Game Boy Color core for Karabas Mini before rev.G (HDMI, sigma-delta
 audio). Made by tools/mktops.py from karabas_minig_top.v (do not edit: change that one and run
 it): the same except the pins, the MCU link (MCU_SCK not on a clock pin) and the audio
 (AUDIO_L / AUDIO_R):
 the MiSTer Gameboy core (as in open-pocket-gbc, rtl/gb) in rtl/karabas/gb_machine.v, and the
 board glue of karabas-go-modules.

 Clocks (gb_clocks.v): clk_sys 33.571 MHz (the machine: ce = clk_sys / 8; the MCU link, the loader,
 the SRAM frame buffer writes, the audio), clk_ram 100.71 MHz (3 x clk_sys: the SDRAM), clk_vid
 40 MHz (800 x 600 at 60 Hz, the OSD, HDMI; FT_CLK_OUT 8 MHz), clk_ser / clk_ser_n 200 MHz.

 Saves: kg_bk_ram (.sav: the cartridge RAM, and the MBC3 clock as the RTC sector of MiSTer)
 through gb_bk.v; the MBC3 clock gets the time of the firmware RTC (gb_rtc.v).

 Memory: the cartridge ROM (up to 8 MB) and the cartridge RAM (at 8 MB) in the SDRAM (gb_sdram.v,
 the MiSTer WonderSwan controller, through gb_mem.v); the RAMs of the machine in block RAM (boot ROM:
 the SameBoy-based DMG / CGB ones of MiSTer, MIT); the SRAM holds the ring of frame buffers of
 gb_fb.v (the picture x 4 = 640 x 576 in 800 x 600).

 The cartridge: the file of the core (type fileloader: .gb, .gbc in the gameboy folder) through the
 file loader of kg_mcu2 into the SDRAM and, as the MiSTer ioctl download, to cart_top (gb_loader.v);
 the machine is held in reset until a cartridge is in.

 Sound: the gb audio (MiSTer gbc_snd: a DC offset of ~ +1800, peaks ~ 4000) through a DC blocker,
 x 4, + the ADC (PCM1808: the line in and the MIDI synth SAM2695 of the board, half scale) ->
 PCM5102, HDMI; the peaks of the mix to the mcu (audio_peaks: the level meters). The base set of
 the board otherwise: FT_CLK_OUT 8 MHz, MIDI_TX idle (no MIDI), TAPE_OUT 0 (no tape on a Game Boy).

 Soft switches (core.json osd order):
   0 Model (Auto / GBC / GB)   1 GB palette (Grey / Green / Pocket / Light)   2 GBC colours (LCD / Raw)
   3 Frame blend (Off / On)   4 Boot (Logo / Fast)   5 Reset
*/

module karabas_mini_top (
	input wire CLK_50MHZ,

	inout wire UART_RX,
	inout wire UART_TX,
	inout wire UART_CTS,
	inout wire ESP_RESET_N,
	inout wire ESP_BOOT_N,

	output wire [20:0] MA,
	inout wire [15:0] MD,
	output wire [1:0] MWR_N,
	output wire [1:0] MRD_N,

	output wire [1:0] SDR_BA,
	output wire [12:0] SDR_A,
	output wire SDR_CLK,
	output wire [1:0] SDR_DQM,
	output wire SDR_WE_N,
	output wire SDR_CAS_N,
	output wire SDR_RAS_N,
	inout wire [15:0] SDR_DQ,

	output wire SD_CS_N,
	output wire SD_CLK,
	output wire SD_DI,
	input wire SD_DO,
	input wire SD_DET_N,

	input wire [7:0] VGA_R,
	input wire [7:0] VGA_G,
	input wire [7:0] VGA_B,
	input wire VGA_HS,
	input wire VGA_VS,

	output wire [3:0] TMDS_P,
	output wire [3:0] TMDS_N,

	output wire FT_SPI_CS_N,
	output wire FT_SPI_SCK,
	input wire FT_SPI_MISO,
	output wire FT_SPI_MOSI,
	input wire FT_INT_N,
	input wire FT_CLK,
	input wire FT_DE,
	input wire FT_AUDIO,
	input wire FT_DISP,
	output wire FT_RESET,
	output wire FT_CLK_OUT,

	output wire [2:0] WA,
	output wire [1:0] WCS_N,
	output wire WRD_N,
	output wire WWR_N,
	output wire WRESET_N,
	inout wire [15:0] WD,

	output wire TAPE_OUT,
	input wire TAPE_IN,

	output wire AUDIO_L,
	output wire AUDIO_R,

	output wire ADC_CLK,
	inout wire ADC_BCK,
	inout wire ADC_LRCK,
	input wire ADC_DOUT,

	input wire MCU_CS_N,
	input wire MCU_SCK,
	inout wire MCU_MOSI,
	output wire MCU_MISO,
	inout wire [3:0] MCU_IO, // [1] INT of link v2, [2] sd2 cs_n, [3] ft cs_n

	output wire MIDI_TX,

	output wire MIDI_CLK,
	output wire MIDI_RESET_N,

	output wire FLASH_CS_N,
	input wire FLASH_DO,
	output wire FLASH_DI,
	output wire FLASH_SCK,
	output wire FLASH_WP_N,
	output wire FLASH_HOLD_N
);

// ------------------------------------------------------------------ unused

assign WA = 3'b000;
assign WCS_N = 2'b11;
assign WRD_N = 1'b1;
assign WWR_N = 1'b1;
assign WRESET_N = 1'b1;
assign WD = 16'bz;

assign TAPE_OUT = 1'b0;
assign UART_RX = 1'bz;
assign UART_TX = 1'bz;
assign UART_CTS = 1'bz;
assign MIDI_TX = 1'b1;
assign ESP_RESET_N = 1'bz;
assign ESP_BOOT_N = 1'bz;
assign MIDI_CLK = 1'b0;      // the SAM2695 synth: held in reset, no use for it here
assign MIDI_RESET_N = 1'b0;
assign FT_RESET = 1'b1;


// FLASH_CS_N (T3) is the SDRAM /CS of Mini G2 (rev G: tied low on the board): 0
assign FLASH_CS_N = 1'b0;
assign FLASH_DI = 1'b1;
assign FLASH_SCK = 1'b0;
assign FLASH_WP_N = 1'b1;
assign FLASH_HOLD_N = 1'b1;

// ------------------------------------------------------------------ clocks

wire clk_sys, clk_ram, clk_sdr, clk_vid, clk_ser, clk_ser_n, locked_sys, locked_vid;
gb_clocks clocks (
	.clk_in(CLK_50MHZ),
	.clk_sys(clk_sys),
	.clk_ram(clk_ram),
	.clk_sdr(clk_sdr),
	.clk_vid(clk_vid),
	.clk_ser(clk_ser),
	.clk_ser_n(clk_ser_n),
	.locked_sys(locked_sys),
	.locked_vid(locked_vid)
);
wire areset_async = ~(locked_sys & locked_vid);
wire areset_vid = ~locked_vid;   // the video group (HDMI) only: the OSD even when the machine clock fails
wire areset;
kg_sync #(.W(1), .STAGES(3), .INIT(1'b1)) sync_rst (.clk(clk_sys), .d(areset_async), .q(areset));

// the clock of the FT812 (it must always have one): 40 / 5 = 8 MHz, 50 % duty through the ODDR2
// (half periods 0..4 of the 10 high: D0 / D1 = the first / second half of a clk_vid period)
reg [2:0] ft_div = 3'd0;
reg ft_d0 = 1'b0, ft_d1 = 1'b0;
always @(posedge clk_vid) begin
	ft_div <= ft_div == 3'd4 ? 3'd0 : ft_div + 3'd1;
	ft_d0 <= ft_div == 3'd4 || ft_div == 3'd0 || ft_div == 3'd1;   // the value of the next period
	ft_d1 <= ft_div == 3'd4 || ft_div == 3'd0;
end
ODDR2 oddr_ft_clk (.Q(FT_CLK_OUT), .C0(clk_vid), .C1(~clk_vid), .CE(1'b1), .D0(ft_d0), .D1(ft_d1), .R(1'b0), .S(1'b0));

// ------------------------------------------------------------------ MCU

// MCU_SCK is not on a clock pin before rev.G (CLOCK_DEDICATED_ROUTE = FALSE in the ucf)
wire mcu_sck = MCU_SCK, mcu_sck_ibufg = MCU_SCK;

// MCU link v2 (karabas-go-firmware docs/link_v2.md, kg_mcu2); INT on IO1
wire mcu_int;
assign MCU_IO[1] = mcu_int;
assign MCU_IO[0] = 1'bz;
assign MCU_IO[3:2] = 2'bzz;

// the .sav file of kg_bk_ram (slot 0) on the mounter of kg_mcu2
wire [7:0] img_flush, sdc_img_mounted, sdc_rd, sdc_wr, sdc_byte_in_data, sdc_byte_out_data, bk_kind, bk_result;
wire [63:0] sdc_img_size;
wire [31:0] sdc_sector, bk_size;
wire sdc_busy, sdc_done, sdc_error, sdc_byte_in_strobe, bk_mount, bk_flushed;
wire [2:0] sdc_slot;
wire [8:0] sdc_byte_addr;

wire [7:0] rtc_a, rtc_do;

wire matrix_cmd_wr;
wire [23:0] matrix_cmd;

wire [55:0] hid_kbd;
wire [15:0] joy_l16, joy_r16;
wire [1:0] ld_kind;
wire [7:0] ld_data;
wire [31:0] ld_addr;
wire ld_active, ld_wr;
wire dvi_only;
wire ft_cs_n, ft_mosi, ft_spi_on, sd2_cs_n, sd2_mosi;
wire [6*8-1:0] sw;
wire osd_wr, osd_en, osd_zoom;
wire [11:0] osd_waddr;
wire [7:0] osd_wdata;
wire [23:0] osd_fg, osd_bg;
wire [1:0] osd_alpha, osd_place;
wire [4:0] osd_px, osd_ph;
wire [3:0] osd_py;
wire [5:0] osd_pw;


kg_mcu2 #(
	.CAPS(16'h0002),     // backup RAM: the firmware flushes the .sav before a new game
	.SW_N(6),
	.CS_FILTER(3),
	.ENABLE_OSD(1),
	.ENABLE_IMG(1),      // the .sav file of kg_bk_ram
	.IMG_OUT_LATENCY(2), // the sector buffer of kg_bk_ram
	.ENABLE_RTC(1),      // the firmware clock for the MBC3 RTC
	.ENABLE_AUX(1),      // MATRIX_CMD: the audio peaks
	.ENABLE_FT(1),
	.ENABLE_SD2(1)
) mcu (
	.CLK(clk_sys),
	.N_RESET(~areset),

	.MCU_SCK(mcu_sck),
	.MCU_MOSI(MCU_MOSI),
	.MCU_MISO(MCU_MISO),
	.MCU_SS(MCU_CS_N),
	.MCU_INT(mcu_int),
	.MCU_SPI_FT_SS(MCU_IO[3]),
	.MCU_SPI_SD2_SS(MCU_IO[2]),

	.SW(sw), .SW_WR(), .SW_INDEX(), .SW_VALUE(), .HW_ID(), .DVI_ONLY(dvi_only), .CORE_BUILD(), .FW_BUILD(),
	.BUSY(), .BTNS(), .RELOAD_REQ(1'b0), .RELOAD_CORE(8'd0),

	.KBD(hid_kbd), .KBD_WR(), .PS2_CODE(), .PS2_KIND(), .PS2_WR(),
	.MS_X(), .MS_Y(), .MS_Z(), .MS_B(), .MS_WR(),
	.JOY_L(joy_l16), .JOY_R(joy_r16), .JOY_WR(),
	.PS2_CMD(16'h0000), .PS2_CMD_WR(1'b0),

	.LD_KIND(ld_kind), .LD_SLOT(), .LD_SIZE(), .LD_START(), .LD_ACTIVE(ld_active), .LD_END(),
	.LD_ADDR(ld_addr), .LD_DATA(ld_data), .LD_WR(ld_wr), .LD_READY(1'b1),

	.OSD_WR(osd_wr), .OSD_WADDR(osd_waddr), .OSD_WDATA(osd_wdata), .OSD_EN(osd_en),
	.OSD_FG(osd_fg), .OSD_BG(osd_bg), .OSD_ALPHA(osd_alpha), .OSD_PX(osd_px), .OSD_PY(osd_py),
	.OSD_PW(osd_pw), .OSD_PH(osd_ph), .OSD_PLACE(osd_place), .OSD_ZOOM(osd_zoom),

	.SDC_IMG_MOUNTED(sdc_img_mounted), .SDC_IMG_SIZE(sdc_img_size),
	.SDC_RD(sdc_rd), .SDC_WR(sdc_wr), .SDC_SECTOR(sdc_sector),
	.SDC_BUSY(sdc_busy), .SDC_DONE(sdc_done), .SDC_ERROR(sdc_error), .SDC_SLOT(sdc_slot),
	.SDC_BYTE_IN_STROBE(sdc_byte_in_strobe), .SDC_BYTE_ADDR(sdc_byte_addr),
	.SDC_BYTE_IN_DATA(sdc_byte_in_data), .SDC_BYTE_OUT_DATA(sdc_byte_out_data),
	.IMG_WP(), .IMG_PHYS_WR(), .IMG_PHYS(), .IMG_FLUSH(img_flush), .FDD_CHNG_WR(), .FDD_CHNG(),
	.FDD_CHNG_REQ(1'b0), .FDD_CHNG_DS(2'd0),
	.BK_MOUNT(bk_mount), .BK_FLUSHED(bk_flushed), .BK_SLOT(3'd0), .BK_SIZE(bk_size),
	.BK_KIND(bk_kind), .BK_RESULT(bk_result),
	.IMG_ACTIVE(),

	.PORT_OUT_DATA(), .PORT_OUT_WR(), .PORT_OUT_READY(4'b1111), .PORT_IN_DATA(32'd0), .PORT_IN_WR(4'd0),
	.PORT_CFG(128'd0), .PORT_IN_FULL(), .PORT_STAT(), .PORT_STAT_WR(),
	.RTC_A(rtc_a), .RTC_DI(8'd0), .RTC_CS(1'b0), .RTC_WR_N(1'b1), .RTC_DO(rtc_do),
	.MATRIX_CMD(matrix_cmd), .MATRIX_CMD_WR(matrix_cmd_wr), .DEBUG_ADDR(16'd0), .DEBUG_DATA(16'd0),

	.FT_SPI_ON(ft_spi_on), .FT_VGA_ON(), .FT_RESET(), .FT_SCK(), .FT_MOSI(ft_mosi), .FT_MISO(FT_SPI_MISO),
	.FT_CS_N(ft_cs_n),
	.SD2_SCK(), .SD2_MOSI(sd2_mosi), .SD2_MISO(SD_DO), .SD2_CS_N(sd2_cs_n)
);

assign FT_SPI_CS_N = ft_spi_on ? ft_cs_n : 1'b1;
assign FT_SPI_SCK = ft_spi_on ? mcu_sck_ibufg : 1'b1;
assign FT_SPI_MOSI = ft_spi_on ? ft_mosi : 1'b1;
assign SD_CS_N = sd2_cs_n;
assign SD_DI = sd2_mosi;
assign SD_CLK = mcu_sck_ibufg;

// ------------------------------------------------------------------ soft switches (the SW registers of kg_mcu2)

wire [1:0] sw_model = sw[0*8 +: 2];   // 0 Auto, 1 GBC, 2 GB (gb_machine model)
wire [1:0] sw_pal = sw[1*8 +: 2];     // GB palette: 0 Grey, 1 Green, 2 Pocket, 3 Light
wire sw_raw = sw[2*8];                // GBC colours: 0 LCD (colour correction), 1 Raw
wire sw_blend = sw[3*8];              // 0 Off, 1 two frames mixed
wire sw_fast = sw[4*8];               // 0 the boot logo, 1 fast boot
wire sw_reset = sw[5*8];

// ------------------------------------------------------------------ cartridge

wire file_active = ld_active && ld_kind == 2'd1;
wire file_wr = ld_wr && ld_kind == 2'd1;

wire [25:1] ld_sdr_addr;
wire [15:0] ld_sdr_din;
wire ld_sdr_req, dl, dl_wr, loading, cart_ready, has_timer;
wire [24:0] dl_addr;
wire [15:0] dl_data;
gb_loader loader (
	.clk(clk_sys),
	.file_active(file_active), .file_wr(file_wr), .file_addr(ld_addr), .file_data(ld_data),
	.sdr_addr(ld_sdr_addr), .sdr_din(ld_sdr_din), .sdr_req(ld_sdr_req),
	.dl(dl), .dl_wr(dl_wr), .dl_addr(dl_addr), .dl_data(dl_data),
	.loading(loading), .cart_ready(cart_ready), .has_timer(has_timer)
);

// ------------------------------------------------------------------ save (.sav) and the MBC3 clock

// the size of the .sav (as MiSTer Gameboy.sv): the cartridge RAM of a battery cartridge (sectors =
// ram_mask_file + 1; MBC7 / TAMA5 keep theirs in block RAM: not saved here), then one RTC sector for
// MBC3 + TIMER. kg_bk_ram on img slot 0: started when a cartridge is in (loading falls); the machine
// is held in reset until the file is in. A new file resets it (the firmware flushes the old one
// before it loads another game).
wire [7:0] ram_mask_file;
wire has_save, bram_save;
reg [8:0] ram_secs = 9'd0;
reg [9:0] sav_secs = 10'd0;
always @(posedge clk_sys) begin
	ram_secs <= has_save && !bram_save ? { 1'b0, ram_mask_file } + 9'd1 : 9'd0;
	sav_secs <= { 1'b0, ram_secs } + { 9'd0, has_timer };
end

reg file_active_d = 1'b0, loading_d = 1'b0, bk_reset = 1'b0, bk_start = 1'b0;
always @(posedge clk_sys) begin
	file_active_d <= file_active;
	loading_d <= loading;
	bk_reset <= file_active && !file_active_d;
	bk_start <= loading_d && !loading;
end

// dirty marks: a cartridge RAM write (the rising edge of cram_wr) marks its sector, and the RTC
// sector a clock later (the game set its clock, or saves: the pair time / registers goes with it)
wire mem_rd, mem_wr, mem_cram;
wire [16:0] mem_cram_addr;
reg cw_d = 1'b0, rtc_mark = 1'b0;
reg sav_wr = 1'b0;
reg [17:0] sav_a = 18'd0;
always @(posedge clk_sys) begin
	cw_d <= mem_wr & mem_cram;
	sav_wr <= 1'b0;
	rtc_mark <= 1'b0;
	if (mem_wr && mem_cram && !cw_d) begin
		sav_wr <= mem_cram_addr[16:9] < ram_secs;
		sav_a <= { 1'b0, mem_cram_addr };
		rtc_mark <= has_timer;
	end
	else if (rtc_mark) begin
		sav_wr <= 1'b1;
		sav_a <= { ram_secs, 9'd0 };
	end
end

wire bk_busy, bk_mem_req, bk_mem_we, bk_mem_ack;
wire [17:0] bk_mem_addr;
wire [7:0] bk_mem_din, bk_mem_dout;
kg_bk_ram #(
	.SLOT(3'd0),
	.IDLE_CLOCKS(27'd33571000),    // ~1 s at 33.571 MHz: save after the last write
	.MAX_CLOCKS(27'd67142000),     // ~2 s: at the latest after the first write
	.MOUNT_CLOCKS(27'd33571000),   // ~1 s: no answer to the mount, go on without a save
	.GRACE_CLOCKS(27'd335710),     // ~10 ms: no file
	.LINK(2),                      // on the mounter of kg_mcu2
	.SBITS(9)                      // up to 128 KB + the RTC sector
) bk_ram (
	.clk(clk_sys),
	.reset(bk_reset),
	.start(bk_start),
	.size(sav_secs),
	.kind(8'h00),
	.busy(bk_busy),
	.mounted(),
	.saving(),
	.save_error(),
	.wr(sav_wr),
	.wr_addr(sav_a),
	.mem_req(bk_mem_req),
	.mem_we(bk_mem_we),
	.mem_addr(bk_mem_addr),
	.mem_din(bk_mem_din),
	.mem_ack(bk_mem_ack),
	.mem_dout(bk_mem_dout),
	.img_mounted(8'd0), .img_size(64'd0), .img_data_wr(1'b0), .img_data_addr(9'd0), .img_data(8'd0),
	.img_result_wr(1'b0), .img_result(8'd0), .img_sum(16'd0), .img_flush(img_flush),
	.img_q_wr(), .img_q_di(), .img_q_ack(1'b0),
	.sdc_img_mounted_i(sdc_img_mounted), .sdc_img_size_i(sdc_img_size), .sdc_rd_o(sdc_rd),
	.sdc_wr_o(sdc_wr), .sdc_sector_o(sdc_sector), .sdc_busy_i(sdc_busy), .sdc_done_i(sdc_done),
	.sdc_error_i(sdc_error), .sdc_slot_i(sdc_slot), .sdc_byte_in_strobe_i(sdc_byte_in_strobe),
	.sdc_byte_addr_i(sdc_byte_addr), .sdc_byte_in_data_i(sdc_byte_in_data),
	.sdc_byte_out_data_o(sdc_byte_out_data),
	.bk_mount(bk_mount), .bk_flushed(bk_flushed), .bk_size(bk_size), .bk_kind(bk_kind),
	.bk_result(bk_result)
);

wire [31:0] rtc_timestamp;
wire [47:0] rtc_savedtime;
wire bk_rtc_wr;
wire [16:0] bk_addr;
wire [15:0] bk_data;
wire [25:1] bk_sdr_addr;
wire [15:0] bk_sdr_din, bk_sdr_dout;
wire bk_sdr_req, bk_sdr_rnw, bk_sdr_ready;
gb_bk bk (
	.clk(clk_sys), .clk_ram(clk_ram), .ram_secs(ram_secs),
	.mem_req(bk_mem_req), .mem_we(bk_mem_we), .mem_addr(bk_mem_addr), .mem_din(bk_mem_din),
	.mem_ack(bk_mem_ack), .mem_dout(bk_mem_dout),
	.rtc_timestamp(rtc_timestamp), .rtc_savedtime(rtc_savedtime),
	.bk_rtc_wr(bk_rtc_wr), .bk_addr(bk_addr), .bk_data(bk_data),
	.sdr_addr(bk_sdr_addr), .sdr_din(bk_sdr_din), .sdr_req(bk_sdr_req), .sdr_rnw(bk_sdr_rnw),
	.sdr_dout(bk_sdr_dout), .sdr_ready(bk_sdr_ready)
);

// the time of the firmware RTC (core.json rtc_mode 2) as Unix seconds for the MBC3 clock
wire [32:0] rtc_time;
gb_rtc rtc (.clk(clk_sys), .rtc_a(rtc_a), .rtc_do(rtc_do), .rtc_time(rtc_time), .valid());

// reset: the PLLs, the Reset item, while a cartridge loads, until the first one is in, while the
// .sav file loads
reg [7:0] rst_cnt = 8'd0;
reg gb_reset = 1'b1;
always @(posedge clk_sys) begin
	if (areset || sw_reset || loading || !cart_ready || bk_busy)
		rst_cnt <= 8'd0;
	else if (rst_cnt != 8'hFF)
		rst_cnt <= rst_cnt + 8'd1;
	gb_reset <= rst_cnt != 8'hFF;
end

// ------------------------------------------------------------------ keys

wire [7:0] joy;
gb_kbd kbd (
	.clk(clk_sys),
	.kb_dat0(hid_kbd[15:8]), .kb_dat1(hid_kbd[23:16]), .kb_dat2(hid_kbd[31:24]),
	.kb_dat3(hid_kbd[39:32]), .kb_dat4(hid_kbd[47:40]), .kb_dat5(hid_kbd[55:48]),
	.joy_l(joy_l16[12:0]), .joy_r(joy_r16[12:0]),
	.joy(joy)
);

// ------------------------------------------------------------------ Game Boy

wire [22:0] mem_addr;
wire [7:0] mem_din, mem_q;
wire lcd_ce, lcd_clkena, lcd_on, lcd_vsync, is_gbc;
wire [14:0] lcd_data;
wire [1:0] lcd_data_gb;
wire [15:0] snd_l, snd_r;

gb_machine gb (
	.clk_sys(clk_sys),
	.reset(gb_reset),
	.model(sw_model),
	.fast_boot(sw_fast),
	.joy(joy),
	.dl(dl), .dl_wr(dl_wr), .dl_addr(dl_addr), .dl_data(dl_data), .dl_wait(),
	.mem_rd(mem_rd), .mem_wr(mem_wr), .mem_cram(mem_cram), .mem_addr(mem_addr),
	.mem_cram_addr(mem_cram_addr), .mem_din(mem_din), .mem_q(mem_q),
	.ram_mask_file(ram_mask_file), .has_save(has_save), .bram_save(bram_save),
	.rtc_time(rtc_time), .bk_rtc_wr(bk_rtc_wr), .bk_addr(bk_addr), .bk_data(bk_data),
	.rtc_timestamp(rtc_timestamp), .rtc_savedtime(rtc_savedtime),
	.lcd_ce(lcd_ce), .lcd_clkena(lcd_clkena), .lcd_data(lcd_data), .lcd_data_gb(lcd_data_gb),
	.lcd_mode(), .lcd_on(lcd_on), .lcd_vsync(lcd_vsync), .is_gbc(is_gbc),
	.audio_l(snd_l), .audio_r(snd_r),
	.speed()
);

// ------------------------------------------------------------------ SDRAM

wire [25:1] m_sdr_addr;
wire [15:0] m_sdr_din, m_sdr_dout;
wire [1:0] m_sdr_be;
wire m_sdr_req, m_sdr_rnw, m_sdr_ready, sdr_refresh;
gb_mem mem (
	.clk(clk_sys), .loading(loading),
	.mem_rd(mem_rd), .mem_wr(mem_wr), .mem_cram(mem_cram), .mem_addr(mem_addr),
	.mem_cram_addr(mem_cram_addr), .mem_din(mem_din), .mem_q(mem_q),
	.sdr_addr(m_sdr_addr), .sdr_din(m_sdr_din), .sdr_be(m_sdr_be), .sdr_req(m_sdr_req),
	.sdr_rnw(m_sdr_rnw), .sdr_dout(m_sdr_dout), .sdr_ready(m_sdr_ready), .refresh(sdr_refresh)
);

gb_sdram sdram (
	.init(areset),
	.clk(clk_ram),
	.doRefresh(sdr_refresh),

	.SDRAM_DQ(SDR_DQ),
	.SDRAM_A(SDR_A),
	.SDRAM_DQML(SDR_DQM[0]),
	.SDRAM_DQMH(SDR_DQM[1]),
	.SDRAM_BA(SDR_BA),
	.SDRAM_nCS(),
	.SDRAM_nWE(SDR_WE_N),
	.SDRAM_nRAS(SDR_RAS_N),
	.SDRAM_nCAS(SDR_CAS_N),

	.ch1_addr(ld_sdr_addr), .ch1_dout(), .ch1_din(ld_sdr_din), .ch1_req(ld_sdr_req), .ch1_rnw(1'b0), .ch1_ready(),
	.ch2_addr(bk_sdr_addr), .ch2_dout(bk_sdr_dout), .ch2_din(bk_sdr_din), .ch2_req(bk_sdr_req), .ch2_rnw(bk_sdr_rnw), .ch2_ready(bk_sdr_ready),
	.ch3_addr(m_sdr_addr), .ch3_dout(m_sdr_dout), .ch3_din(m_sdr_din), .ch3_be(m_sdr_be),
	.ch3_req(m_sdr_req), .ch3_rnw(m_sdr_rnw), .ch3_ready(m_sdr_ready)
);
// the clock of the chip: clk_sdr (clk_ram at 330 degrees, gb_clocks.v), not inverted
ODDR2 oddr_sdr_clk (.Q(SDR_CLK), .C0(clk_sdr), .C1(~clk_sdr), .CE(1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));

// ------------------------------------------------------------------ video

wire [23:0] vid_rgb;
wire vid_hs, vid_vs, vid_de;
gb_fb fb (
	.clk(clk_sys),
	.lcd_ce(lcd_ce), .lcd_clkena(lcd_clkena), .lcd_data(lcd_data), .lcd_data_gb(lcd_data_gb),
	.lcd_on(lcd_on), .lcd_vsync(lcd_vsync), .is_gbc(is_gbc), .blend(sw_blend), .palette(sw_pal), .cc(~sw_raw),
	.MA(MA), .MD(MD), .MWR_N(MWR_N), .MRD_N(MRD_N),
	.clk_vid(clk_vid), .rgb(vid_rgb), .hs(vid_hs), .vs(vid_vs), .de(vid_de)
);

// the bitmap OSD of link v2 (kg_l2_osd_overlay): written in clk_sys, drawn in clk_vid
wire [23:0] osd_rgb;
wire osd_hs, osd_vs, osd_de;
kg_l2_osd_overlay osd (
	.wclk(clk_sys),
	.osd_wr(osd_wr), .osd_waddr(osd_waddr), .osd_wdata(osd_wdata), .osd_en(osd_en),
	.osd_fg(osd_fg), .osd_bg(osd_bg), .osd_alpha(osd_alpha), .osd_px(osd_px), .osd_py(osd_py),
	.osd_pw(osd_pw), .osd_ph(osd_ph), .osd_place(osd_place), .osd_zoom(osd_zoom),
	.icon_on(8'd0), .icon_act(8'd0),
	.clk(clk_vid),
	.rgb_i(vid_rgb), .hs_i(vid_hs), .vs_i(vid_vs), .de_i(vid_de),
	.rgb_o(osd_rgb), .hs_o(osd_hs), .vs_o(osd_vs), .de_o(osd_de)
);

// ------------------------------------------------------------------ audio

// the gb audio (signed 16 bits, clk_sys; MiSTer AUDIO_S = 1) at 48 kHz: 33.571 MHz / 699 = 48.03 kHz;
// a DC blocker per channel (y = x - x' + y' - y' / 1024: -3 dB at ~7 Hz) on those samples, then x 4
reg [9:0] aud_div = 10'd0;
reg aud_t = 1'b0, aud_new = 1'b0;
reg signed [15:0] gb_xl = 16'sd0, gb_xr = 16'sd0;     // the input sample before
reg signed [23:0] gb_yl = 24'sd0, gb_yr = 24'sd0;     // the output, 8 fraction bits
always @(posedge clk_sys) begin
	aud_new <= 1'b0;
	if (aud_div == 10'd698) begin
		aud_div <= 10'd0;
		aud_new <= 1'b1;
		gb_xl <= snd_l;
		gb_xr <= snd_r;
		gb_yl <= gb_yl - (gb_yl >>> 10) + $signed({ snd_l, 8'd0 }) - $signed({ gb_xl, 8'd0 });
		gb_yr <= gb_yr - (gb_yr >>> 10) + $signed({ snd_r, 8'd0 }) - $signed({ gb_xr, 8'd0 });
	end
	else
		aud_div <= aud_div + 10'd1;
end

// the ADC (PCM1808: the line in and the MIDI synth SAM2695 of the board; as core-ocean240): i2s_transceiver is
// the master, SCKI = ADC_CLK = clk_sys 33.571 MHz, BCK = clk_sys / 8, LRCK = BCK / 64 (65.6 kHz, SCKI = 512 fs),
// 24 bits; half of the scale into the mix
wire [23:0] adc_l, adc_r;
i2s_transceiver #(.mclk_sclk_ratio(8), .sclk_ws_ratio(64), .d_width(24)) adc (
	.reset_n(~areset),
	.mclk(clk_sys),
	.sclk(ADC_BCK),
	.ws(ADC_LRCK),
	.sd_tx(),
	.sd_rx(ADC_DOUT),
	.l_data_tx(24'b0),
	.r_data_tx(24'b0),
	.l_data_rx(adc_l),
	.r_data_rx(adc_r)
);
ODDR2 oddr_adc (.Q(ADC_CLK), .C0(clk_sys), .C1(~clk_sys), .CE(1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));

// the final mix, saturated to 16 bits: the gb x 4 (y >> 8 << 2 = y >> 6) + the ADC / 2
function [15:0] sat16(input [19:0] v);
	sat16 = (v[19:15] == 5'b00000 || v[19:15] == 5'b11111) ? v[15:0] : v[19] ? 16'h8000 : 16'h7FFF;
endfunction
wire [19:0] mix_l = { {2{gb_yl[23]}}, gb_yl[23:6] } + { {5{adc_l[23]}}, adc_l[23:9] };
wire [19:0] mix_r = { {2{gb_yr[23]}}, gb_yr[23:6] } + { {5{adc_r[23]}}, adc_r[23:9] };
reg [15:0] aud_l = 16'd0, aud_r = 16'd0;
always @(posedge clk_sys) begin
	aud_l <= sat16(mix_l);
	aud_r <= sat16(mix_r);
	if (aud_new) aud_t <= ~aud_t;
end

// the level meters of the mcu: the peaks of the final mix (CMD_AUDIO_PEAKS_L / _R)
audio_peaks #(.PERIOD_BITS(19)) peaks (.clk(clk_sys), .audio_l(aud_l), .audio_r(aud_r), .cmd_wr(matrix_cmd_wr), .cmd(matrix_cmd));

// no I2S DAC on this board: sigma-delta outputs into an RC filter, offset binary input
kg_sigma_delta_dac dac_l (.clk(clk_sys), .reset(areset), .din({ ~aud_l[15], aud_l[14:0] }), .dout(AUDIO_L));
kg_sigma_delta_dac dac_r (.clk(clk_sys), .reset(areset), .din({ ~aud_r[15], aud_r[14:0] }), .dout(AUDIO_R));

// into clk_vid for HDMI: the toggle of a new sample (aud_l / aud_r: the ADC changes them in between,
// taken a few clocks after the toggle: a sample of the mix)
reg [2:0] aud_ts = 3'd0;
reg aud_stb = 1'b0;
reg [23:0] hdmi_l = 24'd0, hdmi_r = 24'd0;
always @(posedge clk_vid) begin
	aud_ts <= { aud_ts[1:0], aud_t };
	aud_stb <= aud_ts[2] != aud_ts[1];
	if (aud_ts[2] != aud_ts[1]) begin
		hdmi_l <= { aud_l, 8'd0 };
		hdmi_r <= { aud_r, 8'd0 };
	end
end

// ------------------------------------------------------------------ HDMI

wire dvi_only_vid;
kg_sync #(.W(1), .STAGES(3)) sync_dvi (.clk(clk_vid), .d(dvi_only), .q(dvi_only_vid));

// OUTPUT_REG / INPUT_REG: registers around the encoders (core-wonderswan: clk -> clk_ser at high fill)
hdmi_tx #(.SAMPLE_FREQ(48000), .INPUT_REG(1), .OUTPUT_REG(1)) hdmi (
	.clk(clk_vid),
	.sclk(clk_ser),
	.sclk_n(clk_ser_n),
	.reset(areset_vid),
	.rgb(osd_rgb),
	.vsync(osd_vs),      // 800 x 600 at 60 Hz: positive syncs (VESA)
	.hsync(osd_hs),
	.de(osd_de),
	.audio_en(~dvi_only_vid),
	.audio_l(hdmi_l),
	.audio_r(hdmi_r),
	.audio_clk(aud_stb),
	.tx_clk_n(TMDS_N[3]),
	.tx_clk_p(TMDS_P[3]),
	.tx_d_n(TMDS_N[2:0]),
	.tx_d_p(TMDS_P[2:0])
);

endmodule

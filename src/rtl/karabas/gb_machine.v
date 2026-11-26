// Game Boy / Game Boy Color machine for the Karabas boards: the MiSTer gb + cart_top
// (open-pocket-gbc copies, rtl/gb) with the clock enables, the model choice and the
// 32 kHz enable of the cartridge RTC. Wiring after MiSTer Gameboy.sv and open-pocket-gbc
// gbc_top.sv; savestates, cheats, SGB, link cable and MegaDuck are tied off.
//
// The cartridge memory (ROM and the cartridge RAM) is outside, in the board SDRAM:
//   mem_rd     one clk_sys pulse per read (the gb sdram_rd), mem_addr / mem_cram valid with it;
//              the byte must be on mem_q before the CPU samples it (MiSTer: within a CPU cycle)
//   mem_wr     cartridge RAM write of mem_din at cram_addr (mem_cram = 1)
//   mem_addr   ROM byte address (MBC output, 8 MB) or, with mem_cram, the cartridge RAM address
// The loader is the MiSTer ioctl (16-bit words, byte addresses): cart_top reads the header
// (mapper, RAM size, CGB flag) while the ROM goes to the SDRAM through the board glue.
//
// GPL v3 (see LICENSE); the instantiated modules keep their own headers.

module gb_machine (
	input         clk_sys,       // 33.554432 or 67.108864 MHz (CE_DIV 8 / 16)
	input         reset,         // held while loading

	input   [1:0] model,         // 0 = auto (CGB flag of the header), 1 = GBC, 2 = GB
	input         fast_boot,     // skip the boot ROM animation

	input   [7:0] joy,           // {start, select, b, a, down, up, left, right}, 1 = pressed

	// loader (MiSTer ioctl)
	input         dl,            // a cartridge download is in progress
	input         dl_wr,
	input  [24:0] dl_addr,
	input  [15:0] dl_data,
	output        dl_wait,

	// cartridge memory
	output        mem_rd,
	output        mem_wr,
	output        mem_cram,
	output [22:0] mem_addr,
	output [16:0] mem_cram_addr,
	output  [7:0] mem_din,
	input   [7:0] mem_q,

	// cartridge RTC (MBC3), Ф2
	input  [32:0] rtc_time,

	// video: one pixel per clock with lcd_ce & lcd_clkena (as MiSTer lcd.v), 160 x 144
	output        lcd_ce,        // the 4 MHz enable of the machine
	output        lcd_clkena,
	output [14:0] lcd_data,      // GBC: BGR555
	output  [1:0] lcd_data_gb,   // GB: shade 0..3
	output  [1:0] lcd_mode,
	output        lcd_on,
	output        lcd_vsync,
	output        is_gbc,        // the machine runs as GBC (latched at reset)

	output [15:0] audio_l,
	output [15:0] audio_r,

	output        speed          // GBC double speed
);

// ---------------------------------------------------------------- clock enables
wire ce, ce_n, ce_2x, paused;
ce_gen u_ce (
	.clk_sys(clk_sys), .pause(1'b0), .fast(1'b0),
	.ce(ce), .ce_n(ce_n), .ce_2x(ce_2x), .paused(paused)
);

reg       ce_32k = 1'b0;          // 32768 Hz for the cartridge RTC: clk_sys / 1024
reg [9:0] ce_32k_div = 10'd0;
always @(posedge clk_sys) begin
	ce_32k_div <= ce_32k_div + 1'b1;
	ce_32k <= ~|ce_32k_div;
end

// ---------------------------------------------------------------- model
wire isGBC_game;
reg  isGBC = 1'b0;
always @(posedge clk_sys) if (reset) isGBC <= (model == 2'd1) | ((model == 2'd0) & isGBC_game);
assign is_gbc = isGBC;

// ---------------------------------------------------------------- joypad
wire [1:0] joy_p54;
wire [3:0] joy_dir     = ~joy[3:0] | {4{joy_p54[0]}};           // right, left, up, down
wire [3:0] joy_buttons = ~{joy[7], joy[6], joy[5], joy[4]} | {4{joy_p54[1]}}; // start, select, b, a
wire [3:0] joy_din     = joy_dir & joy_buttons;

// ---------------------------------------------------------------- gb
wire [14:0] ext_bus_addr;
wire        ext_bus_a15, cart_rd, cart_wr, cart_oe, nCS;
wire  [7:0] cart_do, cart_di;
wire  [7:0] cart_ram_size;
wire [63:0] ss_ext_din, ss_ext_dout;
wire  [9:0] ss_ext_adr;
wire        ss_ext_wren, ss_ext_rst;

gb u_gb (
	.reset(reset),
	.clk_sys(clk_sys), .ce(ce), .ce_n(ce_n), .ce_2x(ce_2x),
	.joystick(8'd0), .isGBC(isGBC), .real_cgb_boot(1'b0), .isSGB(1'b0), .extra_spr_en(1'b0),
	.ext_bus_addr(ext_bus_addr), .ext_bus_a15(ext_bus_a15),
	.cart_rd(cart_rd), .cart_wr(cart_wr), .cart_do(cart_do), .cart_di(cart_di), .cart_oe(cart_oe),
	.nCS(nCS), .PHI(), .sdram_rd(mem_rd),
	.cgb_boot_download(1'b0), .dmg_boot_download(1'b0), .sgb_boot_download(1'b0),
	.ioctl_wr(1'b0), .ioctl_addr(25'd0), .ioctl_dout(16'd0),
	.boot_gba_en(1'b0), .fast_boot_en(fast_boot),
	.audio_l(audio_l), .audio_r(audio_r), .audio_no_pops(1'b0),
	.megaduck(1'b0),
	.lcd_clkena(lcd_clkena), .lcd_data(lcd_data), .lcd_data_gb(lcd_data_gb),
	.lcd_mode(lcd_mode), .lcd_on(lcd_on), .lcd_vsync(lcd_vsync),
	.joy_p54(joy_p54), .joy_din(joy_din),
	.speed(speed), .DMA_on(),
	.gg_reset(1'b0), .gg_en(1'b0), .gg_code(129'd0), .gg_available(),
	.sc_int_clock2(), .serial_clk_in(1'b0), .serial_clk_out(), .serial_data_in(1'b1), .serial_data_out(),
	.increaseSSHeaderCount(1'b0), .cart_ram_size(cart_ram_size),
	.save_state(1'b0), .load_state(1'b0), .savestate_number(2'd0),
	.sleep_savestate(), .savestate_ovr(),
	.SaveStateExt_Din(ss_ext_din), .SaveStateExt_Adr(ss_ext_adr), .SaveStateExt_wren(ss_ext_wren),
	.SaveStateExt_rst(ss_ext_rst), .SaveStateExt_Dout(ss_ext_dout), .SaveStateExt_load(),
	.Savestate_CRAMAddr(), .Savestate_CRAMRdEn(), .Savestate_CRAMRWrEn(), .Savestate_CRAMWriteData(),
	.Savestate_CRAMReadData(16'd0),
	.SAVE_out_Din(), .SAVE_out_Dout(64'd0), .SAVE_out_Adr(), .SAVE_out_rnw(), .SAVE_out_ena(),
	.SAVE_out_be(), .SAVE_out_done(1'b0),
	.savestate_sdram_busy(1'b0), .rewind_on(1'b0), .rewind_active(1'b0)
);

// ---------------------------------------------------------------- cartridge
cart_top u_cart (
	.reset(reset),
	.clk_sys(clk_sys), .ce_cpu(ce), .ce_cpu2x(ce_2x), .speed(speed),
	.megaduck(1'b0), .duck_md0_mode(1'b0), .mapper_sel(3'd0),
	.cart_addr(ext_bus_addr), .cart_a15(ext_bus_a15), .cart_rd(cart_rd), .cart_wr(cart_wr),
	.cart_do(cart_do), .cart_di(cart_di), .cart_oe(cart_oe),
	.nCS(nCS),
	.mbc_addr(mem_addr),
	.dn_write(), .cart_ready(),
	.is_cram_addr(mem_cram), .cram_rd(), .cram_wr(mem_wr), .cram_bram_wr(), .cram_addr(mem_cram_addr),
	.cart_download(dl),
	.ram_mask_file(), .ram_size(cart_ram_size), .has_save(), .bram_save(),
	.isGBC_game(isGBC_game), .isSGB_game(),
	.ioctl_download(dl), .ioctl_wr(dl_wr), .ioctl_addr(dl_addr), .ioctl_dout(dl_data), .ioctl_wait(dl_wait),
	.bk_wr(1'b0), .bk_rtc_wr(1'b0), .bk_addr(17'd0), .bk_data(16'd0), .bk_q(), .img_size(64'd0),
	.rom_di(mem_q),
	.joystick_analog_0(16'd0),
	.ce_32k(ce_32k), .RTC_time(rtc_time), .RTC_timestampOut(), .RTC_savedtimeOut(), .RTC_inuse(),
	.SaveStateExt_Din(ss_ext_din), .SaveStateExt_Adr(ss_ext_adr), .SaveStateExt_wren(ss_ext_wren),
	.SaveStateExt_rst(ss_ext_rst), .SaveStateExt_Dout(ss_ext_dout),
	.savestate_load(1'b0), .savestate_ovr(1'b0),
	.Savestate_CRAMAddr(20'd0), .Savestate_CRAMRWrEn(1'b0), .Savestate_CRAMWriteData(16'd0), .Savestate_CRAM_Q(),
	.rumbling()
);

assign mem_din = cart_di;
assign lcd_ce = ce;

endmodule

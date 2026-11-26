module eReg_SavestateV (
	clk,
	BUS_Din,
	BUS_Adr,
	BUS_wren,
	BUS_rst,
	BUS_Dout,
	Din,
	Dout
);
	parameter index = 0;
	parameter Adr = 0;
	parameter upper = 0;
	parameter lower = 0;
	parameter [63:0] def = 64'd0;
	input clk;
	input [63:0] BUS_Din;
	input [9:0] BUS_Adr;
	input BUS_wren;
	input BUS_rst;
	output wire [63:0] BUS_Dout;
	input [upper:lower] Din;
	output wire [upper:lower] Dout;
	assign BUS_Dout = 64'd0;
	assign Dout = def[upper:lower];
endmodule
module gb_savestates (
	clk,
	reset_in,
	reset_out,
	load_done,
	increaseSSHeaderCount,
	save,
	load,
	savestate_address,
	savestate_busy,
	cart_ram_size,
	lcd_vsync,
	BUS_Din,
	BUS_Adr,
	BUS_wren,
	BUS_rst,
	BUS_Dout,
	loading_savestate,
	saving_savestate,
	sleep_savestate,
	clock_ena_in,
	memory_busy,
	Save_RAMAddr,
	Save_RAMRdEn,
	Save_RAMWrEn,
	Save_RAMWriteData,
	Save_RAMReadData_WRAM,
	Save_RAMReadData_VRAM,
	Save_RAMReadData_ORAM,
	Save_RAMReadData_ZRAM,
	Save_RAMReadData_CRAM,
	bus_out_Din,
	bus_out_Dout,
	bus_out_Adr,
	bus_out_rnw,
	bus_out_ena,
	bus_out_be,
	bus_out_done
);
	input clk;
	input reset_in;
	output reg reset_out;
	output wire load_done;
	input increaseSSHeaderCount;
	input save;
	input load;
	input [31:0] savestate_address;
	output wire savestate_busy;
	input [7:0] cart_ram_size;
	input lcd_vsync;
	output wire [63:0] BUS_Din;
	output wire [9:0] BUS_Adr;
	output wire BUS_wren;
	output wire BUS_rst;
	input [63:0] BUS_Dout;
	output wire loading_savestate;
	output wire saving_savestate;
	output wire sleep_savestate;
	input clock_ena_in;
	input memory_busy;
	output wire [19:0] Save_RAMAddr;
	output wire [4:0] Save_RAMRdEn;
	output wire [4:0] Save_RAMWrEn;
	output wire [15:0] Save_RAMWriteData;
	input [7:0] Save_RAMReadData_WRAM;
	input [7:0] Save_RAMReadData_VRAM;
	input [7:0] Save_RAMReadData_ORAM;
	input [7:0] Save_RAMReadData_ZRAM;
	input [15:0] Save_RAMReadData_CRAM;
	output wire [63:0] bus_out_Din;
	input [63:0] bus_out_Dout;
	output wire [25:0] bus_out_Adr;
	output wire bus_out_rnw;
	output wire bus_out_ena;
	output wire [7:0] bus_out_be;
	input bus_out_done;
	initial reset_out = 1'b1;
	always @(posedge clk) reset_out <= reset_in;
	assign load_done = 1'b0;
	assign savestate_busy = 1'b0;
	assign BUS_Din = 64'd0;
	assign BUS_Adr = 10'd0;
	assign BUS_wren = 1'b0;
	assign BUS_rst = reset_out;
	assign loading_savestate = 1'b0;
	assign saving_savestate = 1'b0;
	assign sleep_savestate = 1'b0;
	assign Save_RAMAddr = 20'd0;
	assign Save_RAMRdEn = 5'd0;
	assign Save_RAMWrEn = 5'd0;
	assign Save_RAMWriteData = 16'd0;
	assign bus_out_Din = 64'd0;
	assign bus_out_Adr = 26'd0;
	assign bus_out_rnw = 1'b1;
	assign bus_out_ena = 1'b0;
	assign bus_out_be = 8'd0;
endmodule
module gb_statemanager (
	clk,
	reset,
	rewind_on,
	rewind_active,
	savestate_number,
	save,
	load,
	sleep_rewind,
	vsync,
	request_savestate,
	request_loadstate,
	request_address,
	request_busy
);
	parameter Softmap_SaveState_ADDR = 0;
	parameter Softmap_Rewind_ADDR = 0;
	input clk;
	input reset;
	input rewind_on;
	input rewind_active;
	input [1:0] savestate_number;
	input save;
	input load;
	output wire sleep_rewind;
	input vsync;
	output wire request_savestate;
	output wire request_loadstate;
	output wire [31:0] request_address;
	input request_busy;
	assign sleep_rewind = 1'b0;
	assign request_savestate = 1'b0;
	assign request_loadstate = 1'b0;
	assign request_address = 32'd0;
endmodule
module megaduck_swizzle (
	megaduck,
	a_in,
	a_out,
	snd_in_di,
	snd_in_do,
	snd_out_di,
	snd_out_do
);
	input megaduck;
	input [15:0] a_in;
	output wire [15:0] a_out;
	input [7:0] snd_in_di;
	output wire [7:0] snd_in_do;
	input [7:0] snd_out_di;
	output wire [7:0] snd_out_do;
	assign a_out = a_in;
	assign snd_in_do = snd_in_di;
	assign snd_out_do = snd_out_di;
endmodule
module dpram (
	clock_a,
	clken_a,
	address_a,
	data_a,
	wren_a,
	q_a,
	clock_b,
	clken_b,
	address_b,
	data_b,
	wren_b,
	q_b
);
	parameter addr_width = 8;
	parameter data_width = 8;
	parameter mem_init_file = " ";
	input clock_a;
	input clken_a;
	input [addr_width - 1:0] address_a;
	input [data_width - 1:0] data_a;
	input wren_a;
	output reg [data_width - 1:0] q_a;
	input clock_b;
	input clken_b;
	input [addr_width - 1:0] address_b;
	input [data_width - 1:0] data_b;
	input wren_b;
	output wire [data_width - 1:0] q_b;
	reg [data_width - 1:0] mem [0:(1 << addr_width) - 1];
	always @(posedge clock_a)
		if (clken_a) begin
			if (wren_a) begin
				mem[address_a] <= data_a;
				q_a <= data_a;
			end
			else
				q_a <= mem[address_a];
		end
	assign q_b = {data_width {1'b0}};
endmodule
module dpram_blk (
	clock_a,
	clken_a,
	address_a,
	data_a,
	wren_a,
	q_a,
	clock_b,
	clken_b,
	address_b,
	data_b,
	wren_b,
	q_b
);
	parameter addr_width = 8;
	parameter data_width = 8;
	input clock_a;
	input clken_a;
	input [addr_width - 1:0] address_a;
	input [data_width - 1:0] data_a;
	input wren_a;
	output reg [data_width - 1:0] q_a;
	input clock_b;
	input clken_b;
	input [addr_width - 1:0] address_b;
	input [data_width - 1:0] data_b;
	input wren_b;
	output wire [data_width - 1:0] q_b;
	(* ram_style = "block" *) reg [data_width - 1:0] mem [0:(1 << addr_width) - 1];
	always @(posedge clock_a)
		if (clken_a) begin
			if (wren_a) begin
				mem[address_a] <= data_a;
				q_a <= data_a;
			end
			else
				q_a <= mem[address_a];
		end
	assign q_b = {data_width {1'b0}};
endmodule
module boot_rom (
	clk,
	addr,
	q
);
	input clk;
	input [11:0] addr;
	output reg [7:0] q;
	reg [7:0] rom [0:4095];
	initial $readmemh("rtl/gb_port/boot_rom.hex", rom);
	always @(posedge clk) q <= rom[addr];
endmodule
module ce_gen (
	clk_sys,
	pause,
	fast,
	ce,
	ce_n,
	ce_2x,
	paused
);
	input clk_sys;
	input pause;
	input fast;
	output reg ce;
	output reg ce_n;
	output reg ce_2x;
	output reg paused;
	reg [2:0] clkdiv = 0;
	initial begin
		ce = 0;
		ce_n = 0;
		ce_2x = 0;
		paused = 0;
	end
	always @(negedge clk_sys) begin
		ce <= 0;
		ce_n <= 0;
		ce_2x <= 0;
		if (!paused) begin
			if (pause && ((clkdiv | {2'b00, fast}) == 3'b111))
				paused <= 1;
			else begin
				clkdiv <= (fast ? (clkdiv + 3'd2) & 3'b110 : clkdiv + 1'd1);
				if (clkdiv == 3'b000)
					ce <= 1;
				if (clkdiv == 3'b100)
					ce_n <= 1;
				if (clkdiv[1:0] == 2'b00)
					ce_2x <= 1;
			end
		end
		else if (!pause)
			paused <= 0;
	end
endmodule
module gb (
	reset,
	clk_sys,
	ce,
	ce_n,
	ce_2x,
	joystick,
	isGBC,
	real_cgb_boot,
	isSGB,
	extra_spr_en,
	ext_bus_addr,
	ext_bus_a15,
	cart_rd,
	cart_wr,
	cart_do,
	cart_di,
	cart_oe,
	nCS,
	PHI,
	sdram_rd,
	cgb_boot_download,
	dmg_boot_download,
	sgb_boot_download,
	ioctl_wr,
	ioctl_addr,
	ioctl_dout,
	boot_gba_en,
	fast_boot_en,
	audio_l,
	audio_r,
	audio_no_pops,
	megaduck,
	lcd_clkena,
	lcd_data,
	lcd_data_gb,
	lcd_mode,
	lcd_on,
	lcd_vsync,
	joy_p54,
	joy_din,
	speed,
	DMA_on,
	gg_reset,
	gg_en,
	gg_code,
	gg_available,
	sc_int_clock2,
	serial_clk_in,
	serial_clk_out,
	serial_data_in,
	serial_data_out,
	increaseSSHeaderCount,
	cart_ram_size,
	save_state,
	load_state,
	savestate_number,
	sleep_savestate,
	savestate_ovr,
	SaveStateExt_Din,
	SaveStateExt_Adr,
	SaveStateExt_wren,
	SaveStateExt_rst,
	SaveStateExt_Dout,
	SaveStateExt_load,
	Savestate_CRAMAddr,
	Savestate_CRAMRdEn,
	Savestate_CRAMRWrEn,
	Savestate_CRAMWriteData,
	Savestate_CRAMReadData,
	SAVE_out_Din,
	SAVE_out_Dout,
	SAVE_out_Adr,
	SAVE_out_rnw,
	SAVE_out_ena,
	SAVE_out_be,
	SAVE_out_done,
	savestate_sdram_busy,
	rewind_on,
	rewind_active
);
	input reset;
	input clk_sys;
	input ce;
	input ce_n;
	input ce_2x;
	input [7:0] joystick;
	input isGBC;
	input real_cgb_boot;
	input isSGB;
	input extra_spr_en;
	output wire [14:0] ext_bus_addr;
	output wire ext_bus_a15;
	output wire cart_rd;
	output wire cart_wr;
	input [7:0] cart_do;
	output wire [7:0] cart_di;
	input cart_oe;
	output wire nCS;
	output wire PHI;
	output wire sdram_rd;
	input cgb_boot_download;
	input dmg_boot_download;
	input sgb_boot_download;
	input ioctl_wr;
	input [24:0] ioctl_addr;
	input [15:0] ioctl_dout;
	input boot_gba_en;
	input fast_boot_en;
	output wire [15:0] audio_l;
	output wire [15:0] audio_r;
	input audio_no_pops;
	input megaduck;
	output wire lcd_clkena;
	output wire [14:0] lcd_data;
	output wire [1:0] lcd_data_gb;
	output wire [1:0] lcd_mode;
	output wire lcd_on;
	output wire lcd_vsync;
	output wire [1:0] joy_p54;
	input [3:0] joy_din;
	output wire speed;
	output wire DMA_on;
	input gg_reset;
	input gg_en;
	input [128:0] gg_code;
	output wire gg_available;
	output wire sc_int_clock2;
	input serial_clk_in;
	output wire serial_clk_out;
	input serial_data_in;
	output wire serial_data_out;
	input increaseSSHeaderCount;
	input [7:0] cart_ram_size;
	input save_state;
	input load_state;
	input [1:0] savestate_number;
	output wire sleep_savestate;
	output wire savestate_ovr;
	output wire [63:0] SaveStateExt_Din;
	output wire [9:0] SaveStateExt_Adr;
	output wire SaveStateExt_wren;
	output wire SaveStateExt_rst;
	input [63:0] SaveStateExt_Dout;
	output wire SaveStateExt_load;
	output wire [19:0] Savestate_CRAMAddr;
	output wire Savestate_CRAMRdEn;
	output wire Savestate_CRAMRWrEn;
	output wire [15:0] Savestate_CRAMWriteData;
	input [15:0] Savestate_CRAMReadData;
	output wire [63:0] SAVE_out_Din;
	input [63:0] SAVE_out_Dout;
	output wire [25:0] SAVE_out_Adr;
	output wire SAVE_out_rnw;
	output wire SAVE_out_ena;
	output wire [7:0] SAVE_out_be;
	input SAVE_out_done;
	input savestate_sdram_busy;
	input rewind_on;
	input rewind_active;
	wire [63:0] SaveStateBus_Din;
	wire [9:0] SaveStateBus_Adr;
	wire SaveStateBus_wren;
	wire SaveStateBus_rst;
	wire [15:0] Savestate_RAMWriteData;
	wire [7:0] Savestate_RAMReadData_WRAM;
	wire [7:0] Savestate_RAMReadData_VRAM;
	wire [7:0] Savestate_RAMReadData_ORAM;
	wire [7:0] Savestate_RAMReadData_ZRAM;
	wire [19:0] Savestate_RAMAddr;
	wire [4:0] Savestate_RAMRdEn;
	wire [4:0] Savestate_RAMRWrEn;
	localparam SAVESTATE_MODULES = 8;
	wire [63:0] SaveStateBus_wired_or [0:7];
	wire [60:0] SS_Top;
	wire [60:0] SS_Top_BACK;
	eReg_SavestateV #(
		.index(0),
		.Adr(31),
		.upper(60),
		.lower(0),
		.def(64'h1000000000800000)
	) iREG_SAVESTATE_Top(
		.clk(clk_sys),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[6]),
		.Din(SS_Top_BACK),
		.Dout(SS_Top)
	);
	wire [10:0] SS_Top2;
	wire [10:0] SS_Top2_BACK;
	eReg_SavestateV #(
		.index(0),
		.Adr(38),
		.upper(10),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_Top2(
		.clk(clk_sys),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[7]),
		.Din(SS_Top2_BACK),
		.Dout(SS_Top2)
	);
	reg boot_rom_enabled;
	reg [1:0] ff4c_key0;
	wire isGBC_mode = !ff4c_key0 | boot_rom_enabled;
	wire [15:0] cpu_addr;
	wire [7:0] cpu_do;
	wire apu_framecount_en;
	wire sel_timer = (cpu_addr[15:4] == 12'hff0) && (cpu_addr[3:2] == 2'b01);
	wire sel_video_reg = (cpu_addr[15:4] == 12'hff4) || ((isGBC && (cpu_addr[15:4] == 12'hff6)) && ((cpu_addr[3:0] >= 4'h8) && (cpu_addr[3:0] <= 4'hc)));
	wire sel_video_oam = cpu_addr[15:8] == 8'hfe;
	wire sel_joy = cpu_addr == 16'hff00;
	wire sel_sb = cpu_addr == 16'hff01;
	wire sel_sc = cpu_addr == 16'hff02;
	wire sel_rom = !cpu_addr[15];
	wire sel_cram = cpu_addr[15:13] == 3'b101;
	wire sel_vram = cpu_addr[15:13] == 3'b100;
	wire sel_ie = cpu_addr == 16'hffff;
	wire sel_if = cpu_addr == 16'hff0f;
	wire sel_wram = (cpu_addr[15:14] == 2'b11) && ~&cpu_addr[13:9];
	wire sel_zpram = (cpu_addr[15:7] == 9'b111111111) && (cpu_addr != 16'hffff);
	wire sel_audio = (cpu_addr[15:8] == 8'hff) && ((((cpu_addr[7:5] == 3'b001) || (cpu_addr[7:4] == 4'b0001)) || (cpu_addr[7:0] == 8'h76)) || (cpu_addr[7:0] == 8'h77));
	wire sel_ext_bus = (sel_rom | sel_cram) | sel_wram;
	wire sel_boot_rom;
	wire sel_boot_rom_cgb;
	wire sel_FF72 = isGBC && (cpu_addr == 16'hff72);
	wire sel_FF73 = isGBC && (cpu_addr == 16'hff73);
	wire sel_FF74 = (isGBC && isGBC_mode) && (cpu_addr == 16'hff74);
	wire sel_FF75 = isGBC && (cpu_addr == 16'hff75);
	wire sel_FF50 = boot_rom_enabled && (cpu_addr == 16'hff50);
	wire ext_bus_wram_sel;
	wire ext_bus_cram_sel;
	wire ext_bus_rom_sel;
	wire ext_bus_rd;
	wire ext_bus_wr;
	wire [7:0] ext_bus_di;
	wire cart_sel;
	wire [15:0] dma_addr;
	wire dma_sel_rom = ~dma_addr[15];
	wire dma_sel_vram = dma_addr[15:13] == 3'b100;
	wire dma_sel_ext_bus_dmg = ~dma_sel_vram;
	wire dma_sel_ext_ram = ~dma_sel_rom;
	wire dma_sel_cram = dma_addr[15:13] == 3'b101;
	wire dma_sel_wram = dma_addr[15:13] == 3'b110;
	wire dma_sel_ext_bus_cgb = dma_sel_rom | dma_sel_cram;
	wire dma_sel_ext_bus = (isGBC ? dma_sel_ext_bus_cgb : dma_sel_ext_bus_dmg);
	wire sel_vram_bank = cpu_addr == 16'hff4f;
	wire sel_wram_bank = (isGBC && isGBC_mode) && (cpu_addr == 16'hff70);
	wire sel_hdma = ((isGBC && isGBC_mode) && (cpu_addr[15:4] == 12'hff5)) && ((cpu_addr[3:0] != 4'd0) && (cpu_addr[3:0] < 4'd6));
	wire sel_key0 = (isGBC && boot_rom_enabled) && (cpu_addr == 16'hff4c);
	wire sel_key1 = (isGBC && isGBC_mode) && (cpu_addr == 16'hff4d);
	wire sel_rp = (isGBC && isGBC_mode) && (cpu_addr == 16'hff56);
	wire [15:0] hdma_source_addr;
	wire hdma_sel_rom = !hdma_source_addr[15];
	wire hdma_sel_cram = hdma_source_addr[15:13] == 3'b101;
	wire hdma_sel_wram = hdma_source_addr[15:13] == 3'b110;
	wire hdma_sel_ext_bus = hdma_sel_rom | hdma_sel_cram;
	wire sc_start;
	wire sc_shiftclock;
	wire [7:0] sc_r = {sc_start, 6'h3f, sc_shiftclock};
	wire irq_ack;
	wire [7:0] irq_vec;
	reg [4:0] if_r;
	reg [7:0] ie_r;
	wire irq_n;
	reg [2:0] wram_bank;
	reg vram_bank;
	wire [7:0] hdma_do;
	reg cpu_speed;
	reg prepare_switch;
	wire oam_cpu_allow;
	wire vram_cpu_allow;
	wire [7:0] joy_do;
	wire [7:0] sb_o;
	wire [7:0] timer_do;
	wire [7:0] video_do;
	wire [7:0] audio_do;
	wire [7:0] boot_do;
	wire [7:0] vram_do;
	wire [7:0] vram1_do;
	wire [7:0] zpram_do;
	wire [7:0] wram_do;
	reg [7:0] FF72;
	reg [7:0] FF73;
	reg [7:0] FF74;
	reg [2:0] FF75;
	wire [7:0] cpu_di = (irq_ack ? irq_vec : (sel_if ? {3'b111, if_r} : (sel_rp ? 8'h02 : (sel_wram_bank ? {5'h1f, wram_bank} : (isGBC && sel_vram_bank ? {7'h7f, vram_bank} : (sel_hdma ? {hdma_do} : (sel_key0 ? {4'hf, ff4c_key0, 2'b10} : (sel_key1 ? {cpu_speed, 6'h3f, prepare_switch} : (sel_joy ? joy_do : (sel_sb ? sb_o : (sel_sc ? sc_r : (sel_timer ? timer_do : (sel_video_reg ? video_do : (sel_video_oam && oam_cpu_allow ? video_do : (sel_audio ? audio_do : (sel_boot_rom ? boot_do : (isGBC & sel_wram ? wram_do : (sel_ext_bus ? ext_bus_di : (sel_vram && vram_cpu_allow ? (isGBC && vram_bank ? vram1_do : vram_do) : (sel_zpram ? zpram_do : (sel_ie ? ie_r : (sel_FF72 ? FF72 : (sel_FF73 ? FF73 : (sel_FF74 ? FF74 : (sel_FF75 ? {1'b1, FF75, 4'b1111} : (sel_FF50 ? {6'b000000, fast_boot_en, boot_gba_en} : 8'hff))))))))))))))))))))))))));
	wire cpu_wr_n;
	wire cpu_rd_n;
	wire cpu_iorq_n;
	wire cpu_m1_n;
	wire cpu_mreq_n;
	wire cpu_halt_n;
	wire [2:0] cpu_tstate;
	wire ce_cpu = (cpu_speed ? ce_2x : ce);
	wire hdma_rd;
	wire hdma_cpu_stop = isGBC & hdma_rd;
	wire cpu_clken = ~hdma_cpu_stop & ce_cpu;
	reg reset_r = 1;
	wire reset_ss;
	always @(posedge clk_sys)
		if (ce)
			reset_r <= reset;
	reg [2:0] phi_clk_div;
	always @(posedge clk_sys)
		if (reset_ss)
			phi_clk_div <= SS_Top[59:57];
		else begin
			if (ce_2x)
				phi_clk_div <= phi_clk_div + 1'b1;
			if (cpu_clken & cpu_halt_n) begin
				if (cpu_tstate == 3'd4) begin
					if (cpu_speed)
						phi_clk_div[1:0] <= 2'd1;
					else
						phi_clk_div <= 3'd2;
				end
			end
		end
	wire phi_1m = ~phi_clk_div[2];
	wire phi_2m = ~phi_clk_div[1];
	wire phi_early_1m = ~|phi_clk_div[2:1];
	wire phi_early_2m = ~|phi_clk_div[1:0];
	wire cpu_phi = (cpu_speed ? phi_2m : phi_1m) | ~cpu_halt_n;
	reg cpu_phi_d;
	assign SS_Top_BACK[59:57] = phi_clk_div;
	assign SS_Top_BACK[60] = cpu_phi_d;
	always @(posedge clk_sys)
		if (reset_ss)
			cpu_phi_d <= SS_Top[60];
		else if (ce_2x)
			cpu_phi_d <= cpu_phi;
	wire cpu_phi_r_ce = (ce_2x & cpu_halt_n) & (cpu_speed ? phi_clk_div[1:0] == 2'd3 : phi_clk_div == 3'd7);
	wire cpu_phi_f_ce = (ce_2x & cpu_phi_d) & ~cpu_phi;
	wire hdma_phi_r_ce = ce_2x & (phi_clk_div[1:0] == 2'd3);
	wire hdma_phi_f_ce = ce_2x & (phi_clk_div[1:0] == 2'd1);
	reg old_cpu_wr_n;
	assign SS_Top_BACK[54] = old_cpu_wr_n;
	always @(posedge clk_sys)
		if (reset_ss)
			old_cpu_wr_n <= SS_Top[54];
		else if (ce_cpu)
			old_cpu_wr_n <= cpu_wr_n;
	wire cpu_wr_n_edge = ~(old_cpu_wr_n & ~cpu_wr_n);
	wire cpu_stop;
	wire genie_ovr;
	wire [7:0] genie_data;
	wire [15:0] cpu_addr_raw;
	wire [7:0] snd_d_in;
	wire [7:0] snd_d_out;
	megaduck_swizzle md_swizz(
		.megaduck(megaduck),
		.a_in(cpu_addr_raw),
		.a_out(cpu_addr),
		.snd_in_di(cpu_do),
		.snd_in_do(snd_d_in),
		.snd_out_di(snd_d_out),
		.snd_out_do(audio_do)
	);
	GBse cpu(
		.RESET_n(!reset_ss),
		.CLK_n(clk_sys),
		.CLKEN(cpu_clken),
		.WAIT_n(1'b1),
		.INT_n(irq_n),
		.NMI_n(1'b1),
		.BUSRQ_n(1'b1),
		.M1_n(cpu_m1_n),
		.MREQ_n(cpu_mreq_n),
		.IORQ_n(cpu_iorq_n),
		.RD_n(cpu_rd_n),
		.WR_n(cpu_wr_n),
		.RFSH_n(),
		.HALT_n(cpu_halt_n),
		.BUSAK_n(),
		.A(cpu_addr_raw),
		.DI((genie_ovr ? genie_data : cpu_di)),
		.DO(cpu_do),
		.STOP(cpu_stop),
		.TS(cpu_tstate),
		.isGBC(isGBC),
		.SaveStateBus_Din(SaveStateBus_Din),
		.SaveStateBus_Adr(SaveStateBus_Adr),
		.SaveStateBus_wren(SaveStateBus_wren),
		.SaveStateBus_rst(SaveStateBus_rst),
		.SaveStateBus_Dout(SaveStateBus_wired_or[0])
	);
	assign genie_ovr = 1'b0;
	assign genie_data = 8'd0;
	assign gg_available = 1'b0;
	assign SS_Top_BACK[56:55] = ff4c_key0;
	always @(posedge clk_sys)
		if (reset_ss)
			ff4c_key0 <= SS_Top[56:55];
		else if ((sel_key0 & ce_cpu) & ~cpu_wr_n_edge)
			ff4c_key0 <= cpu_do[3:2];
	assign speed = cpu_speed;
	assign SS_Top_BACK[3] = cpu_speed;
	assign SS_Top_BACK[4] = prepare_switch;
	always @(posedge clk_sys) begin
		if (reset_ss) begin
			cpu_speed <= SS_Top[3];
			prepare_switch <= SS_Top[4];
		end
		else if ((ce_2x && sel_key1) && !cpu_wr_n_edge)
			prepare_switch <= cpu_do[0];
		if (((ce_2x && isGBC) && prepare_switch) && cpu_stop) begin
			cpu_speed <= !cpu_speed;
			prepare_switch <= 1'b0;
		end
	end
	wire audio_rd = !cpu_rd_n && sel_audio;
	wire audio_wr = !cpu_wr_n && sel_audio;
	gbc_snd audio(
		.clk(clk_sys),
		.ce(ce),
		.reset(reset_ss),
		.apu_framecount_en(apu_framecount_en),
		.is_gbc(isGBC),
		.remove_pops(audio_no_pops),
		.s1_read(audio_rd),
		.s1_write(audio_wr),
		.s1_addr(cpu_addr[6:0]),
		.s1_readdata(snd_d_out),
		.s1_writedata(snd_d_in),
		.snd_left(audio_l),
		.snd_right(audio_r),
		.SaveStateBus_Din(SaveStateBus_Din),
		.SaveStateBus_Adr(SaveStateBus_Adr),
		.SaveStateBus_wren(SaveStateBus_wren),
		.SaveStateBus_rst(SaveStateBus_rst),
		.SaveStateBus_Dout(SaveStateBus_wired_or[5])
	);
	wire serial_irq;
	assign sc_int_clock2 = sc_shiftclock;
	link link(
		.clk_sys(clk_sys),
		.ce(ce_cpu),
		.rst(reset_ss),
		.sel_sc(sel_sc),
		.sel_sb(sel_sb),
		.cpu_wr_n(cpu_wr_n_edge),
		.sc_start_in(cpu_do[7]),
		.sc_int_clock_in(cpu_do[0]),
		.sb_in(cpu_do),
		.serial_clk_in(serial_clk_in),
		.serial_data_in(serial_data_in),
		.serial_clk_out(serial_clk_out),
		.serial_data_out(serial_data_out),
		.sb(sb_o),
		.serial_irq(serial_irq),
		.sc_start(sc_start),
		.sc_int_clock(sc_shiftclock),
		.SaveStateBus_Din(SaveStateBus_Din),
		.SaveStateBus_Adr(SaveStateBus_Adr),
		.SaveStateBus_wren(SaveStateBus_wren),
		.SaveStateBus_rst(SaveStateBus_rst),
		.SaveStateBus_Dout(SaveStateBus_wired_or[3])
	);
	reg [1:0] p54;
	assign SS_Top_BACK[6:5] = p54;
	always @(posedge clk_sys)
		if (reset_ss)
			p54 <= SS_Top[6:5];
		else if ((ce_cpu && sel_joy) && !cpu_wr_n_edge)
			p54 <= cpu_do[5:4];
	assign joy_do = {2'b11, p54, joy_din};
	assign joy_p54 = p54;
	assign SS_Top_BACK[34:27] = FF72;
	assign SS_Top_BACK[42:35] = FF73;
	assign SS_Top_BACK[50:43] = FF74;
	assign SS_Top_BACK[53:51] = FF75;
	always @(posedge clk_sys)
		if (reset_ss) begin
			FF72 <= SS_Top[34:27];
			FF73 <= SS_Top[42:35];
			FF74 <= SS_Top[50:43];
			FF75 <= SS_Top[53:51];
		end
		else if (ce_cpu && !cpu_wr_n_edge) begin
			if (sel_FF72)
				FF72 <= cpu_do;
			if (sel_FF73)
				FF73 <= cpu_do;
			if (sel_FF74)
				FF74 <= cpu_do;
			if (sel_FF75)
				FF75 <= cpu_do[6:4];
		end
	assign irq_ack = !cpu_iorq_n && !cpu_m1_n;
	assign irq_vec = (if_r[0] && ie_r[0] ? 8'h40 : (if_r[1] && ie_r[1] ? 8'h48 : (if_r[2] && ie_r[2] ? 8'h50 : (if_r[3] && ie_r[3] ? 8'h58 : (if_r[4] && ie_r[4] ? 8'h60 : 8'h00)))));
	reg [3:0] inputD;
	reg [3:0] inputD2;
	assign irq_n = !(ie_r & if_r);
	wire video_irq;
	wire vblank_irq;
	wire timer_irq;
	reg old_vblank_irq;
	reg old_video_irq;
	reg old_timer_irq;
	reg old_serial_irq;
	reg old_ack = 0;
	assign SS_Top_BACK[11:7] = ie_r[4:0];
	assign SS_Top_BACK[16:12] = if_r;
	assign SS_Top_BACK[17] = old_vblank_irq;
	assign SS_Top_BACK[18] = old_video_irq;
	assign SS_Top_BACK[19] = old_timer_irq;
	assign SS_Top_BACK[20] = old_serial_irq;
	assign SS_Top_BACK[21] = old_ack;
	assign SS_Top_BACK[26:24] = ie_r[7:5];
	always @(negedge clk_sys)
		if (reset_ss) begin
			ie_r[4:0] <= SS_Top[11:7];
			if_r <= SS_Top[16:12];
			old_vblank_irq <= SS_Top[17];
			old_video_irq <= SS_Top[18];
			old_timer_irq <= SS_Top[19];
			old_serial_irq <= SS_Top[20];
			old_ack <= SS_Top[21];
			ie_r[7:5] <= SS_Top[26:24];
		end
		else if (ce_cpu) begin
			old_vblank_irq <= vblank_irq;
			if (~old_vblank_irq & vblank_irq)
				if_r[0] <= 1'b1;
			old_video_irq <= video_irq;
			if (~old_video_irq & video_irq)
				if_r[1] <= 1'b1;
			old_timer_irq <= timer_irq;
			if (~old_timer_irq & timer_irq)
				if_r[2] <= 1'b1;
			old_serial_irq <= serial_irq;
			if (~old_serial_irq & serial_irq)
				if_r[3] <= 1'b1;
			inputD <= joy_din;
			inputD2 <= inputD;
			if (~inputD & inputD2)
				if_r[4] <= 1'b1;
			old_ack <= irq_ack;
			if (old_ack & ~irq_ack) begin
				if (if_r[0] && ie_r[0])
					if_r[0] <= 1'b0;
				else if (if_r[1] && ie_r[1])
					if_r[1] <= 1'b0;
				else if (if_r[2] && ie_r[2])
					if_r[2] <= 1'b0;
				else if (if_r[3] && ie_r[3])
					if_r[3] <= 1'b0;
				else if (if_r[4] && ie_r[4])
					if_r[4] <= 1'b0;
			end
			if (sel_ie && !cpu_wr_n_edge)
				ie_r <= cpu_do;
			if (sel_if && !cpu_wr_n_edge)
				if_r <= cpu_do[4:0];
		end
	timer timer(
		.reset(reset_ss),
		.clk_sys(clk_sys),
		.ce(ce_cpu),
		.ce_4MHz(ce),
		.cpu_speed(cpu_speed),
		.irq(timer_irq),
		.cpu_sel(sel_timer),
		.cpu_addr(cpu_addr[1:0]),
		.cpu_wr(!cpu_wr_n_edge),
		.cpu_di(cpu_do),
		.cpu_do(timer_do),
		.apu_framecount_en(apu_framecount_en),
		.SaveStateBus_Din(SaveStateBus_Din),
		.SaveStateBus_Adr(SaveStateBus_Adr),
		.SaveStateBus_wren(SaveStateBus_wren),
		.SaveStateBus_rst(SaveStateBus_rst),
		.SaveStateBus_Dout(SaveStateBus_wired_or[1])
	);
	wire [12:0] video_addr;
	wire video_rd;
	wire dma_rd;
	wire [7:0] dma_data = (isGBC & dma_sel_wram ? wram_do : (dma_sel_ext_bus ? ext_bus_di : (dma_sel_vram ? (isGBC & vram_bank ? vram1_do : vram_do) : 8'hff)));
	video video(
		.reset(reset_ss),
		.clk(clk_sys),
		.ce(ce),
		.ce_n(ce_n),
		.ce_cpu(ce_cpu),
		.isGBC(isGBC),
		.isGBC_mode(isGBC_mode),
		.megaduck(megaduck),
		.boot_rom_en(boot_rom_enabled),
		.irq(video_irq),
		.vblank_irq(vblank_irq),
		.cpu_sel_reg(sel_video_reg),
		.cpu_sel_oam(sel_video_oam),
		.cpu_addr(cpu_addr[7:0]),
		.cpu_wr(!cpu_wr_n_edge),
		.cpu_di(cpu_do),
		.cpu_do(video_do),
		.cpu_phi(cpu_phi),
		.cpu_phi_r_ce(cpu_phi_r_ce),
		.cpu_phi_f_ce(cpu_phi_f_ce),
		.lcd_on(lcd_on),
		.lcd_clkena(lcd_clkena),
		.lcd_data(lcd_data),
		.lcd_data_gb(lcd_data_gb),
		.mode(lcd_mode),
		.lcd_vsync(lcd_vsync),
		.oam_cpu_allow(oam_cpu_allow),
		.vram_cpu_allow(vram_cpu_allow),
		.vram_rd(video_rd),
		.vram_addr(video_addr),
		.vram_data(vram_do),
		.vram1_data(vram1_do),
		.dma_rd(dma_rd),
		.dma_addr(dma_addr),
		.dma_data(dma_data),
		.extra_spr_en(extra_spr_en),
		.extra_wait(((isGBC & hdma_rd) | dma_rd) | sel_vram),
		.Savestate_OAMRAMAddr(Savestate_RAMAddr[7:0]),
		.Savestate_OAMRAMRWrEn(Savestate_RAMRWrEn[2]),
		.Savestate_OAMRAMWriteData(Savestate_RAMWriteData[7:0]),
		.Savestate_OAMRAMReadData(Savestate_RAMReadData_ORAM),
		.SaveStateBus_Din(SaveStateBus_Din),
		.SaveStateBus_Adr(SaveStateBus_Adr),
		.SaveStateBus_wren(SaveStateBus_wren),
		.SaveStateBus_rst(SaveStateBus_rst),
		.SaveStateBus_Dout(SaveStateBus_wired_or[4])
	);
	wire cpu_wr_vram = (sel_vram && !cpu_wr_n) && vram_cpu_allow;
	wire hdma_read_ext_bus = (isGBC & hdma_rd) & hdma_sel_ext_bus;
	wire hdma_read_wram_bus = (isGBC & hdma_rd) & hdma_sel_wram;
	wire [7:0] vram_di = (hdma_read_wram_bus ? wram_do : (hdma_read_ext_bus ? ext_bus_di : cpu_do));
	wire vram_wren = (video_rd ? 1'b0 : !vram_bank && (((hdma_rd & isGBC) & ~phi_2m) | cpu_wr_vram));
	wire vram1_wren = (video_rd ? 1'b0 : vram_bank && (((hdma_rd & isGBC) & ~phi_2m) | cpu_wr_vram));
	wire [15:0] hdma_target_addr;
	wire [12:0] vram_addr = (video_rd ? video_addr : (hdma_rd && isGBC ? hdma_target_addr[12:0] : (dma_rd && dma_sel_vram ? dma_addr[12:0] : cpu_addr[12:0])));
	wire [7:0] Savestate_RAMReadData_VRAM0;
	wire [7:0] Savestate_RAMReadData_VRAM1;
	dpram #(.addr_width(13)) vram0(
		.clock_a(clk_sys),
		.clken_a(ce_cpu),
		.address_a(vram_addr),
		.wren_a(vram_wren),
		.data_a(vram_di),
		.q_a(vram_do),
		.clock_b(clk_sys),
		.address_b(Savestate_RAMAddr[12:0]),
		.wren_b(Savestate_RAMRWrEn[1] & !Savestate_RAMAddr[13]),
		.data_b(Savestate_RAMWriteData[7:0]),
		.q_b(Savestate_RAMReadData_VRAM0)
	);
	dpram #(.addr_width(13)) vram1(
		.clock_a(clk_sys),
		.clken_a(ce_cpu),
		.address_a(vram_addr),
		.wren_a(vram1_wren),
		.data_a(vram_di),
		.q_a(vram1_do),
		.clock_b(clk_sys),
		.address_b(Savestate_RAMAddr[12:0]),
		.wren_b(Savestate_RAMRWrEn[1] & Savestate_RAMAddr[13]),
		.data_b(Savestate_RAMWriteData[7:0]),
		.q_b(Savestate_RAMReadData_VRAM1)
	);
	assign Savestate_RAMReadData_VRAM = (Savestate_RAMAddr[13] ? Savestate_RAMReadData_VRAM1 : Savestate_RAMReadData_VRAM0);
	assign SS_Top_BACK[22] = vram_bank;
	always @(posedge clk_sys)
		if (reset_ss)
			vram_bank <= SS_Top[22];
		else if (ce_cpu) begin
			if (((cpu_addr == 16'hff4f) && !cpu_wr_n_edge) && isGBC)
				vram_bank <= cpu_do[0];
		end
	hdma hdma(
		.reset(reset_ss),
		.clk(clk_sys),
		.ce(ce_cpu),
		.speed(cpu_speed),
		.sel_reg(sel_hdma),
		.addr(cpu_addr[3:0]),
		.wr(!cpu_wr_n_edge),
		.dout(hdma_do),
		.din(cpu_do),
		.cpu_phi_r_ce(cpu_phi_r_ce),
		.cpu_phi_f_ce(cpu_phi_f_ce),
		.hdma_phi_r_ce(hdma_phi_r_ce),
		.hdma_phi_f_ce(hdma_phi_f_ce),
		.lcd_mode(lcd_mode),
		.hdma_rd(hdma_rd),
		.hdma_source_addr(hdma_source_addr),
		.hdma_target_addr(hdma_target_addr),
		.SaveStateBus_Din(SaveStateBus_Din),
		.SaveStateBus_Adr(SaveStateBus_Adr),
		.SaveStateBus_wren(SaveStateBus_wren),
		.SaveStateBus_rst(SaveStateBus_rst),
		.SaveStateBus_Dout(SaveStateBus_wired_or[2])
	);
	wire cpu_wr_zpram = sel_zpram && !cpu_wr_n;
	dpram_blk #(.addr_width(7)) zpram(
		.clock_a(clk_sys),
		.clken_a(ce_cpu),
		.address_a(cpu_addr[6:0]),
		.wren_a(cpu_wr_zpram),
		.data_a(cpu_do),
		.q_a(zpram_do),
		.clock_b(clk_sys),
		.address_b(Savestate_RAMAddr[6:0]),
		.wren_b(Savestate_RAMRWrEn[3]),
		.data_b(Savestate_RAMWriteData[7:0]),
		.q_b(Savestate_RAMReadData_ZRAM)
	);
	wire dma_read_wram_bus = dma_rd & dma_sel_wram;
	wire wram_wren = (~isGBC ? ext_bus_wram_sel & ext_bus_wr : ((sel_wram & ~cpu_wr_n_edge) & ~hdma_read_wram_bus) & ~dma_read_wram_bus);
	wire [12:0] wram_addr_i = (~isGBC ? ext_bus_addr[12:0] : (hdma_read_wram_bus ? hdma_source_addr[12:0] : (dma_read_wram_bus ? dma_addr[12:0] : cpu_addr[12:0])));
	wire [2:0] wram_bank_o = (!wram_bank ? 3'd1 : wram_bank);
	wire [14:0] wram_addr = (wram_addr_i[12] ? {wram_bank_o, wram_addr_i[11:0]} : {3'd0, wram_addr_i[11:0]});
	dpram #(.addr_width(15)) wram(
		.clock_a(clk_sys),
		.clken_a(ce_cpu),
		.address_a(wram_addr),
		.wren_a(wram_wren),
		.data_a(cpu_do),
		.q_a(wram_do),
		.clock_b(clk_sys),
		.address_b(Savestate_RAMAddr[14:0]),
		.wren_b(Savestate_RAMRWrEn[0]),
		.data_b(Savestate_RAMWriteData[7:0]),
		.q_b(Savestate_RAMReadData_WRAM)
	);
	assign SS_Top_BACK[2:0] = wram_bank;
	always @(posedge clk_sys)
		if (reset_ss)
			wram_bank <= SS_Top[2:0];
		else if ((ce_cpu && sel_wram_bank) && !cpu_wr_n_edge)
			wram_bank <= cpu_do[2:0];
	assign SS_Top_BACK[23] = boot_rom_enabled;
	always @(posedge clk_sys)
		if (reset_ss)
			boot_rom_enabled <= SS_Top[23];
		else if (ce) begin
			if (((cpu_addr == 16'hff50) && !cpu_wr_n_edge) && cpu_do[0])
				boot_rom_enabled <= 1'b0;
		end
	wire [15:0] boot_rom_addr = (isGBC && hdma_rd ? hdma_source_addr : cpu_addr);
	assign sel_boot_rom_cgb = isGBC && ((boot_rom_addr[15:8] >= 8'h02) && (boot_rom_addr[15:8] <= 8'h08));
	assign sel_boot_rom = (boot_rom_enabled && (!boot_rom_addr[15:8] || sel_boot_rom_cgb)) && ~megaduck;
	wire [11:0] boot_addr = (isGBC ? boot_rom_addr[11:0] : (isSGB ? {4'ha, boot_rom_addr[7:0]} : {4'h9, boot_rom_addr[7:0]}));
	wire boot_download = (cgb_boot_download | dmg_boot_download) | sgb_boot_download;
	wire [10:0] boot_wr_addr = (dmg_boot_download ? {4'h9, ioctl_addr[7:1]} : (sgb_boot_download ? {4'ha, ioctl_addr[7:1]} : ioctl_addr[11:1]));
	wire [7:0] boot_q;
	boot_rom boot_rom(
		.clk(clk_sys),
		.addr(boot_addr),
		.q(boot_q)
	);
	reg [7:0] boot_do_gba;
	always case (boot_addr)
		12'h0f2: boot_do_gba = 8'h00;
		12'h0f3: boot_do_gba = 8'h00;
		12'h0f5: boot_do_gba = 8'hcd;
		12'h0f6: boot_do_gba = 8'hd0;
		12'h0f7: boot_do_gba = 8'h05;
		12'h0f8: boot_do_gba = 8'haf;
		12'h0f9: boot_do_gba = 8'he0;
		12'h0fa: boot_do_gba = 8'h70;
		12'h0fb: boot_do_gba = 8'h04;
		12'h409: boot_do_gba = 8'h80;
		12'h40a: boot_do_gba = 8'hff;
		default: boot_do_gba = boot_q;
	endcase
	assign boot_do = ((isGBC && boot_gba_en) && real_cgb_boot ? boot_do_gba : boot_q);
	reg [7:0] open_bus_data;
	reg [2:0] open_bus_cnt;
	assign SS_Top2_BACK[7:0] = open_bus_data;
	assign SS_Top2_BACK[10:8] = open_bus_cnt;
	always @(posedge clk_sys)
		if (reset_ss) begin
			open_bus_data <= SS_Top2[7:0];
			open_bus_cnt <= SS_Top2[10:8];
		end
		else if (ce) begin
			open_bus_data <= ext_bus_di;
			if ((~isGBC & ext_bus_wram_sel) | (cart_sel & cart_oe))
				open_bus_cnt <= 0;
			else if (~&open_bus_cnt) begin
				open_bus_cnt <= open_bus_cnt + 1'b1;
				if (open_bus_cnt == 3'd4)
					open_bus_data <= 8'hff;
			end
		end
	assign cart_di = cpu_do;
	wire dma_read_ext_bus = dma_rd & dma_sel_ext_bus;
	assign nCS = ~(hdma_read_ext_bus ? hdma_sel_cram : (dma_read_ext_bus ? dma_sel_ext_ram : sel_cram | sel_wram));
	wire [15:0] ext_bus_i = (hdma_read_ext_bus ? hdma_source_addr : (dma_read_ext_bus ? dma_addr : cpu_addr));
	assign ext_bus_a15 = ext_bus_i[15] | sel_boot_rom;
	assign ext_bus_addr = ext_bus_i[14:0];
	assign ext_bus_rd = (hdma_read_ext_bus | dma_read_ext_bus) | (sel_ext_bus & ~cpu_rd_n);
	assign ext_bus_wr = ((sel_ext_bus & ~cpu_wr_n) & ~hdma_read_ext_bus) & ~dma_read_ext_bus;
	assign ext_bus_wram_sel = ~nCS & ext_bus_addr[14];
	assign ext_bus_cram_sel = ~nCS & ~ext_bus_addr[14];
	assign ext_bus_rom_sel = ~ext_bus_a15;
	assign ext_bus_di = (~isGBC & ext_bus_wram_sel ? wram_do : (cart_sel & cart_oe ? cart_do : open_bus_data));
	assign cart_sel = ext_bus_rom_sel | ext_bus_cram_sel;
	assign cart_rd = cart_sel & ext_bus_rd;
	assign cart_wr = cart_sel & ext_bus_wr;
	assign PHI = (hdma_read_ext_bus ? phi_2m : cpu_phi);
	wire phi_early = (cpu_speed | hdma_read_ext_bus ? phi_early_2m : phi_early_1m);
	assign sdram_rd = ~phi_early;
	assign DMA_on = cart_sel & (hdma_rd | dma_rd);
	wire savestate_savestate;
	wire savestate_loadstate;
	wire [31:0] savestate_address;
	wire savestate_busy;
	wire savestate_loaded;
	assign SaveStateExt_Din = SaveStateBus_Din;
	assign SaveStateExt_Adr = SaveStateBus_Adr;
	assign SaveStateExt_wren = SaveStateBus_wren;
	assign SaveStateExt_rst = SaveStateBus_rst;
	assign SaveStateExt_load = savestate_loaded;
	assign Savestate_CRAMAddr = Savestate_RAMAddr;
	assign Savestate_CRAMRdEn = Savestate_RAMRdEn[4];
	assign Savestate_CRAMRWrEn = Savestate_RAMRWrEn[4];
	assign Savestate_CRAMWriteData = Savestate_RAMWriteData;
	wire [63:0] SaveStateBus_Dout = (((((((SaveStateBus_wired_or[0] | SaveStateBus_wired_or[1]) | SaveStateBus_wired_or[2]) | SaveStateBus_wired_or[3]) | SaveStateBus_wired_or[4]) | SaveStateBus_wired_or[5]) | SaveStateBus_wired_or[6]) | SaveStateBus_wired_or[7]) | SaveStateExt_Dout;
	wire sleep_rewind;
	wire sleep_savestates;
	wire loading_savestate;
	wire saving_savestate;
	gb_savestates gb_savestates(
		.clk(clk_sys),
		.reset_in(reset_r),
		.reset_out(reset_ss),
		.load_done(savestate_loaded),
		.increaseSSHeaderCount(increaseSSHeaderCount),
		.save(savestate_savestate),
		.load(savestate_loadstate),
		.savestate_address(savestate_address),
		.savestate_busy(savestate_busy),
		.cart_ram_size(cart_ram_size),
		.lcd_vsync(lcd_vsync),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_Dout),
		.loading_savestate(loading_savestate),
		.saving_savestate(saving_savestate),
		.sleep_savestate(sleep_savestates),
		.clock_ena_in(ce_2x),
		.memory_busy(savestate_sdram_busy),
		.Save_RAMAddr(Savestate_RAMAddr),
		.Save_RAMRdEn(Savestate_RAMRdEn),
		.Save_RAMWrEn(Savestate_RAMRWrEn),
		.Save_RAMWriteData(Savestate_RAMWriteData),
		.Save_RAMReadData_WRAM(Savestate_RAMReadData_WRAM),
		.Save_RAMReadData_VRAM(Savestate_RAMReadData_VRAM),
		.Save_RAMReadData_ORAM(Savestate_RAMReadData_ORAM),
		.Save_RAMReadData_ZRAM(Savestate_RAMReadData_ZRAM),
		.Save_RAMReadData_CRAM(Savestate_CRAMReadData),
		.bus_out_Din(SAVE_out_Din),
		.bus_out_Dout(SAVE_out_Dout),
		.bus_out_Adr(SAVE_out_Adr),
		.bus_out_rnw(SAVE_out_rnw),
		.bus_out_ena(SAVE_out_ena),
		.bus_out_be(SAVE_out_be),
		.bus_out_done(SAVE_out_done)
	);
	gb_statemanager #(
		.Softmap_SaveState_ADDR(58720256),
		.Softmap_Rewind_ADDR(33554432)
	) gb_statemanager(
		.clk(clk_sys),
		.reset(reset_r),
		.rewind_on(rewind_on),
		.rewind_active(rewind_active),
		.savestate_number(savestate_number),
		.save(save_state),
		.load(load_state),
		.sleep_rewind(sleep_rewind),
		.vsync(lcd_vsync),
		.request_savestate(savestate_savestate),
		.request_loadstate(savestate_loadstate),
		.request_address(savestate_address),
		.request_busy(savestate_busy)
	);
	assign sleep_savestate = sleep_rewind | sleep_savestates;
	assign savestate_ovr = loading_savestate | saving_savestate;
endmodule
module video (
	reset,
	clk,
	ce,
	ce_n,
	ce_cpu,
	isGBC,
	isGBC_mode,
	megaduck,
	boot_rom_en,
	cpu_sel_oam,
	cpu_sel_reg,
	cpu_addr,
	cpu_wr,
	cpu_di,
	cpu_do,
	cpu_phi,
	cpu_phi_r_ce,
	cpu_phi_f_ce,
	lcd_on,
	lcd_clkena,
	lcd_data,
	lcd_data_gb,
	lcd_vsync,
	irq,
	vblank_irq,
	mode,
	oam_cpu_allow,
	vram_cpu_allow,
	vram_rd,
	vram_addr,
	vram_data,
	vram1_data,
	dma_rd,
	dma_addr,
	dma_data,
	extra_spr_en,
	extra_wait,
	Savestate_OAMRAMAddr,
	Savestate_OAMRAMRWrEn,
	Savestate_OAMRAMWriteData,
	Savestate_OAMRAMReadData,
	SaveStateBus_Din,
	SaveStateBus_Adr,
	SaveStateBus_wren,
	SaveStateBus_rst,
	SaveStateBus_Dout
);
	input reset;
	input clk;
	input ce;
	input ce_n;
	input ce_cpu;
	input isGBC;
	input isGBC_mode;
	input megaduck;
	input boot_rom_en;
	input cpu_sel_oam;
	input cpu_sel_reg;
	input [7:0] cpu_addr;
	input cpu_wr;
	input [7:0] cpu_di;
	output wire [7:0] cpu_do;
	input cpu_phi;
	input cpu_phi_r_ce;
	input cpu_phi_f_ce;
	output wire lcd_on;
	output wire lcd_clkena;
	output wire [14:0] lcd_data;
	output wire [1:0] lcd_data_gb;
	output wire lcd_vsync;
	output wire irq;
	output wire vblank_irq;
	output wire [1:0] mode;
	output wire oam_cpu_allow;
	output wire vram_cpu_allow;
	output wire vram_rd;
	output wire [12:0] vram_addr;
	input [7:0] vram_data;
	input [7:0] vram1_data;
	output wire dma_rd;
	output wire [15:0] dma_addr;
	input [7:0] dma_data;
	input extra_spr_en;
	input extra_wait;
	input [7:0] Savestate_OAMRAMAddr;
	input Savestate_OAMRAMRWrEn;
	input [7:0] Savestate_OAMRAMWriteData;
	output wire [7:0] Savestate_OAMRAMReadData;
	input [63:0] SaveStateBus_Din;
	input [9:0] SaveStateBus_Adr;
	input SaveStateBus_wren;
	input SaveStateBus_rst;
	output wire [63:0] SaveStateBus_Dout;
	localparam SAVESTATE_MODULES = 19;
	wire [63:0] SaveStateBus_wired_or [0:18];
	wire [62:0] SS_Video1;
	wire [62:0] SS_Video1_BACK;
	wire [63:0] SS_Video2;
	wire [63:0] SS_Video2_BACK;
	wire [63:0] SS_Video3;
	wire [63:0] SS_Video3_BACK;
	eReg_SavestateV #(
		.index(0),
		.Adr(9),
		.upper(60),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_Video1(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[0]),
		.Din(SS_Video1_BACK),
		.Dout(SS_Video1)
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(10),
		.upper(63),
		.lower(0),
		.def(64'h00000000fffffc00)
	) iREG_SAVESTATE_Video2(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[1]),
		.Din(SS_Video2_BACK),
		.Dout(SS_Video2)
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(27),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_Video3(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[18]),
		.Din(SS_Video3_BACK),
		.Dout(SS_Video3)
	);
	wire [63:0] SS_BPAL [7:0];
	wire [63:0] SS_BPAL_BACK [7:0];
	wire [63:0] SS_OPAL [7:0];
	wire [63:0] SS_OPAL_BACK [7:0];
	eReg_SavestateV #(
		.index(0),
		.Adr(11),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_BPAL0(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[2]),
		.Din(SS_BPAL_BACK[0]),
		.Dout(SS_BPAL[0])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(12),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_BPAL1(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[3]),
		.Din(SS_BPAL_BACK[1]),
		.Dout(SS_BPAL[1])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(13),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_BPAL2(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[4]),
		.Din(SS_BPAL_BACK[2]),
		.Dout(SS_BPAL[2])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(14),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_BPAL3(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[5]),
		.Din(SS_BPAL_BACK[3]),
		.Dout(SS_BPAL[3])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(15),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_BPAL4(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[6]),
		.Din(SS_BPAL_BACK[4]),
		.Dout(SS_BPAL[4])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(16),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_BPAL5(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[7]),
		.Din(SS_BPAL_BACK[5]),
		.Dout(SS_BPAL[5])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(17),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_BPAL6(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[8]),
		.Din(SS_BPAL_BACK[6]),
		.Dout(SS_BPAL[6])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(18),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_BPAL7(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[9]),
		.Din(SS_BPAL_BACK[7]),
		.Dout(SS_BPAL[7])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(19),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_OPAL0(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[10]),
		.Din(SS_OPAL_BACK[0]),
		.Dout(SS_OPAL[0])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(20),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_OPAL1(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[11]),
		.Din(SS_OPAL_BACK[1]),
		.Dout(SS_OPAL[1])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(21),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_OPAL2(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[12]),
		.Din(SS_OPAL_BACK[2]),
		.Dout(SS_OPAL[2])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(22),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_OPAL3(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[13]),
		.Din(SS_OPAL_BACK[3]),
		.Dout(SS_OPAL[3])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(23),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_OPAL4(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[14]),
		.Din(SS_OPAL_BACK[4]),
		.Dout(SS_OPAL[4])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(24),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_OPAL5(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[15]),
		.Din(SS_OPAL_BACK[5]),
		.Dout(SS_OPAL[5])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(25),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_OPAL6(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[16]),
		.Din(SS_OPAL_BACK[6]),
		.Dout(SS_OPAL[6])
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(26),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_OPAL7(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_wired_or[17]),
		.Din(SS_OPAL_BACK[7]),
		.Dout(SS_OPAL[7])
	);
	assign SaveStateBus_Dout = (((((((((((((((((SaveStateBus_wired_or[0] | SaveStateBus_wired_or[1]) | SaveStateBus_wired_or[2]) | SaveStateBus_wired_or[3]) | SaveStateBus_wired_or[4]) | SaveStateBus_wired_or[5]) | SaveStateBus_wired_or[6]) | SaveStateBus_wired_or[7]) | SaveStateBus_wired_or[8]) | SaveStateBus_wired_or[9]) | SaveStateBus_wired_or[10]) | SaveStateBus_wired_or[11]) | SaveStateBus_wired_or[12]) | SaveStateBus_wired_or[13]) | SaveStateBus_wired_or[14]) | SaveStateBus_wired_or[15]) | SaveStateBus_wired_or[16]) | SaveStateBus_wired_or[17]) | SaveStateBus_wired_or[18];
	wire [7:0] oam_do;
	wire [10:0] sprite_addr;
	wire sprite_found;
	wire [7:0] sprite_attr;
	wire [3:0] sprite_index;
	wire oam_eval_end;
	reg dma_active;
	reg dma_written;
	reg dma_trigger;
	reg [7:0] dma;
	reg [7:0] dma_cnt;
	wire [7:0] oam_addr = (dma_active ? dma_addr[7:0] : cpu_addr);
	wire oam_wr = (dma_active & ~cpu_phi) | ((cpu_wr && cpu_sel_oam) && oam_cpu_allow);
	wire [7:0] oam_di = (dma_active ? dma_data : cpu_di);
	reg [7:0] lcdc;
	wire lcdc_on = (megaduck ? lcdc[7] : lcdc[7]);
	wire lcdc_win_tile_map_sel = (megaduck ? lcdc[3] : lcdc[6]);
	wire lcdc_win_ena = (megaduck ? lcdc[5] : lcdc[5]);
	wire lcdc_tile_data_sel = (megaduck ? lcdc[4] : lcdc[4]);
	wire lcdc_bg_tile_map_sel = (megaduck ? lcdc[2] : lcdc[3]);
	wire lcdc_spr_siz = (megaduck ? lcdc[1] : lcdc[2]);
	wire lcdc_spr_ena = (megaduck ? lcdc[0] : lcdc[1]);
	wire lcdc_bg_ena = (megaduck ? lcdc[6] : lcdc[0]) | (isGBC && isGBC_mode);
	wire lcdc_bg_prio = (megaduck ? lcdc[6] : lcdc[0]);
	assign lcd_on = lcdc_on;
	reg [7:0] stat_r;
	wire [7:0] stat = (((cpu_sel_reg & cpu_wr) & (cpu_addr == 8'h41)) & ~isGBC ? 8'hff : stat_r);
	reg [7:0] scy;
	reg [7:0] scx;
	reg [6:0] h_cnt;
	reg [1:0] h_div_cnt;
	reg [7:0] v_cnt;
	wire [7:0] ly = v_cnt;
	reg [7:0] lyc_r_dmg;
	reg [7:0] lyc_r_gbc;
	wire [7:0] lyc = (isGBC ? lyc_r_gbc : lyc_r_dmg);
	wire lyc_match = ly == lyc;
	reg [7:0] bgp;
	reg [7:0] obp0;
	reg [7:0] obp1;
	reg [7:0] wy;
	reg [7:0] wx;
	reg [5:0] bgpi;
	reg bgpi_ai;
	reg [7:0] bgpd [63:0];
	reg [5:0] obpi;
	reg obpi_ai;
	reg [7:0] obpd [63:0];
	reg ff6c_opri;
	reg obj_prio_dmg_mode;
	integer i;
	assign SS_Video1_BACK[0] = dma_active;
	assign SS_Video1_BACK[10:3] = dma_cnt;
	assign SS_Video1_BACK[61] = dma_written;
	assign SS_Video1_BACK[62] = dma_trigger;
	assign dma_addr = {dma, dma_cnt[7:0]};
	assign dma_rd = dma_active;
	always @(posedge clk)
		if (reset) begin
			dma_active <= SS_Video1[0];
			dma_cnt <= SS_Video1[10:3];
			dma_written <= SS_Video1[61];
			dma_trigger <= SS_Video1[62];
		end
		else begin
			if (((ce_cpu & cpu_sel_reg) && cpu_wr) && (cpu_addr == 8'h46))
				dma_written <= 1'b1;
			if (cpu_phi_r_ce) begin
				dma_trigger <= dma_written;
				if (dma_trigger)
					dma_active <= 1'b1;
				else if (dma_active) begin
					if (dma_cnt == 8'h9f)
						dma_active <= 1'b0;
					else
						dma_cnt <= dma_cnt + 1'b1;
				end
			end
			if (cpu_phi_f_ce) begin
				if (dma_trigger) begin
					dma_cnt <= 8'd0;
					dma_written <= 1'b0;
				end
			end
		end
	wire h_clk_en = lcd_on && (h_div_cnt == 2'd0);
	wire h_clk_en_neg = lcd_on && (h_div_cnt == 2'd2);
	wire hcnt_end = h_cnt == 7'd113;
	wire vblank = v_cnt >= 144;
	reg vblank_l;
	reg vblank_t;
	reg end_of_line;
	reg end_of_line_l;
	reg lyc_match_l;
	reg lyc_match_t;
	assign SS_Video3_BACK[0] = vblank_l;
	assign SS_Video3_BACK[1] = end_of_line;
	assign SS_Video3_BACK[2] = end_of_line_l;
	assign SS_Video3_BACK[3] = 0;
	assign SS_Video3_BACK[6] = vblank_t;
	always @(posedge clk)
		if (reset) begin
			vblank_l <= SS_Video3[0];
			end_of_line <= SS_Video3[1];
			end_of_line_l <= SS_Video3[2];
			vblank_t <= SS_Video3[6];
		end
		else if (!lcd_on) begin
			vblank_l <= 1'b0;
			end_of_line <= 1'b0;
			end_of_line_l <= 1'b0;
			vblank_t <= 1'b0;
		end
		else if (ce) begin
			vblank_l <= vblank_t;
			if (h_clk_en_neg & hcnt_end)
				end_of_line <= 1'b1;
			else if (end_of_line) begin
				if (h_clk_en)
					vblank_t <= vblank;
				if (h_clk_en_neg)
					end_of_line <= 1'b0;
			end
			end_of_line_l <= end_of_line;
		end
	assign SS_Video3_BACK[4] = lyc_match_l;
	always @(posedge clk)
		if (reset)
			lyc_match_l <= SS_Video3[4];
		else if (ce) begin
			lyc_match_l <= lyc_match_t;
			if (h_clk_en) begin
				lyc_match_t <= lyc_match;
				if ((lyc_match_t & ~lyc_match) & ~isGBC)
					lyc_match_l <= lyc_match;
			end
		end
	wire pcnt_reset;
	wire pcnt_end;
	reg win_first_fetch;
	wire mode3_end = (~sprite_found & pcnt_end) & ~(isGBC & win_first_fetch);
	reg mode3_end_l;
	assign SS_Video3_BACK[5] = mode3_end_l;
	always @(posedge clk)
		if (reset)
			mode3_end_l <= SS_Video3[5];
		else if (!lcd_on)
			mode3_end_l <= 1'b0;
		else if (ce) begin
			if (pcnt_reset)
				mode3_end_l <= 1'b0;
			else
				mode3_end_l <= mode3_end;
		end
	wire int_lyc = stat[6] & lyc_match_l;
	wire int_oam = (stat[5] & end_of_line_l) & ~vblank_l;
	wire int_vbl = stat[4] & vblank_l;
	wire int_hbl = (stat[3] & mode3_end_l) & ~vblank_l;
	assign irq = ((int_lyc | int_oam) | int_hbl) | int_vbl;
	assign vblank_irq = vblank_l;
	wire oam_eval;
	wire mode3 = (lcd_on & ~mode3_end_l) & oam_eval_end;
	reg mode3_l;
	reg oam_eval_l;
	assign SS_Video1_BACK[59] = mode3_l;
	assign SS_Video1_BACK[60] = oam_eval_l;
	always @(posedge clk)
		if (reset) begin
			mode3_l <= SS_Video1[59];
			oam_eval_l <= SS_Video1[60];
		end
		else if (~lcd_on) begin
			mode3_l <= 1'b0;
			oam_eval_l <= 1'b0;
		end
		else if (ce) begin
			mode3_l <= mode3;
			oam_eval_l <= oam_eval;
		end
	wire mode_vblank = (isGBC ? vblank_l : vblank_l & vblank_t);
	assign mode = (mode_vblank ? 2'b01 : (oam_eval_l ? 2'b10 : (mode3_l & ~mode3_end ? 2'b11 : 2'b00)));
	assign oam_cpu_allow = ~((oam_eval | mode3) | dma_active);
	assign vram_cpu_allow = ~mode3;
	assign SS_Video1_BACK[18:11] = dma;
	assign SS_Video1_BACK[26:19] = lcdc;
	assign SS_Video1_BACK[34:27] = scy;
	assign SS_Video1_BACK[42:35] = scx;
	assign SS_Video1_BACK[50:43] = wy;
	assign SS_Video1_BACK[58:51] = wx;
	assign SS_Video2_BACK[7:0] = stat_r;
	assign SS_Video2_BACK[15:8] = bgp;
	assign SS_Video2_BACK[23:16] = obp0;
	assign SS_Video2_BACK[31:24] = obp1;
	assign SS_Video2_BACK[37:32] = bgpi;
	assign SS_Video2_BACK[43:38] = obpi;
	assign SS_Video2_BACK[44] = bgpi_ai;
	assign SS_Video2_BACK[45] = obpi_ai;
	assign SS_Video2_BACK[53:46] = lyc_r_gbc;
	assign SS_Video2_BACK[61:54] = lyc_r_dmg;
	assign SS_Video2_BACK[62] = ff6c_opri;
	assign SS_Video2_BACK[63] = obj_prio_dmg_mode;
	genvar _gv_palI_1;
	generate
		for (_gv_palI_1 = 0; _gv_palI_1 < 8; _gv_palI_1 = _gv_palI_1 + 1) begin : palette_readback
			localparam palI = _gv_palI_1;
			assign SS_BPAL_BACK[palI][7:0] = bgpd[(palI * 8) + 0];
			assign SS_BPAL_BACK[palI][15:8] = bgpd[(palI * 8) + 1];
			assign SS_BPAL_BACK[palI][23:16] = bgpd[(palI * 8) + 2];
			assign SS_BPAL_BACK[palI][31:24] = bgpd[(palI * 8) + 3];
			assign SS_BPAL_BACK[palI][39:32] = bgpd[(palI * 8) + 4];
			assign SS_BPAL_BACK[palI][47:40] = bgpd[(palI * 8) + 5];
			assign SS_BPAL_BACK[palI][55:48] = bgpd[(palI * 8) + 6];
			assign SS_BPAL_BACK[palI][63:56] = bgpd[(palI * 8) + 7];
			assign SS_OPAL_BACK[palI][7:0] = obpd[(palI * 8) + 0];
			assign SS_OPAL_BACK[palI][15:8] = obpd[(palI * 8) + 1];
			assign SS_OPAL_BACK[palI][23:16] = obpd[(palI * 8) + 2];
			assign SS_OPAL_BACK[palI][31:24] = obpd[(palI * 8) + 3];
			assign SS_OPAL_BACK[palI][39:32] = obpd[(palI * 8) + 4];
			assign SS_OPAL_BACK[palI][47:40] = obpd[(palI * 8) + 5];
			assign SS_OPAL_BACK[palI][55:48] = obpd[(palI * 8) + 6];
			assign SS_OPAL_BACK[palI][63:56] = obpd[(palI * 8) + 7];
		end
	endgenerate
	always @(negedge clk)
		if (reset) begin
			lcdc <= SS_Video1[26:19];
			lyc_r_dmg <= SS_Video2[61:54];
		end
		else if (ce_cpu) begin
			if (cpu_sel_reg && cpu_wr)
				case (cpu_addr)
					8'h40: lcdc <= cpu_di;
					8'h45: lyc_r_dmg <= cpu_di;
				endcase
		end
	always @(posedge clk)
		if (reset) begin
			dma <= SS_Video1[18:11];
			scy <= SS_Video1[34:27];
			scx <= SS_Video1[42:35];
			wy <= SS_Video1[50:43];
			wx <= SS_Video1[58:51];
			stat_r <= SS_Video2[7:0];
			bgp <= SS_Video2[15:8];
			obp0 <= SS_Video2[23:16];
			obp1 <= SS_Video2[31:24];
			bgpi <= SS_Video2[37:32];
			obpi <= SS_Video2[43:38];
			bgpi_ai <= SS_Video2[44];
			obpi_ai <= SS_Video2[45];
			lyc_r_gbc <= SS_Video2[53:46];
			ff6c_opri <= SS_Video2[62];
			obj_prio_dmg_mode <= SS_Video2[63];
			bgpd[0] <= SS_BPAL[0][7:0];
			bgpd[16] <= SS_BPAL[2][7:0];
			bgpd[32] <= SS_BPAL[4][7:0];
			bgpd[48] <= SS_BPAL[6][7:0];
			bgpd[1] <= SS_BPAL[0][15:8];
			bgpd[17] <= SS_BPAL[2][15:8];
			bgpd[33] <= SS_BPAL[4][15:8];
			bgpd[49] <= SS_BPAL[6][15:8];
			bgpd[2] <= SS_BPAL[0][23:16];
			bgpd[18] <= SS_BPAL[2][23:16];
			bgpd[34] <= SS_BPAL[4][23:16];
			bgpd[50] <= SS_BPAL[6][23:16];
			bgpd[3] <= SS_BPAL[0][31:24];
			bgpd[19] <= SS_BPAL[2][31:24];
			bgpd[35] <= SS_BPAL[4][31:24];
			bgpd[51] <= SS_BPAL[6][31:24];
			bgpd[4] <= SS_BPAL[0][39:32];
			bgpd[20] <= SS_BPAL[2][39:32];
			bgpd[36] <= SS_BPAL[4][39:32];
			bgpd[52] <= SS_BPAL[6][39:32];
			bgpd[5] <= SS_BPAL[0][47:40];
			bgpd[21] <= SS_BPAL[2][47:40];
			bgpd[37] <= SS_BPAL[4][47:40];
			bgpd[53] <= SS_BPAL[6][47:40];
			bgpd[6] <= SS_BPAL[0][55:48];
			bgpd[22] <= SS_BPAL[2][55:48];
			bgpd[38] <= SS_BPAL[4][55:48];
			bgpd[54] <= SS_BPAL[6][55:48];
			bgpd[7] <= SS_BPAL[0][63:56];
			bgpd[23] <= SS_BPAL[2][63:56];
			bgpd[39] <= SS_BPAL[4][63:56];
			bgpd[55] <= SS_BPAL[6][63:56];
			bgpd[8] <= SS_BPAL[1][7:0];
			bgpd[24] <= SS_BPAL[3][7:0];
			bgpd[40] <= SS_BPAL[5][7:0];
			bgpd[56] <= SS_BPAL[7][7:0];
			bgpd[9] <= SS_BPAL[1][15:8];
			bgpd[25] <= SS_BPAL[3][15:8];
			bgpd[41] <= SS_BPAL[5][15:8];
			bgpd[57] <= SS_BPAL[7][15:8];
			bgpd[10] <= SS_BPAL[1][23:16];
			bgpd[26] <= SS_BPAL[3][23:16];
			bgpd[42] <= SS_BPAL[5][23:16];
			bgpd[58] <= SS_BPAL[7][23:16];
			bgpd[11] <= SS_BPAL[1][31:24];
			bgpd[27] <= SS_BPAL[3][31:24];
			bgpd[43] <= SS_BPAL[5][31:24];
			bgpd[59] <= SS_BPAL[7][31:24];
			bgpd[12] <= SS_BPAL[1][39:32];
			bgpd[28] <= SS_BPAL[3][39:32];
			bgpd[44] <= SS_BPAL[5][39:32];
			bgpd[60] <= SS_BPAL[7][39:32];
			bgpd[13] <= SS_BPAL[1][47:40];
			bgpd[29] <= SS_BPAL[3][47:40];
			bgpd[45] <= SS_BPAL[5][47:40];
			bgpd[61] <= SS_BPAL[7][47:40];
			bgpd[14] <= SS_BPAL[1][55:48];
			bgpd[30] <= SS_BPAL[3][55:48];
			bgpd[46] <= SS_BPAL[5][55:48];
			bgpd[62] <= SS_BPAL[7][55:48];
			bgpd[15] <= SS_BPAL[1][63:56];
			bgpd[31] <= SS_BPAL[3][63:56];
			bgpd[47] <= SS_BPAL[5][63:56];
			bgpd[63] <= SS_BPAL[7][63:56];
			obpd[0] <= SS_OPAL[0][7:0];
			obpd[16] <= SS_OPAL[2][7:0];
			obpd[32] <= SS_OPAL[4][7:0];
			obpd[48] <= SS_OPAL[6][7:0];
			obpd[1] <= SS_OPAL[0][15:8];
			obpd[17] <= SS_OPAL[2][15:8];
			obpd[33] <= SS_OPAL[4][15:8];
			obpd[49] <= SS_OPAL[6][15:8];
			obpd[2] <= SS_OPAL[0][23:16];
			obpd[18] <= SS_OPAL[2][23:16];
			obpd[34] <= SS_OPAL[4][23:16];
			obpd[50] <= SS_OPAL[6][23:16];
			obpd[3] <= SS_OPAL[0][31:24];
			obpd[19] <= SS_OPAL[2][31:24];
			obpd[35] <= SS_OPAL[4][31:24];
			obpd[51] <= SS_OPAL[6][31:24];
			obpd[4] <= SS_OPAL[0][39:32];
			obpd[20] <= SS_OPAL[2][39:32];
			obpd[36] <= SS_OPAL[4][39:32];
			obpd[52] <= SS_OPAL[6][39:32];
			obpd[5] <= SS_OPAL[0][47:40];
			obpd[21] <= SS_OPAL[2][47:40];
			obpd[37] <= SS_OPAL[4][47:40];
			obpd[53] <= SS_OPAL[6][47:40];
			obpd[6] <= SS_OPAL[0][55:48];
			obpd[22] <= SS_OPAL[2][55:48];
			obpd[38] <= SS_OPAL[4][55:48];
			obpd[54] <= SS_OPAL[6][55:48];
			obpd[7] <= SS_OPAL[0][63:56];
			obpd[23] <= SS_OPAL[2][63:56];
			obpd[39] <= SS_OPAL[4][63:56];
			obpd[55] <= SS_OPAL[6][63:56];
			obpd[8] <= SS_OPAL[1][7:0];
			obpd[24] <= SS_OPAL[3][7:0];
			obpd[40] <= SS_OPAL[5][7:0];
			obpd[56] <= SS_OPAL[7][7:0];
			obpd[9] <= SS_OPAL[1][15:8];
			obpd[25] <= SS_OPAL[3][15:8];
			obpd[41] <= SS_OPAL[5][15:8];
			obpd[57] <= SS_OPAL[7][15:8];
			obpd[10] <= SS_OPAL[1][23:16];
			obpd[26] <= SS_OPAL[3][23:16];
			obpd[42] <= SS_OPAL[5][23:16];
			obpd[58] <= SS_OPAL[7][23:16];
			obpd[11] <= SS_OPAL[1][31:24];
			obpd[27] <= SS_OPAL[3][31:24];
			obpd[43] <= SS_OPAL[5][31:24];
			obpd[59] <= SS_OPAL[7][31:24];
			obpd[12] <= SS_OPAL[1][39:32];
			obpd[28] <= SS_OPAL[3][39:32];
			obpd[44] <= SS_OPAL[5][39:32];
			obpd[60] <= SS_OPAL[7][39:32];
			obpd[13] <= SS_OPAL[1][47:40];
			obpd[29] <= SS_OPAL[3][47:40];
			obpd[45] <= SS_OPAL[5][47:40];
			obpd[61] <= SS_OPAL[7][47:40];
			obpd[14] <= SS_OPAL[1][55:48];
			obpd[30] <= SS_OPAL[3][55:48];
			obpd[46] <= SS_OPAL[5][55:48];
			obpd[62] <= SS_OPAL[7][55:48];
			obpd[15] <= SS_OPAL[1][63:56];
			obpd[31] <= SS_OPAL[3][63:56];
			obpd[47] <= SS_OPAL[5][63:56];
			obpd[63] <= SS_OPAL[7][63:56];
		end
		else if (ce_cpu) begin
			if (cpu_sel_reg && cpu_wr) begin
				case (cpu_addr)
					8'h41: stat_r <= cpu_di;
					8'h42: scy <= cpu_di;
					8'h43: scx <= cpu_di;
					8'h45: lyc_r_gbc <= cpu_di;
					8'h46: dma <= cpu_di;
					8'h47: bgp <= cpu_di;
					8'h48: obp0 <= cpu_di;
					8'h49: obp1 <= cpu_di;
					8'h4a: wy <= cpu_di;
					8'h4b: wx <= cpu_di;
				endcase
				if (isGBC)
					case (cpu_addr)
						8'h68: begin
							bgpi <= cpu_di[5:0];
							bgpi_ai <= cpu_di[7];
						end
						8'h69:
							if (isGBC_mode) begin
								if (vram_cpu_allow)
									bgpd[bgpi] <= cpu_di;
								if (bgpi_ai)
									bgpi <= bgpi + 6'h01;
							end
						8'h6a: begin
							obpi <= cpu_di[5:0];
							obpi_ai <= cpu_di[7];
						end
						8'h6b:
							if (isGBC_mode) begin
								if (vram_cpu_allow)
									obpd[obpi] <= cpu_di;
								if (obpi_ai)
									obpi <= obpi + 6'h01;
							end
						8'h6c: begin
							if (boot_rom_en | isGBC_mode)
								ff6c_opri <= cpu_di[0];
							if (boot_rom_en)
								obj_prio_dmg_mode <= cpu_di[0];
						end
					endcase
			end
		end
	assign cpu_do = (cpu_sel_oam ? oam_do : (cpu_addr == 8'h40 ? lcdc : (cpu_addr == 8'h41 ? {1'b1, stat[6:3], lyc_match_l, mode} : (cpu_addr == 8'h42 ? scy : (cpu_addr == 8'h43 ? scx : (cpu_addr == 8'h44 ? ly : (cpu_addr == 8'h45 ? lyc : (cpu_addr == 8'h46 ? dma : (cpu_addr == 8'h47 ? bgp : (cpu_addr == 8'h48 ? obp0 : (cpu_addr == 8'h49 ? obp1 : (cpu_addr == 8'h4a ? wy : (cpu_addr == 8'h4b ? wx : (isGBC ? (cpu_addr == 8'h68 ? {bgpi_ai, 1'd1, bgpi} : (((cpu_addr == 8'h69) && isGBC_mode) && vram_cpu_allow ? bgpd[bgpi] : (cpu_addr == 8'h6a ? {obpi_ai, 1'd1, obpi} : (((cpu_addr == 8'h6b) && isGBC_mode) && vram_cpu_allow ? obpd[obpi] : (cpu_addr == 8'h6c ? {7'h7f, ff6c_opri} : 8'hff))))) : 8'hff))))))))))))));
	reg [7:0] pcnt;
	reg bg_first_fetch_done;
	reg bg_scroll_done;
	wire bg_paused = ((~bg_first_fetch_done | win_first_fetch) | sprite_found) | mode3_end;
	reg [2:0] bg_shift_cnt;
	wire bg_scroll_end = (~bg_paused & (bg_shift_cnt == scx[2:0])) & ~bg_scroll_done;
	wire pcnt_paused = bg_paused | ~(bg_scroll_done | bg_scroll_end);
	assign pcnt_end = pcnt == 8'd167;
	assign pcnt_reset = (h_clk_en & end_of_line) & ~vblank;
	assign SS_Video3_BACK[17:10] = pcnt;
	assign SS_Video3_BACK[18] = bg_scroll_done;
	always @(posedge clk)
		if (reset) begin
			pcnt <= SS_Video3[17:10];
			bg_scroll_done <= SS_Video3[18];
		end
		else if (!lcd_on) begin
			pcnt <= 8'd0;
			bg_scroll_done <= 1'b0;
		end
		else if (ce) begin
			if (pcnt_reset)
				pcnt <= 8'd0;
			else if (~pcnt_paused)
				pcnt <= pcnt + 1'b1;
			if (~mode3)
				bg_scroll_done <= 1'b0;
			else if (bg_scroll_end)
				bg_scroll_done <= 1'b1;
		end
	wire line153 = v_cnt == 8'd153;
	reg vcnt_reset;
	reg vsync;
	reg vcnt_eol_l;
	assign SS_Video3_BACK[22] = vcnt_eol_l;
	assign SS_Video3_BACK[23] = vcnt_reset;
	assign SS_Video3_BACK[31:24] = v_cnt;
	assign SS_Video3_BACK[32] = vsync;
	always @(posedge clk)
		if (reset) begin
			vcnt_eol_l <= SS_Video3[22];
			vcnt_reset <= SS_Video3[23];
			v_cnt <= SS_Video3[31:24];
			vsync <= SS_Video3[32];
		end
		else if (!lcdc_on) begin
			vcnt_eol_l <= 1'b0;
			vcnt_reset <= 1'b0;
			v_cnt <= 8'd0;
			vsync <= 1'b0;
		end
		else if (ce) begin
			if ((~vcnt_reset & h_clk_en_neg) & hcnt_end)
				v_cnt <= v_cnt + 1'b1;
			if ((~isGBC & h_clk_en) | (isGBC & h_clk_en_neg)) begin
				vcnt_eol_l <= end_of_line;
				if (vcnt_eol_l & ~end_of_line) begin
					vcnt_reset <= line153;
					if (line153)
						v_cnt <= 8'd0;
					vsync <= !v_cnt;
				end
			end
		end
	assign lcd_vsync = vsync;
	wire [7:0] bg_line = v_cnt + scy;
	wire [7:0] bg_col = pcnt + scx;
	wire [9:0] bg_map_addr = {bg_line[7:3], bg_col[7:3]};
	reg [4:0] win_col;
	reg [7:0] win_line;
	wire window_ena;
	wire bg_fetch_done;
	wire bg_reload_shift;
	wire [9:0] win_map_addr = {win_line[7:3], win_col[4:0]};
	wire [9:0] bg_tile_map_addr = (window_ena ? win_map_addr : bg_map_addr);
	wire [2:0] tile_line = (window_ena ? win_line[2:0] : bg_line[2:0]);
	reg wy_match;
	reg wxy_match_d;
	reg window_match;
	reg window_ena_d;
	wire wxy_match = wy_match & (pcnt == wx);
	wire win_start = (~window_match & lcdc_win_ena) & ((~bg_paused & wxy_match) | wxy_match_d);
	wire win_reset = pcnt_reset | ~lcdc_win_ena;
	assign window_ena = window_match & ~win_reset;
	assign SS_Video3_BACK[39:33] = h_cnt;
	assign SS_Video3_BACK[41:40] = h_div_cnt;
	assign SS_Video3_BACK[42] = window_match;
	assign SS_Video3_BACK[43] = window_ena_d;
	assign SS_Video3_BACK[48:44] = win_col;
	assign SS_Video3_BACK[56:49] = win_line;
	assign SS_Video3_BACK[63] = wy_match;
	assign SS_Video3_BACK[19] = wxy_match_d;
	always @(posedge clk)
		if (reset) begin
			h_cnt <= SS_Video3[39:33];
			h_div_cnt <= SS_Video3[41:40];
			window_match <= SS_Video3[42];
			window_ena_d <= SS_Video3[43];
			win_col <= SS_Video3[48:44];
			win_line <= SS_Video3[56:49];
			wy_match <= SS_Video3[63];
			wxy_match_d <= SS_Video3[19];
		end
		else if (!lcdc_on) begin
			h_cnt <= 7'd0;
			h_div_cnt <= 2'd0;
			window_match <= 1'b0;
			window_ena_d <= 1'b0;
			win_col <= 5'd0;
			win_line <= 8'd0;
			wy_match <= 1'b0;
			wxy_match_d <= 1'b0;
		end
		else if (ce) begin
			h_div_cnt <= h_div_cnt + 1'b1;
			if (h_clk_en)
				h_cnt <= (hcnt_end ? 7'd0 : h_cnt + 1'b1);
			if (vblank_l)
				wy_match <= 1'b0;
			else if ((h_clk_en & lcdc_win_ena) & (v_cnt == wy))
				wy_match <= 1'b1;
			if (isGBC & ~mode3)
				wxy_match_d <= 0;
			else if (~bg_paused)
				wxy_match_d <= wxy_match;
			if (win_reset)
				window_match <= 1'b0;
			else if (win_start)
				window_match <= 1'b1;
			window_ena_d <= window_ena;
			if (vblank_l)
				win_line <= 8'd0;
			else if (window_ena_d & ~window_ena)
				win_line <= win_line + 1'b1;
			if (win_reset)
				win_col <= 5'd0;
			else if (window_ena & bg_reload_shift)
				win_col <= win_col + 1'b1;
		end
	function [7:0] bit_reverse;
		input [7:0] a;
		bit_reverse = {a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]};
	endfunction
	reg [7:0] tile_shift_0;
	reg [7:0] tile_shift_1;
	reg [7:0] spr_tile_shift_0;
	reg [7:0] spr_tile_shift_1;
	reg [7:0] spr_pal_shift;
	reg [7:0] spr_prio_shift;
	reg [7:0] spr_cgb_pal_shift [0:2];
	reg [7:0] spr_cgb_index_shift [0:3];
	reg [7:0] bg_tile;
	reg [7:0] bg_tile_data0;
	reg [7:0] bg_tile_data1;
	reg [7:0] spr_tile_data0;
	reg [7:0] bg_tile_attr;
	reg [7:0] bg_tile_attr_new;
	wire [7:0] bg_vram_data_a = ((isGBC & isGBC_mode) & bg_tile_attr_new[3] ? vram1_data : vram_data);
	wire [7:0] bg_vram_data_in = ((isGBC & isGBC_mode) & bg_tile_attr_new[5] ? bit_reverse(bg_vram_data_a) : bg_vram_data_a);
	reg [2:0] bg_fetch_cycle;
	reg [2:0] sprite_fetch_cycle;
	assign bg_fetch_done = bg_fetch_cycle >= 3'd5;
	wire sprite_fetch_done = sprite_found && (sprite_fetch_cycle >= 3'd5);
	wire bg_shift_end = &bg_shift_cnt;
	assign bg_reload_shift = (bg_fetch_done & (~bg_first_fetch_done | win_first_fetch)) | ((~bg_paused & bg_shift_end) & ~(wxy_match & (lcdc_win_ena | ~isGBC)));
	wire spr_prio = sprite_attr[7];
	wire spr_attr_h_flip = sprite_attr[5];
	wire spr_pal = sprite_attr[4];
	wire spr_attr_cgb_bank = sprite_attr[3];
	wire [2:0] spr_cgb_pal = sprite_attr[2:0];
	wire [7:0] spr_vram_data = ((isGBC & isGBC_mode) & spr_attr_cgb_bank ? vram1_data : vram_data);
	wire [7:0] spr_tile_data_in = (spr_attr_h_flip ? bit_reverse(spr_vram_data) : spr_vram_data);
	wire [7:0] spr_pixel_empty = ~(spr_tile_shift_0 | spr_tile_shift_1);
	reg [7:0] spr_cgb_higher_prio;
	reg [7:0] spr_extra_cgb_higher_prio;
	wire [3:0] spr_extra_index;
	wire [7:0] spr_extra_tile [0:1];
	always @(*)
		for (i = 0; i < 8; i = i + 1)
			begin
				spr_cgb_higher_prio[i] = (sprite_index < {spr_cgb_index_shift[3][i], spr_cgb_index_shift[2][i], spr_cgb_index_shift[1][i], spr_cgb_index_shift[0][i]}) & (spr_tile_data_in[i] | spr_tile_data0[i]);
				spr_extra_cgb_higher_prio[i] = (spr_extra_index < {spr_cgb_index_shift[3][i], spr_cgb_index_shift[2][i], spr_cgb_index_shift[1][i], spr_cgb_index_shift[0][i]}) & (spr_extra_tile[0][i] | spr_extra_tile[1][i]);
			end
	wire [7:0] spr_extra_tile0_w;
	wire [7:0] spr_extra_tile1_w;
	assign spr_extra_tile[0] = spr_extra_tile0_w;
	assign spr_extra_tile[1] = spr_extra_tile1_w;
	wire [2:0] spr_extra_cgb_pal;
	wire spr_extra_pal;
	wire spr_extra_prio;
	wire spr_extra_found;
	wire bg_tile_map_rd = mode3 && (bg_fetch_cycle[2:1] == 2'b00);
	wire bg_tile_data0_rd = mode3 && (bg_fetch_cycle[2:1] == 2'b01);
	wire bg_tile_data1_rd = mode3 && (bg_fetch_cycle[2:1] == 2'b10);
	wire bg_tile_obj0_rd = mode3 && (sprite_fetch_cycle[2:1] == 2'b01);
	wire bg_tile_obj1_rd = mode3 && (sprite_fetch_cycle[2:1] == 2'b10);
	assign SS_Video3_BACK[59:57] = bg_fetch_cycle;
	assign SS_Video3_BACK[62:60] = sprite_fetch_cycle;
	assign SS_Video3_BACK[9:7] = bg_shift_cnt;
	assign SS_Video3_BACK[20] = bg_first_fetch_done;
	assign SS_Video3_BACK[21] = win_first_fetch;
	always @(posedge clk)
		if (reset) begin
			bg_fetch_cycle <= SS_Video3[59:57];
			sprite_fetch_cycle <= SS_Video3[62:60];
			bg_shift_cnt <= SS_Video3[9:7];
			bg_first_fetch_done <= SS_Video3[20];
			win_first_fetch <= SS_Video3[21];
		end
		else if (ce) begin
			if (bg_fetch_cycle[0]) begin
				if (bg_tile_map_rd) begin
					bg_tile <= vram_data;
					if (isGBC & isGBC_mode)
						bg_tile_attr_new <= vram1_data;
				end
				if (bg_tile_data0_rd)
					bg_tile_data0 <= bg_vram_data_in;
				if (bg_tile_data1_rd)
					bg_tile_data1 <= bg_vram_data_in;
			end
			if (~&bg_fetch_cycle)
				bg_fetch_cycle <= bg_fetch_cycle + 1'b1;
			if (~mode3)
				bg_first_fetch_done <= 0;
			else if (bg_fetch_done)
				bg_first_fetch_done <= 1'b1;
			if (~pcnt_paused) begin
				tile_shift_0 <= {tile_shift_0[6:0], 1'b0};
				tile_shift_1 <= {tile_shift_1[6:0], 1'b0};
			end
			if (bg_reload_shift) begin
				bg_tile_attr <= bg_tile_attr_new;
				tile_shift_0 <= bg_tile_data0;
				tile_shift_1 <= (bg_fetch_cycle == 3'd5 ? bg_vram_data_in : bg_tile_data1);
				bg_shift_cnt <= 0;
				bg_fetch_cycle <= 0;
			end
			if (~bg_paused) begin
				if (~bg_shift_end)
					bg_shift_cnt <= bg_shift_cnt + 1'b1;
			end
			if (((sprite_found & bg_fetch_done) & ~win_first_fetch) & bg_first_fetch_done)
				sprite_fetch_cycle <= sprite_fetch_cycle + 1'b1;
			if (~sprite_found || sprite_fetch_done)
				sprite_fetch_cycle <= 0;
			if (win_start | ~mode3) begin
				bg_fetch_cycle <= 0;
				bg_shift_cnt <= 0;
			end
			if (~lcd_on | (win_first_fetch & bg_fetch_done))
				win_first_fetch <= 0;
			else if (win_start)
				win_first_fetch <= 1'b1;
		end
	always @(posedge clk)
		if (reset)
			;
		else begin
			if (ce) begin
				if (~pcnt_paused) begin
					spr_tile_shift_0 <= spr_tile_shift_0 << 1;
					spr_tile_shift_1 <= spr_tile_shift_1 << 1;
					spr_pal_shift <= spr_pal_shift << 1;
					spr_prio_shift <= spr_prio_shift << 1;
					spr_cgb_pal_shift[0] <= spr_cgb_pal_shift[0] << 1;
					spr_cgb_pal_shift[1] <= spr_cgb_pal_shift[1] << 1;
					spr_cgb_pal_shift[2] <= spr_cgb_pal_shift[2] << 1;
					spr_cgb_index_shift[0] <= spr_cgb_index_shift[0] << 1;
					spr_cgb_index_shift[1] <= spr_cgb_index_shift[1] << 1;
					spr_cgb_index_shift[2] <= spr_cgb_index_shift[2] << 1;
					spr_cgb_index_shift[3] <= spr_cgb_index_shift[3] << 1;
				end
				if (sprite_fetch_cycle[0]) begin
					if (bg_tile_obj0_rd)
						spr_tile_data0 <= spr_tile_data_in;
					if (bg_tile_obj1_rd) begin
						for (i = 0; i < 8; i = i + 1)
							if (spr_pixel_empty[i] | ((isGBC & ~obj_prio_dmg_mode) & spr_cgb_higher_prio[i])) begin
								spr_tile_shift_0[i] <= spr_tile_data0[i];
								spr_tile_shift_1[i] <= spr_tile_data_in[i];
								spr_pal_shift[i] <= spr_pal;
								spr_prio_shift[i] <= spr_prio;
								spr_cgb_pal_shift[0][i] <= spr_cgb_pal[0];
								spr_cgb_pal_shift[1][i] <= spr_cgb_pal[1];
								spr_cgb_pal_shift[2][i] <= spr_cgb_pal[2];
								spr_cgb_index_shift[0][i] <= sprite_index[0];
								spr_cgb_index_shift[1][i] <= sprite_index[1];
								spr_cgb_index_shift[2][i] <= sprite_index[2];
								spr_cgb_index_shift[3][i] <= sprite_index[3];
							end
					end
				end
			end
			if (ce_n) begin
				if (~pcnt_paused & spr_extra_found) begin
					for (i = 0; i < 8; i = i + 1)
						if (spr_pixel_empty[i] | ((isGBC & ~obj_prio_dmg_mode) & spr_extra_cgb_higher_prio[i])) begin
							spr_tile_shift_0[i] <= spr_extra_tile[0][i];
							spr_tile_shift_1[i] <= spr_extra_tile[1][i];
							spr_pal_shift[i] <= spr_extra_pal;
							spr_prio_shift[i] <= spr_extra_prio;
							spr_cgb_pal_shift[0][i] <= spr_extra_cgb_pal[0];
							spr_cgb_pal_shift[1][i] <= spr_extra_cgb_pal[1];
							spr_cgb_pal_shift[2][i] <= spr_extra_cgb_pal[2];
							spr_cgb_index_shift[0][i] <= spr_extra_index[0];
							spr_cgb_index_shift[1][i] <= spr_extra_index[1];
							spr_cgb_index_shift[2][i] <= spr_extra_index[2];
							spr_cgb_index_shift[3][i] <= spr_extra_index[3];
						end
				end
			end
		end
	wire tile_obj_extra_rd;
	assign vram_rd = lcdc_on && (((((bg_tile_map_rd || bg_tile_data0_rd) || bg_tile_data1_rd) || bg_tile_obj0_rd) || bg_tile_obj1_rd) || tile_obj_extra_rd);
	wire bg_tile_a12 = (!lcdc_tile_data_sel ? ~bg_tile[7] : 1'b0);
	wire tile_map_sel = (window_ena ? lcdc_win_tile_map_sel : lcdc_bg_tile_map_sel);
	wire [2:0] tile_line_flip = ((isGBC && isGBC_mode) && bg_tile_attr_new[6] ? ~tile_line : tile_line);
	wire [11:0] sprite_extra_addr;
	assign vram_addr = (bg_tile_map_rd ? {2'b11, tile_map_sel, bg_tile_map_addr} : (bg_tile_data0_rd ? {bg_tile_a12, bg_tile, tile_line_flip, 1'b0} : (bg_tile_data1_rd ? {bg_tile_a12, bg_tile, tile_line_flip, 1'b1} : (bg_tile_obj0_rd ? {1'b0, sprite_addr, 1'b0} : (bg_tile_obj1_rd ? {1'b0, sprite_addr, 1'b1} : {1'b0, sprite_extra_addr})))));
	sprites sprites(
		.clk(clk),
		.ce(ce),
		.ce_cpu(ce_cpu),
		.size16(lcdc_spr_siz),
		.isGBC(isGBC),
		.sprite_en(lcdc_spr_ena),
		.lcd_on(lcd_on),
		.v_cnt(v_cnt),
		.h_cnt(pcnt),
		.oam_eval(oam_eval),
		.oam_fetch(mode3),
		.oam_eval_reset(pcnt_reset),
		.oam_eval_end(oam_eval_end),
		.sprite_fetch(sprite_found),
		.sprite_addr(sprite_addr),
		.sprite_attr(sprite_attr),
		.sprite_index(sprite_index),
		.sprite_fetch_c1(sprite_fetch_cycle == 3'd1),
		.sprite_fetch_done(sprite_fetch_done),
		.dma_active(dma_active),
		.oam_wr(oam_wr),
		.oam_addr_in(oam_addr),
		.oam_di(oam_di),
		.oam_do(oam_do),
		.extra_spr_en(extra_spr_en),
		.extra_wait(extra_wait),
		.tile_data_in(spr_tile_data_in),
		.extra_tile_fetch(tile_obj_extra_rd),
		.extra_tile_addr(sprite_extra_addr),
		.spr_extra_found(spr_extra_found),
		.spr_extra_tile0(spr_extra_tile0_w),
		.spr_extra_tile1(spr_extra_tile1_w),
		.spr_extra_pal(spr_extra_pal),
		.spr_extra_prio(spr_extra_prio),
		.spr_extra_cgb_pal(spr_extra_cgb_pal),
		.spr_extra_index(spr_extra_index),
		.Savestate_OAMRAMAddr(Savestate_OAMRAMAddr),
		.Savestate_OAMRAMRWrEn(Savestate_OAMRAMRWrEn),
		.Savestate_OAMRAMWriteData(Savestate_OAMRAMWriteData),
		.Savestate_OAMRAMReadData(Savestate_OAMRAMReadData)
	);
	wire bg_piority = (isGBC && isGBC_mode) && bg_tile_attr[7];
	reg sprite_pixel_visible;
	wire [1:0] sprite_pixel_data = {spr_tile_shift_1[7], spr_tile_shift_0[7]};
	wire sprite_pixel_prio = spr_prio_shift[7];
	wire [1:0] bg_pix_data = {tile_shift_1[7], tile_shift_0[7]};
	always @(*) begin
		sprite_pixel_visible = 1'b0;
		if (|sprite_pixel_data && lcdc_spr_ena) begin
			if (isGBC && isGBC_mode) begin
				if (sprite_pixel_data == 2'b00)
					sprite_pixel_visible = 1'b0;
				else if (bg_pix_data == 2'b00)
					sprite_pixel_visible = 1'b1;
				else if (!lcdc_bg_prio)
					sprite_pixel_visible = 1'b1;
				else if (bg_piority)
					sprite_pixel_visible = 1'b0;
				else if (!sprite_pixel_prio)
					sprite_pixel_visible = 1'b1;
			end
			else if (sprite_pixel_data == 2'b00)
				sprite_pixel_visible = 1'b0;
			else if (bg_pix_data == 2'b00)
				sprite_pixel_visible = 1'b1;
			else if (!sprite_pixel_prio)
				sprite_pixel_visible = 1'b1;
		end
	end
	wire [1:0] bgp_data = (!lcdc_bg_ena || (bg_pix_data == 2'b00) ? bgp[1:0] : (bg_pix_data == 2'b01 ? bgp[3:2] : (bg_pix_data == 2'b10 ? bgp[5:4] : bgp[7:6])));
	wire sprite_pixel_cmap = spr_pal_shift[7];
	wire [7:0] obp = (sprite_pixel_cmap ? obp1 : obp0);
	wire [1:0] obp_data = (sprite_pixel_data == 2'b00 ? obp[1:0] : (sprite_pixel_data == 2'b01 ? obp[3:2] : (sprite_pixel_data == 2'b10 ? obp[5:4] : obp[7:6])));
	wire [5:0] palette_index = (isGBC_mode ? {bg_tile_attr[2:0], bg_pix_data, 1'b0} : {3'd0, bgp_data, 1'b0});
	wire [14:0] pix_rgb_data = (isGBC ? {bgpd[palette_index + 1][6:0], bgpd[palette_index]} : {13'd0, bgp_data});
	wire [2:0] spr_cgb_pal_out = {spr_cgb_pal_shift[2][7], spr_cgb_pal_shift[1][7], spr_cgb_pal_shift[0][7]};
	wire [5:0] sprite_palette_index = (isGBC_mode ? {spr_cgb_pal_out, sprite_pixel_data, 1'b0} : {sprite_pixel_cmap, obp_data, 1'b0});
	wire [14:0] sprite_pix = (isGBC ? {obpd[sprite_palette_index + 1][6:0], obpd[sprite_palette_index]} : {13'd0, obp_data});
	wire lcd_clk = (~pcnt_paused & (pcnt >= 8)) | (~mode3_end_l & mode3_end);
	reg [14:0] lcd_data_out;
	reg [1:0] lcd_data_gb_out;
	reg lcd_clk_out;
	always @(posedge clk)
		if (ce) begin
			lcd_clk_out <= lcd_clk;
			if (lcd_clk) begin
				lcd_data_out <= (sprite_pixel_visible ? sprite_pix : pix_rgb_data);
				lcd_data_gb_out <= (sprite_pixel_visible ? obp_data : bgp_data);
			end
			if (~lcd_on)
				lcd_data_out <= (isGBC ? 15'h7fff : 15'd0);
		end
	assign lcd_data = lcd_data_out;
	assign lcd_data_gb = lcd_data_gb_out;
	assign lcd_clkena = lcd_clk_out;
endmodule
module sprites (
	clk,
	ce,
	ce_cpu,
	size16,
	isGBC,
	sprite_en,
	lcd_on,
	v_cnt,
	h_cnt,
	sprite_fetch_c1,
	sprite_fetch_done,
	sprite_fetch,
	oam_fetch,
	oam_eval_reset,
	oam_eval,
	sprite_addr,
	sprite_attr,
	sprite_index,
	oam_eval_end,
	dma_active,
	oam_wr,
	oam_addr_in,
	oam_di,
	oam_do,
	extra_spr_en,
	extra_wait,
	extra_tile_fetch,
	extra_tile_addr,
	tile_data_in,
	spr_extra_found,
	spr_extra_tile0,
	spr_extra_tile1,
	spr_extra_cgb_pal,
	spr_extra_index,
	spr_extra_pal,
	spr_extra_prio,
	Savestate_OAMRAMAddr,
	Savestate_OAMRAMRWrEn,
	Savestate_OAMRAMWriteData,
	Savestate_OAMRAMReadData
);
	input clk;
	input ce;
	input ce_cpu;
	input size16;
	input isGBC;
	input sprite_en;
	input lcd_on;
	input [7:0] v_cnt;
	input [7:0] h_cnt;
	input sprite_fetch_c1;
	input sprite_fetch_done;
	output wire sprite_fetch;
	input oam_fetch;
	input oam_eval_reset;
	output wire oam_eval;
	output wire [10:0] sprite_addr;
	output wire [7:0] sprite_attr;
	output wire [3:0] sprite_index;
	output wire oam_eval_end;
	input dma_active;
	input oam_wr;
	input [7:0] oam_addr_in;
	input [7:0] oam_di;
	output wire [7:0] oam_do;
	input extra_spr_en;
	input extra_wait;
	output wire extra_tile_fetch;
	output wire [11:0] extra_tile_addr;
	input [7:0] tile_data_in;
	output wire spr_extra_found;
	output wire [7:0] spr_extra_tile0;
	output wire [7:0] spr_extra_tile1;
	output wire [2:0] spr_extra_cgb_pal;
	output wire [3:0] spr_extra_index;
	output wire spr_extra_pal;
	output wire spr_extra_prio;
	input [7:0] Savestate_OAMRAMAddr;
	input Savestate_OAMRAMRWrEn;
	input [7:0] Savestate_OAMRAMWriteData;
	output wire [7:0] Savestate_OAMRAMReadData;
	localparam SPRITES_PER_LINE = 10;
	wire [7:2] oam_eval_addr;
	wire [7:2] oam_fetch_addr;
	wire [7:0] oam_l_q;
	wire [7:0] oam_h_q;
	reg oam_eval_en;
	assign oam_eval = ((lcd_on & ~oam_eval_end) & oam_eval_en) & ~oam_eval_reset;
	wire [3:0] fetch_row;
	wire oam_eval_extra;
	wire [7:1] oam_extra_addr;
	wire [7:0] spr_extra_fetch_attr;
	wire [7:1] oam_addr = (dma_active ? oam_addr_in[7:1] : (oam_eval_extra ? {oam_extra_addr} : (oam_eval ? {oam_eval_addr, 1'b0} : (oam_fetch ? {oam_fetch_addr, 1'b1} : oam_addr_in[7:1]))));
	wire valid_oam_addr = oam_addr[7:4] < 4'ha;
	assign oam_do = (~valid_oam_addr ? 8'd0 : (oam_addr_in[0] ? oam_h_q : oam_l_q));
	wire [7:0] Savestate_OAMRAMReadDataL;
	wire [7:0] Savestate_OAMRAMReadDataH;
	dpram #(
		.addr_width(7),
		.data_width(8)
	) oam_data_l(
		.clock_a(clk),
		.clken_a(1'b1),
		.address_a(oam_addr[7:1]),
		.wren_a(((ce_cpu && oam_wr) && valid_oam_addr) && ~oam_addr_in[0]),
		.data_a(oam_di),
		.q_a(oam_l_q),
		.clock_b(clk),
		.address_b(Savestate_OAMRAMAddr[7:1]),
		.wren_b(Savestate_OAMRAMRWrEn & ~Savestate_OAMRAMAddr[0]),
		.data_b(Savestate_OAMRAMWriteData),
		.q_b(Savestate_OAMRAMReadDataL)
	);
	dpram #(
		.addr_width(7),
		.data_width(8)
	) oam_data_h(
		.clock_a(clk),
		.clken_a(1'b1),
		.address_a(oam_addr[7:1]),
		.wren_a(((ce_cpu && oam_wr) && valid_oam_addr) && oam_addr_in[0]),
		.data_a(oam_di),
		.q_a(oam_h_q),
		.clock_b(clk),
		.address_b(Savestate_OAMRAMAddr[7:1]),
		.wren_b(Savestate_OAMRAMRWrEn & Savestate_OAMRAMAddr[0]),
		.data_b(Savestate_OAMRAMWriteData),
		.q_b(Savestate_OAMRAMReadDataH)
	);
	reg Savestate_OAMRAMAddr0_d;
	always @(posedge clk) Savestate_OAMRAMAddr0_d <= Savestate_OAMRAMAddr[0];
	assign Savestate_OAMRAMReadData = (Savestate_OAMRAMAddr0_d ? Savestate_OAMRAMReadDataH : Savestate_OAMRAMReadDataL);
	reg [7:0] sprite_x [0:9];
	reg [3:0] sprite_y [0:9];
	reg [5:0] sprite_no [0:9];
	reg [5:0] spr_index;
	reg [5:0] spr_index_d;
	reg [3:0] sprite_cnt;
	reg oam_eval_clk;
	reg oam_eval_clk_d;
	reg oam_eval_save;
	reg [7:0] sprite_x_attr;
	reg [7:0] tile_index_y;
	wire [7:0] spr_height = (size16 ? 8'd16 : 8'd8);
	wire sprite_on_line = ((v_cnt + 8'd16) >= tile_index_y) && ((v_cnt + 8'd16) < (tile_index_y + spr_height));
	wire sprite_save = (oam_eval_clk_d & oam_eval_en) & sprite_on_line;
	assign oam_eval_end = spr_index == 6'd40;
	wire [0:9] sprite_x_matches;
	reg old_fetch_done;
	integer spr_i = 0;
	always @(posedge clk)
		if (ce) begin
			if (oam_eval_reset | ~lcd_on) begin
				sprite_cnt <= 0;
				spr_index <= (~lcd_on ? 6'd1 : 6'd0);
				oam_eval_clk <= 0;
				oam_eval_clk_d <= 0;
				oam_eval_en <= (oam_eval_reset ? 1'b1 : 1'b0);
				for (spr_i = 0; spr_i < SPRITES_PER_LINE; spr_i = spr_i + 1)
					begin
						sprite_x[spr_i] <= 8'hff;
						sprite_no[spr_i] <= 6'd0;
					end
			end
			else begin
				if (~oam_eval_end) begin
					if (oam_eval_clk) begin
						spr_index <= spr_index + 1'b1;
						spr_index_d <= spr_index;
					end
					oam_eval_clk <= ~oam_eval_clk;
				end
				oam_eval_clk_d <= oam_eval_clk;
				if (sprite_save & (sprite_cnt < SPRITES_PER_LINE)) begin
					sprite_no[sprite_cnt] <= spr_index_d;
					sprite_x[sprite_cnt] <= sprite_x_attr;
					sprite_y[sprite_cnt] <= v_cnt[3:0] - tile_index_y[3:0];
					sprite_cnt <= sprite_cnt + 1'b1;
				end
				old_fetch_done <= sprite_fetch_done;
				if (~old_fetch_done & sprite_fetch_done) begin
					if (sprite_x_matches[0])
						sprite_x[0] <= 8'hff;
					else if (sprite_x_matches[1])
						sprite_x[1] <= 8'hff;
					else if (sprite_x_matches[2])
						sprite_x[2] <= 8'hff;
					else if (sprite_x_matches[3])
						sprite_x[3] <= 8'hff;
					else if (sprite_x_matches[4])
						sprite_x[4] <= 8'hff;
					else if (sprite_x_matches[5])
						sprite_x[5] <= 8'hff;
					else if (sprite_x_matches[6])
						sprite_x[6] <= 8'hff;
					else if (sprite_x_matches[7])
						sprite_x[7] <= 8'hff;
					else if (sprite_x_matches[8])
						sprite_x[8] <= 8'hff;
					else if (sprite_x_matches[9])
						sprite_x[9] <= 8'hff;
				end
			end
		end
	assign oam_eval_addr = spr_index;
	wire eval_save_xy = ((~oam_eval_end & oam_eval_en) & oam_eval_clk) & ~dma_active;
	wire fetch_save_index_attr = sprite_fetch & sprite_fetch_c1;
	always @(posedge clk)
		if (ce) begin
			if (eval_save_xy | fetch_save_index_attr) begin
				tile_index_y <= oam_l_q;
				sprite_x_attr <= oam_h_q;
			end
		end
	assign sprite_x_matches = {sprite_x[0] == h_cnt, sprite_x[1] == h_cnt, sprite_x[2] == h_cnt, sprite_x[3] == h_cnt, sprite_x[4] == h_cnt, sprite_x[5] == h_cnt, sprite_x[6] == h_cnt, sprite_x[7] == h_cnt, sprite_x[8] == h_cnt, sprite_x[9] == h_cnt};
	assign sprite_fetch = (|sprite_x_matches & oam_fetch) & (isGBC | sprite_en);
	wire [3:0] active_sprite = (sprite_x_matches[0] ? 4'd0 : (sprite_x_matches[1] ? 4'd1 : (sprite_x_matches[2] ? 4'd2 : (sprite_x_matches[3] ? 4'd3 : (sprite_x_matches[4] ? 4'd4 : (sprite_x_matches[5] ? 4'd5 : (sprite_x_matches[6] ? 4'd6 : (sprite_x_matches[7] ? 4'd7 : (sprite_x_matches[8] ? 4'd8 : 4'd9)))))))));
	assign sprite_index = active_sprite;
	assign sprite_attr = (oam_eval_extra ? spr_extra_fetch_attr : sprite_x_attr);
	assign oam_fetch_addr = sprite_no[active_sprite];
	assign fetch_row = (sprite_attr[6] ? ~sprite_y[active_sprite] : sprite_y[active_sprite]);
	assign sprite_addr = (size16 ? {tile_index_y[7:1], fetch_row} : {tile_index_y, fetch_row[2:0]});
	sprites_extra sprites_extra(
		.clk(clk),
		.ce(ce),
		.extra_spr_en(extra_spr_en),
		.v_cnt(v_cnt),
		.h_cnt(h_cnt),
		.oam_eval_clk(oam_eval_clk),
		.oam_eval_reset(oam_eval_reset | ~lcd_on),
		.oam_eval_end(oam_eval_end),
		.size16(size16),
		.oam_index(spr_index),
		.sprite_cnt(sprite_cnt),
		.oam_l_q(oam_l_q),
		.oam_h_q(oam_h_q),
		.extra_wait(extra_wait),
		.oam_eval_extra(oam_eval_extra),
		.oam_extra_addr(oam_extra_addr),
		.spr_fetch_attr(spr_extra_fetch_attr),
		.tile_fetch(extra_tile_fetch),
		.tile_data_in(tile_data_in),
		.tile_addr(extra_tile_addr),
		.spr_found(spr_extra_found),
		.spr_tile0(spr_extra_tile0),
		.spr_tile1(spr_extra_tile1),
		.spr_pal(spr_extra_pal),
		.spr_prio(spr_extra_prio),
		.spr_cgb_pal(spr_extra_cgb_pal),
		.spr_index(spr_extra_index)
	);
endmodule
module sprites_extra (
	clk,
	ce,
	extra_spr_en,
	oam_eval_end,
	oam_eval_clk,
	oam_eval_reset,
	size16,
	oam_index,
	sprite_cnt,
	oam_l_q,
	oam_h_q,
	v_cnt,
	h_cnt,
	extra_wait,
	oam_eval_extra,
	oam_extra_addr,
	spr_fetch_attr,
	tile_fetch,
	tile_addr,
	tile_data_in,
	spr_found,
	spr_tile0,
	spr_tile1,
	spr_cgb_pal,
	spr_index,
	spr_pal,
	spr_prio
);
	input clk;
	input ce;
	input extra_spr_en;
	input oam_eval_end;
	input oam_eval_clk;
	input oam_eval_reset;
	input size16;
	input [5:0] oam_index;
	input [3:0] sprite_cnt;
	input [7:0] oam_l_q;
	input [7:0] oam_h_q;
	input [7:0] v_cnt;
	input [7:0] h_cnt;
	input extra_wait;
	output wire oam_eval_extra;
	output wire [7:1] oam_extra_addr;
	output wire [7:0] spr_fetch_attr;
	output wire tile_fetch;
	output wire [11:0] tile_addr;
	input [7:0] tile_data_in;
	output wire spr_found;
	output wire [7:0] spr_tile0;
	output wire [7:0] spr_tile1;
	output wire [2:0] spr_cgb_pal;
	output wire [3:0] spr_index;
	output wire spr_pal;
	output wire spr_prio;
	localparam SPRITES_PER_LINE = 10;
	localparam SPRITES_EXTRA = 6;
	wire [5:0] sprite_x_matches;
	reg [7:0] sprite_x;
	reg [3:0] sprite_y;
	reg [5:0] extra_oam_index;
	reg [3:0] new_sprite_x_index;
	reg [4:0] extra_sprite_index;
	reg oam_attr_fetch;
	reg [7:0] tile_index;
	reg [7:0] tile_y;
	reg [3:0] tile_row;
	reg [7:0] tile_attr;
	reg extra_waiting;
	wire extra_pause = extra_wait | extra_waiting;
	wire oam_extra_start = extra_spr_en & (sprite_cnt == SPRITES_PER_LINE);
	assign oam_eval_extra = (oam_extra_start & ~oam_eval_end) & ~extra_pause;
	assign oam_extra_addr = {extra_oam_index, oam_attr_fetch};
	assign spr_fetch_attr = tile_attr;
	wire [7:0] spr_height = (size16 ? 8'd16 : 8'd8);
	wire sprite_on_line = ((v_cnt + 8'd16) >= oam_l_q) && ((v_cnt + 8'd16) < (oam_l_q + spr_height));
	reg tile_fetching;
	reg [3:0] tile_fetch_x_index;
	reg [3:0] tile_fetch_sprite_index;
	reg [1:0] tile_fetch_cnt;
	reg tile1_fetch;
	wire tile_save;
	reg save_x;
	always @(posedge clk)
		if (ce) begin
			if (~oam_extra_start)
				extra_waiting <= 0;
			else if (oam_eval_clk)
				extra_waiting <= extra_wait;
		end
	always @(posedge clk)
		if (ce) begin
			save_x <= 0;
			if (~oam_extra_start) begin
				extra_oam_index <= oam_index;
				oam_attr_fetch <= 0;
				new_sprite_x_index <= 0;
				extra_sprite_index <= SPRITES_PER_LINE[4:0];
			end
			else if (oam_eval_clk & ~extra_pause) begin
				if (~oam_attr_fetch) begin
					if (sprite_on_line) begin
						sprite_x <= oam_h_q;
						sprite_y <= v_cnt[3:0] - oam_l_q[3:0];
						oam_attr_fetch <= 1;
					end
					else
						extra_oam_index <= extra_oam_index + 1'b1;
				end
				else begin
					extra_oam_index <= extra_oam_index + 1'b1;
					oam_attr_fetch <= 0;
					tile_index <= oam_l_q;
					tile_attr <= oam_h_q;
					tile_row <= (oam_h_q[6] ? ~sprite_y : sprite_y);
					tile_fetch_sprite_index <= extra_sprite_index[3:0];
					if (extra_sprite_index != 16) begin
						if (~spr_found) begin
							tile_fetch_x_index <= new_sprite_x_index;
							save_x <= 1;
							new_sprite_x_index <= new_sprite_x_index + 1'b1;
						end
						extra_sprite_index <= extra_sprite_index + 1'b1;
					end
				end
			end
		end
	assign tile_addr[11:5] = tile_index[7:1];
	assign tile_addr[4:1] = (size16 ? tile_row : {tile_index[0], tile_row[2:0]});
	assign tile_addr[0] = tile1_fetch;
	assign tile_fetch = (save_x | tile_fetching) & ~extra_pause;
	assign tile_save = (tile_fetch & oam_eval_clk) & tile1_fetch;
	reg [7:0] tile_data_0;
	always @(posedge clk)
		if (ce) begin
			if (oam_eval_reset | oam_eval_end) begin
				tile_fetching <= 0;
				tile1_fetch <= 0;
			end
			else begin
				if (save_x)
					tile_fetching <= 1;
				if (tile_fetch & oam_eval_clk) begin
					if (~tile1_fetch)
						tile_data_0 <= tile_data_in;
					else
						tile_fetching <= 0;
					tile1_fetch <= ~tile1_fetch;
				end
			end
		end
	wire [7:0] sprite_x_sel = (oam_eval_extra ? sprite_x : h_cnt);
	genvar _gv_j_1;
	wire [7:0] st_tile0 [0:5];
	wire [7:0] st_tile1 [0:5];
	wire [2:0] st_cgb_pal [0:5];
	wire [3:0] st_index [0:5];
	wire [5:0] st_pal;
	wire [5:0] st_prio;
	generate
		for (_gv_j_1 = 0; _gv_j_1 < SPRITES_EXTRA; _gv_j_1 = _gv_j_1 + 1) begin : gen_sprite_extra_store
			localparam j = _gv_j_1;
			sprites_extra_store st(
				.clk(clk),
				.ce(ce),
				.reset(oam_eval_reset),
				.save_x(save_x & (tile_fetch_x_index == j)),
				.xpos(sprite_x_sel),
				.tile_save(tile_save & (tile_fetch_x_index == j)),
				.tile0_in(tile_data_0),
				.tile1_in(tile_data_in),
				.index_in(tile_fetch_sprite_index),
				.cgb_pal_in(tile_attr[2:0]),
				.pal_in(tile_attr[4]),
				.prio_in(tile_attr[7]),
				.x_match(sprite_x_matches[j]),
				.tile0_o(st_tile0[j]),
				.tile1_o(st_tile1[j]),
				.pal_o(st_pal[j]),
				.prio_o(st_prio[j]),
				.cgb_pal_o(st_cgb_pal[j]),
				.index_o(st_index[j])
			);
		end
	endgenerate
	reg [7:0] or_tile0;
	reg [7:0] or_tile1;
	reg [2:0] or_cgb_pal;
	reg [3:0] or_index;
	integer k;
	always @(*) begin
		or_tile0 = 8'd0;
		or_tile1 = 8'd0;
		or_cgb_pal = 3'd0;
		or_index = 4'd0;
		for (k = 0; k < SPRITES_EXTRA; k = k + 1)
			begin
				or_tile0 = or_tile0 | st_tile0[k];
				or_tile1 = or_tile1 | st_tile1[k];
				or_cgb_pal = or_cgb_pal | st_cgb_pal[k];
				or_index = or_index | st_index[k];
			end
	end
	assign spr_tile0 = or_tile0;
	assign spr_tile1 = or_tile1;
	assign spr_cgb_pal = or_cgb_pal;
	assign spr_index = or_index;
	assign spr_pal = |st_pal;
	assign spr_prio = |st_prio;
	assign spr_found = |{sprite_x_matches} & extra_spr_en;
endmodule
module sprites_extra_store (
	clk,
	ce,
	reset,
	save_x,
	xpos,
	tile_save,
	tile0_in,
	tile1_in,
	index_in,
	cgb_pal_in,
	pal_in,
	prio_in,
	x_match,
	tile0_o,
	tile1_o,
	cgb_pal_o,
	index_o,
	pal_o,
	prio_o
);
	input clk;
	input ce;
	input reset;
	input save_x;
	input [7:0] xpos;
	input tile_save;
	input [7:0] tile0_in;
	input [7:0] tile1_in;
	input [3:0] index_in;
	input [2:0] cgb_pal_in;
	input pal_in;
	input prio_in;
	output wire x_match;
	output wire [7:0] tile0_o;
	output wire [7:0] tile1_o;
	output wire [2:0] cgb_pal_o;
	output wire [3:0] index_o;
	output wire pal_o;
	output wire prio_o;
	reg [7:0] x;
	reg [7:0] tile0;
	reg [7:0] tile1;
	reg [2:0] cgb_pal;
	reg [3:0] index;
	reg pal;
	reg prio;
	always @(posedge clk)
		if (ce) begin
			if (reset) begin
				x <= 8'hff;
				tile0 <= 8'd0;
				tile1 <= 8'd0;
			end
			else begin
				if (save_x)
					x <= xpos;
				if (tile_save) begin
					tile0 <= tile0_in;
					tile1 <= tile1_in;
					pal <= pal_in;
					prio <= prio_in;
					cgb_pal <= cgb_pal_in;
					index <= index_in;
				end
			end
		end
	assign x_match = xpos == x;
	assign tile0_o = (x_match ? tile0 : 8'h00);
	assign tile1_o = (x_match ? tile1 : 8'h00);
	assign pal_o = (x_match ? pal : 1'b0);
	assign prio_o = (x_match ? prio : 1'b0);
	assign cgb_pal_o = (x_match ? cgb_pal : 3'h0);
	assign index_o = (x_match ? index : 4'h0);
endmodule
module timer (
	reset,
	clk_sys,
	ce,
	ce_4MHz,
	cpu_speed,
	irq,
	cpu_sel,
	cpu_addr,
	cpu_wr,
	cpu_di,
	cpu_do,
	apu_framecount_en,
	SaveStateBus_Din,
	SaveStateBus_Adr,
	SaveStateBus_wren,
	SaveStateBus_rst,
	SaveStateBus_Dout
);
	input reset;
	input clk_sys;
	input ce;
	input ce_4MHz;
	input cpu_speed;
	output wire irq;
	input cpu_sel;
	input [1:0] cpu_addr;
	input cpu_wr;
	input [7:0] cpu_di;
	output wire [7:0] cpu_do;
	output wire apu_framecount_en;
	input [63:0] SaveStateBus_Din;
	input [9:0] SaveStateBus_Adr;
	input SaveStateBus_wren;
	input SaveStateBus_rst;
	output wire [63:0] SaveStateBus_Dout;
	reg [15:0] clk_div;
	wire [7:0] div = clk_div[15:8];
	reg [2:0] tac;
	reg [7:0] tima;
	reg [7:0] tma;
	assign cpu_do = (cpu_addr == 2'b00 ? div : (cpu_addr == 2'b01 ? tima : (cpu_addr == 2'b10 ? tma : {5'b11111, tac})));
	wire clk_sound = (cpu_speed ? div[5] : div[4]);
	reg clk_sound_r;
	assign apu_framecount_en = clk_sound_r && !clk_sound;
	always @(posedge clk_sys) begin : CLK_SOUND_BLK
		if (reset)
			clk_sound_r <= 1'b0;
		else if (ce_4MHz)
			clk_sound_r <= clk_sound;
	end
	wire [46:0] SS_Timer;
	wire [46:0] SS_Timer_BACK;
	eReg_SavestateV #(
		.index(0),
		.Adr(6),
		.upper(46),
		.lower(0),
		.def(64'h0000000000000008)
	) iREG_SAVESTATE_Timer(
		.clk(clk_sys),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_Dout),
		.Din(SS_Timer_BACK),
		.Dout(SS_Timer)
	);
	assign {SS_Timer_BACK[37:30], SS_Timer_BACK[7:0]} = clk_div;
	assign SS_Timer_BACK[17:10] = tima;
	assign SS_Timer_BACK[25:18] = tma;
	assign SS_Timer_BACK[28:26] = tac;
	reg clk_tac_r;
	assign SS_Timer_BACK[38] = clk_tac_r;
	reg [4:0] tima_overflow_buffer;
	assign SS_Timer_BACK[46:42] = tima_overflow_buffer;
	always @(posedge clk_sys) begin : CLK_DIV_BLK
		if (reset)
			clk_div <= {SS_Timer[37:30], SS_Timer[7:0]};
		else if ((cpu_sel && cpu_wr) && (cpu_addr == 2'b00))
			clk_div <= 16'd2;
		else if (ce)
			clk_div <= clk_div + 16'd1;
	end
	always @(posedge clk_sys) begin : TMA_BLK
		if (reset)
			tma <= SS_Timer[25:18];
		else if (ce) begin
			if ((cpu_sel && cpu_wr) && (cpu_addr == 2'b10))
				tma <= cpu_di;
		end
	end
	wire clk_tac = tac[2] && (tac[1:0] == 2'b00 ? clk_div[9] : (tac[1:0] == 2'b01 ? clk_div[3] : (tac[1:0] == 2'b10 ? clk_div[5] : clk_div[7])));
	always @(posedge clk_sys) begin : TAC_BLK
		if (reset) begin
			tac <= SS_Timer[28:26];
			clk_tac_r <= SS_Timer[38];
		end
		else if (ce) begin
			clk_tac_r <= clk_tac;
			if ((cpu_sel && cpu_wr) && (cpu_addr == 2'b11))
				tac <= cpu_di[2:0];
		end
	end
	assign irq = tima_overflow_buffer[4];
	always @(posedge clk_sys) begin : TIMA_BLK
		if (reset) begin
			tima <= SS_Timer[17:10];
			tima_overflow_buffer <= SS_Timer[46:42];
		end
		else if (ce) begin
			tima_overflow_buffer <= {tima_overflow_buffer[3:0], 1'b0};
			if (clk_tac_r && !clk_tac)
				{tima_overflow_buffer[0], tima} <= tima + 1'b1;
			if (irq) begin
				tima <= tma;
				if ((cpu_sel && cpu_wr) && (cpu_addr == 2'b10))
					tima <= cpu_di;
			end
			if ((cpu_sel && cpu_wr) && (cpu_addr == 2'b01)) begin
				tima_overflow_buffer[4:1] <= 4'b0000;
				if (!irq)
					tima <= cpu_di;
			end
		end
	end
endmodule
module hdma (
	reset,
	clk,
	ce,
	speed,
	sel_reg,
	addr,
	wr,
	dout,
	din,
	cpu_phi_r_ce,
	cpu_phi_f_ce,
	hdma_phi_r_ce,
	hdma_phi_f_ce,
	lcd_mode,
	hdma_rd,
	hdma_source_addr,
	hdma_target_addr,
	SaveStateBus_Din,
	SaveStateBus_Adr,
	SaveStateBus_wren,
	SaveStateBus_rst,
	SaveStateBus_Dout
);
	input reset;
	input clk;
	input ce;
	input speed;
	input sel_reg;
	input [3:0] addr;
	input wr;
	output wire [7:0] dout;
	input [7:0] din;
	input cpu_phi_r_ce;
	input cpu_phi_f_ce;
	input hdma_phi_r_ce;
	input hdma_phi_f_ce;
	input [1:0] lcd_mode;
	output wire hdma_rd;
	output wire [15:0] hdma_source_addr;
	output wire [15:0] hdma_target_addr;
	input [63:0] SaveStateBus_Din;
	input [9:0] SaveStateBus_Adr;
	input SaveStateBus_wren;
	input SaveStateBus_rst;
	output wire [63:0] SaveStateBus_Dout;
	wire [47:0] SS_HDMA;
	wire [47:0] SS_HDMA_BACK;
	eReg_SavestateV #(
		.index(0),
		.Adr(7),
		.upper(47),
		.lower(0),
		.def(64'h000000000ffffff0)
	) iREG_SAVESTATE_HDMA(
		.clk(clk),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_Dout),
		.Din(SS_HDMA_BACK),
		.Dout(SS_HDMA)
	);
	reg [15:4] hdma_source;
	reg [15:4] hdma_target;
	reg hdma_mode;
	reg hdma_enabled;
	reg [7:0] hdma_length;
	reg hdma_active;
	reg hdma_run;
	reg hdma_trigger;
	reg hdma_init;
	reg [3:0] byte_cnt;
	assign hdma_rd = hdma_active;
	assign hdma_source_addr = {hdma_source, byte_cnt};
	assign hdma_target_addr = {hdma_target, byte_cnt};
	reg [1:0] hdma_state;
	parameter active = 2'd0;
	parameter blocksent = 2'd1;
	parameter wait_h = 2'd2;
	assign SS_HDMA_BACK[0] = hdma_active;
	assign SS_HDMA_BACK[2:1] = hdma_state;
	assign SS_HDMA_BACK[3] = hdma_enabled;
	assign SS_HDMA_BACK[15:4] = hdma_source;
	assign SS_HDMA_BACK[27:16] = hdma_target;
	assign SS_HDMA_BACK[28] = hdma_run;
	assign SS_HDMA_BACK[29] = 1'b0;
	assign SS_HDMA_BACK[30] = hdma_mode;
	assign SS_HDMA_BACK[38:31] = hdma_length;
	assign SS_HDMA_BACK[42:39] = byte_cnt;
	assign SS_HDMA_BACK[44:43] = 2'd0;
	assign SS_HDMA_BACK[45] = hdma_trigger;
	assign SS_HDMA_BACK[46] = hdma_init;
	assign SS_HDMA_BACK[47] = 1'b0;
	always @(posedge clk)
		if (reset) begin
			hdma_active <= SS_HDMA[0];
			hdma_state <= SS_HDMA[2:1];
			hdma_enabled <= SS_HDMA[3];
			hdma_source <= SS_HDMA[15:4];
			hdma_target <= SS_HDMA[27:16];
			hdma_run <= SS_HDMA[28];
			hdma_mode <= SS_HDMA[30];
			hdma_length <= SS_HDMA[38:31];
			byte_cnt <= SS_HDMA[42:39];
			hdma_trigger <= SS_HDMA[45];
			hdma_init <= SS_HDMA[46];
		end
		else begin
			if ((ce & sel_reg) & wr)
				case (addr)
					4'd1: hdma_source[15:8] <= din;
					4'd2: hdma_source[7:4] <= din[7:4];
					4'd3: hdma_target[15:8] <= din;
					4'd4: hdma_target[7:4] <= din[7:4];
					4'h5: begin
						hdma_length <= {1'b0, din[6:0]};
						if (((hdma_mode == 1) && hdma_enabled) && !din[7]) begin
							hdma_enabled <= 1'b0;
							hdma_trigger <= 1'b0;
						end
						else begin
							hdma_enabled <= 1'b1;
							hdma_mode <= din[7];
							if (din[7] == 1)
								hdma_state <= wait_h;
							else
								hdma_trigger <= 1'b1;
						end
					end
				endcase
			if (cpu_phi_r_ce) begin
				hdma_init <= hdma_trigger;
				hdma_active <= hdma_run;
			end
			if (cpu_phi_f_ce) begin
				if (hdma_init) begin
					hdma_trigger <= 1'b0;
					hdma_run <= 1'b1;
					byte_cnt <= 4'd0;
				end
			end
			if (hdma_phi_r_ce) begin
				if (hdma_active) begin
					byte_cnt <= byte_cnt + 1'b1;
					if (&byte_cnt) begin
						hdma_source <= hdma_source + 1'b1;
						hdma_target <= hdma_target + 1'b1;
						hdma_length <= hdma_length - 1'd1;
					end
				end
			end
			if (hdma_phi_f_ce) begin
				if (hdma_active) begin
					if (&byte_cnt) begin
						if ((hdma_length == 0) || &hdma_target) begin
							hdma_run <= 1'b0;
							hdma_enabled <= 1'b0;
						end
						if (hdma_mode) begin
							hdma_state <= blocksent;
							hdma_run <= 1'b0;
						end
					end
				end
			end
			if (ce) begin
				if (hdma_mode)
					case (hdma_state)
						wait_h:
							if ((lcd_mode == 2'b00) && hdma_enabled) begin
								hdma_state <= active;
								hdma_trigger <= 1'b1;
							end
						blocksent:
							if (lcd_mode != 2'b00)
								hdma_state <= wait_h;
					endcase
			end
		end
	assign dout = (sel_reg && (addr == 4'd5) ? {~hdma_enabled, hdma_length[6:0]} : 8'hff);
endmodule
module link (
	clk_sys,
	ce,
	rst,
	sel_sc,
	sel_sb,
	cpu_wr_n,
	sc_start_in,
	sc_int_clock_in,
	sb_in,
	serial_clk_in,
	serial_data_in,
	serial_clk_out,
	serial_data_out,
	sb,
	serial_irq,
	sc_start,
	sc_int_clock,
	SaveStateBus_Din,
	SaveStateBus_Adr,
	SaveStateBus_wren,
	SaveStateBus_rst,
	SaveStateBus_Dout
);
	parameter CLK_DIV = 511;
	input clk_sys;
	input ce;
	input rst;
	input sel_sc;
	input sel_sb;
	input cpu_wr_n;
	input sc_start_in;
	input sc_int_clock_in;
	input [7:0] sb_in;
	input serial_clk_in;
	input serial_data_in;
	output wire serial_clk_out;
	output wire serial_data_out;
	output wire [7:0] sb;
	output wire serial_irq;
	output reg sc_start;
	output reg sc_int_clock;
	input [63:0] SaveStateBus_Din;
	input [9:0] SaveStateBus_Adr;
	input SaveStateBus_wren;
	input SaveStateBus_rst;
	output wire [63:0] SaveStateBus_Dout;
	wire [16:0] SS_Link;
	wire [16:0] SS_Link_BACK;
	eReg_SavestateV #(
		.index(0),
		.Adr(8),
		.upper(16),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_HDMA(
		.clk(clk_sys),
		.BUS_Din(SaveStateBus_Din),
		.BUS_Adr(SaveStateBus_Adr),
		.BUS_wren(SaveStateBus_wren),
		.BUS_rst(SaveStateBus_rst),
		.BUS_Dout(SaveStateBus_Dout),
		.Din(SS_Link_BACK),
		.Dout(SS_Link)
	);
	reg [7:0] sb_r = 0;
	assign sb = sb_r;
	reg [3:0] serial_counter;
	reg serial_out_r = 0;
	assign serial_data_out = serial_out_r;
	reg serial_clk_out_r = 1;
	assign serial_clk_out = serial_clk_out_r;
	reg serial_irq_r;
	assign serial_irq = serial_irq_r;
	reg [8:0] serial_clk_div;
	reg [1:0] serial_clk_in_last;
	assign SS_Link_BACK[0] = sc_start;
	assign SS_Link_BACK[1] = sc_int_clock;
	assign SS_Link_BACK[5:2] = serial_counter;
	assign SS_Link_BACK[6] = serial_out_r;
	assign SS_Link_BACK[7] = serial_clk_out_r;
	assign SS_Link_BACK[16:8] = serial_clk_div;
	always @(posedge clk_sys)
		if (rst) begin
			sc_start <= SS_Link[0];
			sc_int_clock <= SS_Link[1];
			serial_counter <= SS_Link[5:2];
			serial_out_r <= SS_Link[6];
			serial_clk_out_r <= SS_Link[7];
			serial_clk_div <= SS_Link[16:8];
			sb_r <= sb_in;
			serial_clk_in_last <= {1'b0, serial_clk_in};
		end
		else if (ce) begin
			serial_irq_r <= 1'b0;
			if (sel_sc && !cpu_wr_n) begin
				sc_start <= sc_start_in;
				sc_int_clock <= sc_int_clock_in;
				if (sc_start_in) begin
					serial_clk_div <= CLK_DIV[8:0];
					serial_counter <= 4'd8;
					serial_clk_out_r <= 1'b1;
					serial_clk_in_last <= {1'b0, serial_clk_in};
				end
			end
			else if (sel_sb && !cpu_wr_n)
				sb_r <= sb_in;
			else if (sc_start) begin
				if (sc_int_clock) begin
					serial_clk_div <= serial_clk_div - 9'd1;
					if (serial_counter != 0) begin
						if (serial_clk_div == ((CLK_DIV / 2) + 1)) begin
							serial_clk_out_r <= ~serial_clk_out_r;
							serial_out_r <= sb[7];
						end
						else if (!serial_clk_div) begin
							sb_r <= {sb[6:0], serial_data_in};
							serial_clk_out_r <= ~serial_clk_out;
							serial_counter <= serial_counter - 1'd1;
							serial_clk_div <= CLK_DIV[8:0];
						end
					end
					else begin
						serial_irq_r <= 1'b1;
						sc_start <= 1'b0;
						serial_clk_div <= CLK_DIV[8:0];
						serial_counter <= 4'd8;
					end
				end
				else begin
					serial_clk_in_last[0] <= serial_clk_in;
					serial_clk_in_last[1] <= serial_clk_in_last[0];
					if (serial_clk_in_last[1] != serial_clk_in_last[0]) begin
						if (serial_clk_in_last[1] == 0) begin
							serial_out_r <= sb[7];
							serial_counter <= serial_counter - 1'd1;
						end
						else begin
							sb_r <= {sb[6:0], serial_data_in};
							if (serial_counter == 0) begin
								serial_irq_r <= 1'b1;
								sc_start <= 1'b0;
								serial_counter <= 4'd8;
							end
						end
					end
				end
			end
		end
endmodule
module cart_top (
	reset,
	clk_sys,
	ce_cpu,
	ce_cpu2x,
	speed,
	megaduck,
	duck_md0_mode,
	mapper_sel,
	cart_addr,
	cart_a15,
	cart_rd,
	cart_wr,
	cart_do,
	cart_di,
	cart_oe,
	nCS,
	mbc_addr,
	dn_write,
	cart_ready,
	is_cram_addr,
	cram_rd,
	cram_wr,
	cram_bram_wr,
	cram_addr,
	cart_download,
	ram_mask_file,
	ram_size,
	has_save,
	bram_save,
	isGBC_game,
	isSGB_game,
	ioctl_download,
	ioctl_wr,
	ioctl_addr,
	ioctl_dout,
	ioctl_wait,
	bk_wr,
	bk_rtc_wr,
	bk_addr,
	bk_data,
	bk_q,
	img_size,
	rom_di,
	joystick_analog_0,
	ce_32k,
	RTC_time,
	RTC_timestampOut,
	RTC_savedtimeOut,
	RTC_inuse,
	SaveStateExt_Din,
	SaveStateExt_Adr,
	SaveStateExt_wren,
	SaveStateExt_rst,
	SaveStateExt_Dout,
	savestate_load,
	savestate_ovr,
	Savestate_CRAMAddr,
	Savestate_CRAMRWrEn,
	Savestate_CRAMWriteData,
	Savestate_CRAM_Q,
	rumbling
);
	input reset;
	input clk_sys;
	input ce_cpu;
	input ce_cpu2x;
	input speed;
	input megaduck;
	input duck_md0_mode;
	input [2:0] mapper_sel;
	input [14:0] cart_addr;
	input cart_a15;
	input cart_rd;
	input cart_wr;
	output wire [7:0] cart_do;
	input [7:0] cart_di;
	output wire cart_oe;
	input nCS;
	output wire [22:0] mbc_addr;
	output reg dn_write;
	output wire cart_ready;
	output wire is_cram_addr;
	output wire cram_rd;
	output wire cram_wr;
	output wire cram_bram_wr;
	output wire [16:0] cram_addr;
	input cart_download;
	output wire [7:0] ram_mask_file;
	output wire [7:0] ram_size;
	output wire has_save;
	output wire bram_save;
	output wire isGBC_game;
	output wire isSGB_game;
	input ioctl_download;
	input ioctl_wr;
	input [24:0] ioctl_addr;
	input [15:0] ioctl_dout;
	output wire ioctl_wait;
	input bk_wr;
	input bk_rtc_wr;
	input [16:0] bk_addr;
	input [15:0] bk_data;
	output wire [15:0] bk_q;
	input [63:0] img_size;
	input [7:0] rom_di;
	input [15:0] joystick_analog_0;
	input ce_32k;
	input [32:0] RTC_time;
	output wire [31:0] RTC_timestampOut;
	output wire [47:0] RTC_savedtimeOut;
	output wire RTC_inuse;
	input [63:0] SaveStateExt_Din;
	input [9:0] SaveStateExt_Adr;
	input SaveStateExt_wren;
	input SaveStateExt_rst;
	output wire [63:0] SaveStateExt_Dout;
	input savestate_load;
	input savestate_ovr;
	input [19:0] Savestate_CRAMAddr;
	input Savestate_CRAMRWrEn;
	input [15:0] Savestate_CRAMWriteData;
	output wire [15:0] Savestate_CRAM_Q;
	output wire rumbling;
	wire [15:0] SS_Ext;
	wire [15:0] SS_Ext_BACK;
	wire [63:0] SS_Ext2;
	wire [63:0] SS_Ext2_BACK;
	wire [63:0] SaveStateBus_Dout_or [0:1];
	eReg_SavestateV #(
		.index(0),
		.Adr(32),
		.upper(15),
		.lower(0),
		.def(64'h0000000000000001)
	) iREG_SAVESTATE_Ext(
		.clk(clk_sys),
		.BUS_Din(SaveStateExt_Din),
		.BUS_Adr(SaveStateExt_Adr),
		.BUS_wren(SaveStateExt_wren),
		.BUS_rst(SaveStateExt_rst),
		.BUS_Dout(SaveStateBus_Dout_or[0]),
		.Din(SS_Ext_BACK),
		.Dout(SS_Ext)
	);
	eReg_SavestateV #(
		.index(0),
		.Adr(37),
		.upper(63),
		.lower(0),
		.def(64'h0000000000000000)
	) iREG_SAVESTATE_Ext2(
		.clk(clk_sys),
		.BUS_Din(SaveStateExt_Din),
		.BUS_Adr(SaveStateExt_Adr),
		.BUS_wren(SaveStateExt_wren),
		.BUS_rst(SaveStateExt_rst),
		.BUS_Dout(SaveStateBus_Dout_or[1]),
		.Din(SS_Ext2_BACK),
		.Dout(SS_Ext2)
	);
	assign SaveStateExt_Dout = SaveStateBus_Dout_or[0] | SaveStateBus_Dout_or[1];
	wire [7:0] rom_do;
	wire [7:0] mbc_cram_do;
	wire [16:0] mbc_cram_addr;
	wire mbc_ram_enable;
	wire mbc_battery;
	wire mbc_cram_wr;
	wire [7:0] mbc_cram_wr_do;
	reg [7:0] cart_mbc_type;
	wire HuC1 = cart_mbc_type == 255;
	wire HuC3 = cart_mbc_type == 254;
	wire cart_rumbling;
	wire [7:0] cram_q_h;
	wire [7:0] cram_q_l;
	wire [7:0] cram_q = (cram_addr[0] ? cram_q_h : cram_q_l);
	wire gb_camera = cart_mbc_type == 252;
	reg [2:0] mapper_sel_r;
	wire mani161 = mapper_sel_r == 3'd2;
	wire mbc1 = (((mapper_sel_r == 3'd3) || (cart_mbc_type == 1)) || (cart_mbc_type == 2)) || (cart_mbc_type == 3);
	reg mbc1m;
	wire mbc2 = (cart_mbc_type == 5) || (cart_mbc_type == 6);
	wire mbc3 = (((((mapper_sel_r == 3'd4) || (cart_mbc_type == 15)) || (cart_mbc_type == 16)) || (cart_mbc_type == 17)) || (cart_mbc_type == 18)) || (cart_mbc_type == 19);
	reg [7:0] cart_rom_size;
	wire mbc30 = mbc3 && ((cart_rom_size == 7) || (ram_size == 5));
	wire mbc5 = (((((cart_mbc_type == 25) || (cart_mbc_type == 26)) || (cart_mbc_type == 27)) || (cart_mbc_type == 28)) || (cart_mbc_type == 29)) || (cart_mbc_type == 30);
	wire mbc6 = cart_mbc_type == 32;
	wire mbc7 = cart_mbc_type == 34;
	wire megaduck_en = cart_mbc_type == 250;
	reg mmm01;
	wire [3:0] ram_mask = (ram_size == 1 ? 4'b0000 : (ram_size == 2 ? 4'b0000 : (ram_size == 3 ? 4'b0011 : (ram_size == 5 ? 4'b0111 : 4'b1111))));
	wire rocket = (cart_mbc_type == 151) || (cart_mbc_type == 153);
	reg [8:0] rom_mask;
	reg sachen;
	wire tama = cart_mbc_type == 253;
	wire wisdom_tree = mapper_sel_r == 3'd1;
	mappers mappers(
		.reset(reset),
		.clk_sys(clk_sys),
		.ce_cpu(ce_cpu),
		.ce_cpu2x(ce_cpu2x),
		.speed(speed),
		.mbc1(mbc1),
		.mbc1m(mbc1m),
		.mbc2(mbc2),
		.mbc3(mbc3),
		.mbc30(mbc30),
		.mbc5(mbc5),
		.mbc6(mbc6),
		.mbc7(mbc7),
		.mmm01(mmm01),
		.huc1(HuC1),
		.huc3(HuC3),
		.gb_camera(gb_camera),
		.tama(tama),
		.rocket(rocket),
		.sachen(sachen),
		.wisdom_tree(wisdom_tree),
		.mani161(mani161),
		.megaduck(megaduck_en),
		.duck_md0_mode(duck_md0_mode),
		.isGBC_game(isGBC_game),
		.joystick_analog_0(joystick_analog_0),
		.ce_32k(ce_32k),
		.RTC_time(RTC_time),
		.RTC_timestampOut(RTC_timestampOut),
		.RTC_savedtimeOut(RTC_savedtimeOut),
		.RTC_inuse(RTC_inuse),
		.bk_wr(bk_wr),
		.bk_rtc_wr(bk_rtc_wr),
		.bk_addr(bk_addr),
		.bk_data(bk_data),
		.img_size(img_size),
		.savestate_load(savestate_load),
		.savestate_data(SS_Ext),
		.savestate_back(SS_Ext_BACK),
		.savestate_data2(SS_Ext2),
		.savestate_back2(SS_Ext2_BACK),
		.has_ram(|ram_size),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_rd(cart_rd),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cart_oe(cart_oe),
		.rom_di(rom_di),
		.rom_do(rom_do),
		.nCS(nCS),
		.cram_rd(cram_rd),
		.cram_di((bram_save ? cram_q : rom_di)),
		.cram_do(mbc_cram_do),
		.cram_addr(mbc_cram_addr),
		.cram_wr_do(mbc_cram_wr_do),
		.cram_wr(mbc_cram_wr),
		.mbc_addr(mbc_addr),
		.ram_enabled(mbc_ram_enable),
		.has_battery(mbc_battery),
		.rumbling(cart_rumbling)
	);
	reg [7:0] cart_ram_size;
	reg cart_cgb_flag;
	reg [7:0] cart_sgb_flag;
	reg [7:0] cart_old_licensee;
	reg [15:0] cart_logo_data [0:7];
	wire duck_md0_cart = megaduck_en && duck_md0_mode;
	assign ram_size = (duck_md0_cart ? 8'd3 : cart_ram_size);
	wire has_rumble = cart_mbc_type[7:2] == 6'b000111;
	assign rumbling = has_rumble & cart_rumbling;
	assign isGBC_game = cart_cgb_flag;
	assign isSGB_game = (cart_sgb_flag == 8'h03) && (cart_old_licensee == 8'h33);
	reg [7:0] cart_logo_check;
	reg [2:0] cart_logo_idx;
	reg mbc1m_check_end;
	reg mmm01_check_end;
	reg sachen_t1;
	reg sachen_t2;
	wire mbc1m_bank = ~|ioctl_addr[24:20] && (ioctl_addr[19:12] == 8'h40);
	wire mmm01_bank = ioctl_addr[18:12] == 7'h78;
	wire cart_logo_match = &cart_logo_check;
	reg old_cart_download;
	always @(posedge clk_sys) begin
		old_cart_download <= cart_download;
		if (~old_cart_download & cart_download) begin
			cart_logo_idx <= 3'd0;
			cart_logo_check <= 8'd0;
			cart_mbc_type <= 8'd0;
			mbc1m <= 0;
			mmm01 <= 0;
			{sachen, sachen_t1, sachen_t2} <= 0;
			mapper_sel_r <= mapper_sel;
			rom_mask <= 9'd0;
		end
		if (cart_download & ioctl_wr) begin
			rom_mask <= ioctl_addr[22:14] | rom_mask;
			if (megaduck) begin
				cart_cgb_flag <= 0;
				cart_sgb_flag <= 0;
				mapper_sel_r <= 0;
				if (ioctl_addr > 'h100)
					cart_mbc_type <= 8'd250;
			end
			else begin
				if (~|ioctl_addr[24:12] || (mmm01_bank & mmm01))
					case (ioctl_addr[11:0])
						12'h142: cart_cgb_flag <= ioctl_dout[15];
						12'h146: begin
							{cart_mbc_type, cart_sgb_flag} <= ioctl_dout;
							if (mmm01 && (ioctl_dout[15:8] == 8'h11))
								cart_mbc_type <= 8'h0b;
						end
						12'h148: {cart_ram_size, cart_rom_size} <= ioctl_dout;
						12'h14a: {cart_old_licensee} <= ioctl_dout[15:8];
					endcase
				if (|mapper_sel_r) begin
					cart_mbc_type <= 8'd0;
					mbc1m <= 0;
					mmm01 <= 0;
					sachen <= 0;
				end
				else begin
					if (~|ioctl_addr[24:12])
						case (ioctl_addr[11:0])
							12'h100: sachen_t1 <= ioctl_dout[15:8] != 8'hc3;
							12'h140: sachen_t2 <= ioctl_dout[7:0] == 8'hc3;
							12'h150:
								if (sachen_t1 & sachen_t2) begin
									sachen <= 1'b1;
									cart_cgb_flag <= ioctl_dout[15];
									cart_mbc_type <= 0;
									cart_sgb_flag <= 0;
									cart_ram_size <= 0;
									cart_old_licensee <= 0;
								end
						endcase
					if ((ioctl_addr >= 'h104) && (ioctl_addr <= 'h112)) begin
						cart_logo_data[cart_logo_idx] <= ioctl_dout;
						cart_logo_idx <= cart_logo_idx + 1'b1;
					end
					if (mbc1m_bank | mmm01_bank) begin
						if ((ioctl_addr[11:0] >= 12'h104) && (ioctl_addr[11:0] <= 12'h112)) begin
							cart_logo_check[cart_logo_idx] <= ioctl_dout == cart_logo_data[cart_logo_idx];
							cart_logo_idx <= cart_logo_idx + 1'b1;
							if (&cart_logo_idx) begin
								if (mbc1m_bank)
									mbc1m_check_end <= 1;
								if (mmm01_bank)
									mmm01_check_end <= 1;
							end
						end
					end
					if (mbc1m_check_end) begin
						mbc1m_check_end <= 0;
						mbc1m <= cart_logo_match;
					end
					if (mmm01_check_end) begin
						mmm01_check_end <= 0;
						mmm01 <= cart_logo_match;
						if (cart_logo_match)
							mbc1m <= 0;
					end
				end
			end
		end
	end
	reg cart_ready_r = 0;
	reg ioctl_wait_r;
	always @(posedge clk_sys) begin
		if (ioctl_wr)
			ioctl_wait_r <= 1;
		if ((speed ? ce_cpu2x : ce_cpu)) begin
			dn_write <= ioctl_wait_r;
			if (dn_write)
				{ioctl_wait_r, dn_write} <= 0;
			if (dn_write)
				cart_ready_r <= 1;
		end
	end
	assign cart_ready = cart_ready_r;
	assign ioctl_wait = ioctl_wait_r;
	reg [7:0] cart_do_r;
	always @(*)
		if (~cart_ready)
			cart_do_r = 8'h00;
		else if (is_cram_addr)
			cart_do_r = mbc_cram_do;
		else
			cart_do_r = rom_do;
	assign cart_do = cart_do_r;
	assign is_cram_addr = ~nCS & ~cart_addr[14];
	assign cram_rd = cart_rd & is_cram_addr;
	assign cram_wr = (savestate_ovr ? Savestate_CRAMRWrEn : (cart_wr & is_cram_addr) & mbc_ram_enable);
	assign cram_bram_wr = (savestate_ovr ? Savestate_CRAMRWrEn & ~|Savestate_CRAMAddr[16:8] : mbc_cram_wr);
	assign cram_addr = (savestate_ovr ? Savestate_CRAMAddr[16:0] : mbc_cram_addr);
	wire [7:0] cram_di_l = (savestate_ovr ? Savestate_CRAMWriteData[7:0] : mbc_cram_wr_do);
	wire [7:0] cram_di_h = (savestate_ovr ? Savestate_CRAMWriteData[15:8] : mbc_cram_wr_do);
	assign Savestate_CRAM_Q = {cram_q_h, cram_q_l};
	assign bram_save = mbc7 | tama;
	assign ram_mask_file = ((mbc2 || mbc7) || tama ? 8'h01 : (ram_size == 1 ? 8'h03 : (ram_size == 2 ? 8'h0f : (ram_size == 3 ? 8'h3f : (ram_size == 5 ? 8'h7f : 8'hff)))));
	assign has_save = mbc_battery && (((|ram_size || mbc2) || mbc7) || tama);
	dpram #(.addr_width(7)) cram_bram_l(
		.clock_a(clk_sys),
		.clken_a(1'b1),
		.address_a(cram_addr[7:1]),
		.wren_a(cram_bram_wr & (~cram_addr[0] | savestate_ovr)),
		.data_a(cram_di_l),
		.q_a(cram_q_l),
		.clock_b(clk_sys),
		.address_b(bk_addr[6:0]),
		.wren_b(bk_wr & ~|bk_addr[16:7]),
		.data_b(bk_data[7:0]),
		.q_b(bk_q[7:0])
	);
	dpram #(.addr_width(7)) cram_bram_h(
		.clock_a(clk_sys),
		.clken_a(1'b1),
		.address_a(cram_addr[7:1]),
		.wren_a(cram_bram_wr & (cram_addr[0] | savestate_ovr)),
		.data_a(cram_di_h),
		.q_a(cram_q_h),
		.clock_b(clk_sys),
		.address_b(bk_addr[6:0]),
		.wren_b(bk_wr & ~|bk_addr[16:7]),
		.data_b(bk_data[15:8]),
		.q_b(bk_q[15:8])
	);
endmodule
module gb_camera (
	enable,
	reset,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_rd,
	cart_wr,
	cart_di,
	cart_oe_b,
	cram_rd,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input reset;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back_b;
	input [3:0] ram_mask;
	input [8:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_rd;
	input cart_wr;
	input [7:0] cart_di;
	output wire cart_oe_b;
	input cram_rd;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire cart_oe;
	wire ram_enabled;
	wire has_battery;
	wire [15:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign cart_oe_b = (enable ? cart_oe : 1'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 16'd0);
	reg [5:0] rom_bank_reg;
	reg [3:0] ram_bank_reg;
	reg ram_write_en;
	reg cam_en;
	assign savestate_back[5:0] = rom_bank_reg;
	assign savestate_back[8:6] = 0;
	assign savestate_back[12:9] = ram_bank_reg;
	assign savestate_back[13] = 0;
	assign savestate_back[14] = cam_en;
	assign savestate_back[15] = ram_write_en;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			rom_bank_reg <= savestate_data[5:0];
			ram_bank_reg <= savestate_data[12:9];
			cam_en <= savestate_data[14];
			ram_write_en <= savestate_data[15];
		end
		else if (~enable) begin
			rom_bank_reg <= 6'd1;
			ram_bank_reg <= 4'd0;
			cam_en <= 1'b0;
			ram_write_en <= 1'b0;
		end
		else if (ce_cpu) begin
			if (cart_wr & ~cart_a15)
				case (cart_addr[14:13])
					2'b00: ram_write_en <= cart_di[3:0] == 4'ha;
					2'b01: rom_bank_reg <= cart_di[5:0];
					2'b10:
						if (cart_di[4])
							cam_en <= 1'b1;
						else begin
							cam_en <= 1'b0;
							ram_bank_reg <= cart_di[3:0];
						end
				endcase
		end
	wire [3:0] ram_bank = ram_bank_reg & ram_mask[3:0];
	wire [5:0] rom_bank = (~cart_addr[14] ? 6'd0 : rom_bank_reg);
	wire [5:0] rom_bank_m = rom_bank & rom_mask[5:0];
	assign mbc_addr = {3'b000, rom_bank_m, cart_addr[13:0]};
	assign cram_do = (cam_en ? 8'h00 : cram_di);
	assign cram_addr = {ram_bank, cart_addr[12:0]};
	assign cart_oe = (cart_rd & ~cart_a15) | cram_rd;
	assign has_battery = 1;
	assign ram_enabled = ~cam_en & ram_write_en;
endmodule
module huc1 (
	enable,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_rd,
	cart_wr,
	cart_di,
	cart_oe_b,
	cram_rd,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back_b;
	input has_ram;
	input [3:0] ram_mask;
	input [8:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_rd;
	input cart_wr;
	input [7:0] cart_di;
	output wire cart_oe_b;
	input cram_rd;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire ram_enabled;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire cart_oe;
	wire has_battery;
	wire [15:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign cart_oe_b = (enable ? cart_oe : 1'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 16'd0);
	reg ir_en;
	reg [5:0] rom_bank_reg;
	reg [1:0] ram_bank_reg;
	assign savestate_back[5:0] = rom_bank_reg;
	assign savestate_back[8:6] = 0;
	assign savestate_back[10:9] = ram_bank_reg;
	assign savestate_back[12:11] = 0;
	assign savestate_back[13] = ir_en;
	assign savestate_back[14] = 0;
	assign savestate_back[15] = 0;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			rom_bank_reg <= savestate_data[5:0];
			ram_bank_reg <= savestate_data[10:9];
			ir_en <= savestate_data[13];
		end
		else if (~enable) begin
			rom_bank_reg <= 6'd1;
			ram_bank_reg <= 2'd0;
			ir_en <= 1'b0;
		end
		else if (ce_cpu) begin
			if (cart_wr & ~cart_a15)
				case (cart_addr[14:13])
					2'b00: ir_en <= cart_di[3:0] == 4'he;
					2'b01: rom_bank_reg <= (cart_di[5:0] == 0 ? 6'd1 : cart_di[5:0]);
					2'b10: ram_bank_reg <= cart_di[1:0];
				endcase
		end
	wire [1:0] ram_bank = ram_bank_reg & ram_mask[1:0];
	wire [5:0] rom_bank = (~cart_addr[14] ? 6'd0 : rom_bank_reg);
	wire [5:0] rom_bank_m = rom_bank & rom_mask[5:0];
	assign mbc_addr = {3'b000, rom_bank_m, cart_addr[13:0]};
	assign cram_do = (ir_en ? 8'hc0 : cram_di);
	assign cram_addr = {2'b00, ram_bank, cart_addr[12:0]};
	assign cart_oe = (cart_rd & ~cart_a15) | (cram_rd & (ir_en | ram_enabled));
	assign ram_enabled = ~ir_en & has_ram;
	assign has_battery = 1;
endmodule
module huc3 (
	enable,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	ce_32k,
	RTC_time,
	RTC_timestampOut_b,
	RTC_savedtimeOut_b,
	RTC_inuse_b,
	bk_rtc_wr,
	bk_addr,
	bk_data,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_rd,
	cart_wr,
	cart_di,
	cart_oe_b,
	nCS,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [63:0] savestate_data;
	output wire [63:0] savestate_back_b;
	input ce_32k;
	input [32:0] RTC_time;
	output wire [31:0] RTC_timestampOut_b;
	output wire [47:0] RTC_savedtimeOut_b;
	output wire RTC_inuse_b;
	input bk_rtc_wr;
	input [16:0] bk_addr;
	input [15:0] bk_data;
	input has_ram;
	input [3:0] ram_mask;
	input [8:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_rd;
	input cart_wr;
	input [7:0] cart_di;
	output wire cart_oe_b;
	input nCS;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire ram_enabled;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire cart_oe;
	wire has_battery;
	wire [63:0] savestate_back;
	reg [31:0] RTC_timestampOut;
	reg [47:0] RTC_savedtimeOut;
	wire RTC_inuse = 1;
	wire is_cram_addr = ~nCS & ~cart_addr[14];
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign cart_oe_b = (enable ? cart_oe : 1'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 64'd0);
	assign RTC_timestampOut_b = (enable ? RTC_timestampOut : 32'd0);
	assign RTC_savedtimeOut_b = (enable ? RTC_savedtimeOut : 48'd0);
	assign RTC_inuse_b = (enable ? RTC_inuse : 1'd0);
	reg [6:0] rom_bank_reg;
	reg [1:0] ram_bank_reg;
	reg [3:0] mode;
	assign savestate_back[6:0] = rom_bank_reg;
	assign savestate_back[8:7] = ram_bank_reg;
	assign savestate_back[12:9] = mode;
	assign savestate_back[63:13] = 0;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			rom_bank_reg <= savestate_data[6:0];
			ram_bank_reg <= savestate_data[8:7];
			mode <= savestate_data[12:9];
		end
		else if (~enable) begin
			rom_bank_reg <= 7'd0;
			ram_bank_reg <= 2'd0;
			mode <= 4'd0;
		end
		else if (ce_cpu) begin
			if (cart_wr) begin
				if (~cart_a15)
					case (cart_addr[14:13])
						2'b00: mode <= cart_di[3:0];
						2'b01: rom_bank_reg <= cart_di[6:0];
						2'b10: ram_bank_reg <= cart_di[1:0];
						default:
							;
					endcase
			end
		end
	reg [7:0] rtc_index;
	reg [3:0] rtc_flags;
	reg [3:0] rtc_out;
	reg [5:0] rtc_seconds;
	reg [14:0] rtc_subseconds;
	reg [11:0] rtc_minutes;
	reg [15:0] rtc_days;
	reg [31:0] RTC_timestampSaved;
	reg [47:0] RTC_savedtimeIn;
	reg RTC_timestampNew_1;
	reg RTC_saveLoaded;
	wire rtc_subseconds_end = &rtc_subseconds;
	reg [31:0] diffSeconds;
	wire diffSeconds_fast_count = diffSeconds > 0;
	always @(posedge clk_sys) begin
		if (ce_32k)
			rtc_subseconds <= rtc_subseconds + 1'b1;
		if (ce_32k & rtc_subseconds_end)
			RTC_timestampOut <= RTC_timestampOut + 1'd1;
		else if (diffSeconds_fast_count)
			diffSeconds <= diffSeconds - 1'd1;
		if ((ce_32k & rtc_subseconds_end) | diffSeconds_fast_count) begin
			rtc_seconds <= rtc_seconds + 1'b1;
			if (rtc_seconds == 59) begin
				rtc_seconds <= 0;
				rtc_minutes <= rtc_minutes + 1'b1;
				if (rtc_minutes == 1439) begin
					rtc_minutes <= 0;
					rtc_days <= rtc_days + 1'b1;
				end
			end
		end
		RTC_saveLoaded <= 1'b0;
		if (bk_rtc_wr)
			case (bk_addr[7:0])
				0: RTC_timestampSaved[15:0] <= bk_data;
				1: RTC_timestampSaved[31:16] <= bk_data;
				2: RTC_savedtimeIn[15:0] <= bk_data;
				3: RTC_savedtimeIn[31:16] <= bk_data;
				4: RTC_savedtimeIn[47:32] <= bk_data;
				5: RTC_saveLoaded <= 1'b1;
			endcase
		if (RTC_saveLoaded) begin
			if (RTC_timestampOut > RTC_timestampSaved)
				diffSeconds <= RTC_timestampOut - RTC_timestampSaved;
			rtc_seconds <= RTC_savedtimeIn[5:0];
			rtc_minutes <= RTC_savedtimeIn[17:6];
			rtc_days <= RTC_savedtimeIn[33:18];
		end
		RTC_savedtimeOut[33:0] <= {rtc_days, rtc_minutes, rtc_seconds};
		RTC_savedtimeOut[47:34] <= 0;
		if (~enable) begin
			rtc_index <= 8'd0;
			rtc_flags <= 4'd0;
			rtc_out <= 4'd0;
		end
		else if ((ce_cpu & cart_wr) & is_cram_addr) begin
			if (mode == 4'hb) begin
				if (cart_di[7:4] == 4'd1) begin
					case (rtc_index)
						8'h00: rtc_out <= rtc_minutes[3:0];
						8'h01: rtc_out <= rtc_minutes[7:4];
						8'h02: rtc_out <= rtc_minutes[11:8];
						8'h03: rtc_out <= rtc_days[3:0];
						8'h04: rtc_out <= rtc_days[7:4];
						8'h05: rtc_out <= rtc_days[11:8];
						8'h06: rtc_out <= rtc_days[15:12];
					endcase
					rtc_index <= rtc_index + 1'b1;
				end
				if ((cart_di[7:4] == 4'd2) || (cart_di[7:4] == 4'd3)) begin
					case (rtc_index)
						8'h00: begin
							rtc_minutes[3:0] <= cart_di[3:0];
							rtc_seconds <= 0;
							rtc_subseconds <= 0;
						end
						8'h01: rtc_minutes[7:4] <= cart_di[3:0];
						8'h02: rtc_minutes[11:8] <= cart_di[3:0];
						8'h03: rtc_days[3:0] <= cart_di[3:0];
						8'h04: rtc_days[7:4] <= cart_di[3:0];
						8'h05: rtc_days[11:8] <= cart_di[3:0];
						8'h06: rtc_days[15:12] <= cart_di[3:0];
					endcase
					if (cart_di[4])
						rtc_index <= rtc_index + 1'b1;
				end
				case (cart_di[7:4])
					4'd4: rtc_index[3:0] <= cart_di[3:0];
					4'd5: rtc_index[7:4] <= cart_di[3:0];
					4'd6: rtc_flags <= cart_di[3:0];
					default:
						;
				endcase
			end
		end
		RTC_timestampNew_1 <= RTC_time[32];
		if (RTC_timestampNew_1 != RTC_time[32])
			RTC_timestampOut <= RTC_time[31:0];
	end
	wire [1:0] ram_bank = ram_bank_reg & ram_mask[1:0];
	wire [6:0] rom_bank = (~cart_addr[14] ? 7'd0 : rom_bank_reg);
	wire [6:0] rom_bank_m = rom_bank & rom_mask[6:0];
	reg [7:0] cram_do_r;
	always @(*) begin
		cram_do_r = 8'hff;
		case (mode)
			4'h0, 4'ha:
				if (has_ram)
					cram_do_r = cram_di;
			4'hc: cram_do_r[3:0] = (rtc_flags == 4'd2 ? 4'h1 : rtc_out);
			4'hd: cram_do_r[3:0] = 4'h1;
			4'he: cram_do_r[0] = 1'b0;
			default:
				;
		endcase
	end
	assign mbc_addr = {2'b00, rom_bank_m, cart_addr[13:0]};
	assign cram_do = cram_do_r;
	assign cram_addr = {2'b00, ram_bank, cart_addr[12:0]};
	assign cart_oe = cart_rd & (~cart_a15 | is_cram_addr);
	assign ram_enabled = (mode == 4'ha) & has_ram;
	assign has_battery = has_ram;
endmodule
module mappers (
	reset,
	clk_sys,
	ce_cpu,
	ce_cpu2x,
	speed,
	mbc1,
	mbc1m,
	mbc2,
	mbc3,
	mbc30,
	mbc5,
	mbc6,
	mbc7,
	mmm01,
	huc1,
	huc3,
	gb_camera,
	tama,
	rocket,
	sachen,
	wisdom_tree,
	mani161,
	megaduck,
	duck_md0_mode,
	isGBC_game,
	joystick_analog_0,
	ce_32k,
	RTC_time,
	RTC_timestampOut,
	RTC_savedtimeOut,
	RTC_inuse,
	bk_wr,
	bk_rtc_wr,
	bk_addr,
	bk_data,
	img_size,
	savestate_load,
	savestate_data,
	savestate_back,
	savestate_data2,
	savestate_back2,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_rd,
	cart_wr,
	cart_di,
	cart_oe,
	rom_di,
	rom_do,
	nCS,
	cram_rd,
	cram_di,
	cram_do,
	cram_addr,
	cram_wr_do,
	cram_wr,
	mbc_addr,
	ram_enabled,
	has_battery,
	rumbling
);
	input reset;
	input clk_sys;
	input ce_cpu;
	input ce_cpu2x;
	input speed;
	input mbc1;
	input mbc1m;
	input mbc2;
	input mbc3;
	input mbc30;
	input mbc5;
	input mbc6;
	input mbc7;
	input mmm01;
	input huc1;
	input huc3;
	input gb_camera;
	input tama;
	input rocket;
	input sachen;
	input wisdom_tree;
	input mani161;
	input megaduck;
	input duck_md0_mode;
	input isGBC_game;
	input [15:0] joystick_analog_0;
	input ce_32k;
	input [32:0] RTC_time;
	output wire [31:0] RTC_timestampOut;
	output wire [47:0] RTC_savedtimeOut;
	output wire RTC_inuse;
	input bk_wr;
	input bk_rtc_wr;
	input [16:0] bk_addr;
	input [15:0] bk_data;
	input [63:0] img_size;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back;
	input [63:0] savestate_data2;
	output wire [63:0] savestate_back2;
	input has_ram;
	input [3:0] ram_mask;
	input [8:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_rd;
	input cart_wr;
	input [7:0] cart_di;
	output wire cart_oe;
	input [7:0] rom_di;
	output wire [7:0] rom_do;
	input nCS;
	input cram_rd;
	input [7:0] cram_di;
	output wire [7:0] cram_do;
	output wire [16:0] cram_addr;
	output wire [7:0] cram_wr_do;
	output wire cram_wr;
	output wire [22:0] mbc_addr;
	output wire ram_enabled;
	output wire has_battery;
	output wire rumbling;
	wire [7:0] cram_do_b__map_mbc1;
	wire [7:0] cram_do_b__map_mbc2;
	wire [7:0] cram_do_b__map_mbc3;
	wire [7:0] cram_do_b__map_mbc5;
	wire [7:0] cram_do_b__map_mbc6;
	wire [7:0] cram_do_b__map_mbc7;
	wire [7:0] cram_do_b__map_mmm01;
	wire [7:0] cram_do_b__map_huc1;
	wire [7:0] cram_do_b__map_huc3;
	wire [7:0] cram_do_b__map_gb_camera;
	wire [7:0] cram_do_b__map_tama;
	wire [7:0] cram_do_b__map_rocket;
	wire [7:0] cram_do_b__map_sachen;
	wire [7:0] cram_do_b__map_megaduck;
	wire [7:0] cram_do_b__map_misc;
	wire no_mapper = ~(((((((((((((((mbc1 | mbc2) | mbc3) | mbc5) | mbc6) | mbc7) | mmm01) | huc1) | huc3) | gb_camera) | tama) | rocket) | sachen) | wisdom_tree) | mani161) | megaduck);
	wire no_mapper_multi_bank = no_mapper & rom_mask[1];
	wire [7:0] cram_do_b = (((((((((((((((mbc1 | no_mapper_multi_bank) | mbc2) | mbc3) | mbc5) | mbc6) | mbc7) | mmm01) | huc1) | huc3) | gb_camera) | tama) | rocket) | sachen) | megaduck) | (~reset & (wisdom_tree | mani161)) ? (((((((((((((cram_do_b__map_mbc1 | cram_do_b__map_mbc2) | cram_do_b__map_mbc3) | cram_do_b__map_mbc5) | cram_do_b__map_mbc6) | cram_do_b__map_mbc7) | cram_do_b__map_mmm01) | cram_do_b__map_huc1) | cram_do_b__map_huc3) | cram_do_b__map_gb_camera) | cram_do_b__map_tama) | cram_do_b__map_rocket) | cram_do_b__map_sachen) | cram_do_b__map_megaduck) | cram_do_b__map_misc : ~0);
	wire [7:0] rom_do_b__map_rocket;
	wire [7:0] rom_do_b = (((((((((((((((mbc1 | no_mapper_multi_bank) | mbc2) | mbc3) | mbc5) | mbc6) | mbc7) | mmm01) | huc1) | huc3) | gb_camera) | tama) | rocket) | sachen) | megaduck) | (~reset & (wisdom_tree | mani161)) ? rom_do_b__map_rocket : ~0);
	wire [22:0] mbc_addr_b__map_mbc1;
	wire [22:0] mbc_addr_b__map_mbc2;
	wire [22:0] mbc_addr_b__map_mbc3;
	wire [22:0] mbc_addr_b__map_mbc5;
	wire [22:0] mbc_addr_b__map_mbc6;
	wire [22:0] mbc_addr_b__map_mbc7;
	wire [22:0] mbc_addr_b__map_mmm01;
	wire [22:0] mbc_addr_b__map_huc1;
	wire [22:0] mbc_addr_b__map_huc3;
	wire [22:0] mbc_addr_b__map_gb_camera;
	wire [22:0] mbc_addr_b__map_tama;
	wire [22:0] mbc_addr_b__map_rocket;
	wire [22:0] mbc_addr_b__map_sachen;
	wire [22:0] mbc_addr_b__map_megaduck;
	wire [22:0] mbc_addr_b__map_misc;
	wire [22:0] mbc_addr_b = (((((((((((((mbc_addr_b__map_mbc1 | mbc_addr_b__map_mbc2) | mbc_addr_b__map_mbc3) | mbc_addr_b__map_mbc5) | mbc_addr_b__map_mbc6) | mbc_addr_b__map_mbc7) | mbc_addr_b__map_mmm01) | mbc_addr_b__map_huc1) | mbc_addr_b__map_huc3) | mbc_addr_b__map_gb_camera) | mbc_addr_b__map_tama) | mbc_addr_b__map_rocket) | mbc_addr_b__map_sachen) | mbc_addr_b__map_megaduck) | mbc_addr_b__map_misc;
	wire [16:0] cram_addr_b__map_mbc1;
	wire [16:0] cram_addr_b__map_mbc2;
	wire [16:0] cram_addr_b__map_mbc3;
	wire [16:0] cram_addr_b__map_mbc5;
	wire [16:0] cram_addr_b__map_mbc6;
	wire [16:0] cram_addr_b__map_mbc7;
	wire [16:0] cram_addr_b__map_mmm01;
	wire [16:0] cram_addr_b__map_huc1;
	wire [16:0] cram_addr_b__map_huc3;
	wire [16:0] cram_addr_b__map_gb_camera;
	wire [16:0] cram_addr_b__map_tama;
	wire [16:0] cram_addr_b__map_rocket;
	wire [16:0] cram_addr_b__map_sachen;
	wire [16:0] cram_addr_b__map_megaduck;
	wire [16:0] cram_addr_b__map_misc;
	wire [16:0] cram_addr_b = (((((((((((((cram_addr_b__map_mbc1 | cram_addr_b__map_mbc2) | cram_addr_b__map_mbc3) | cram_addr_b__map_mbc5) | cram_addr_b__map_mbc6) | cram_addr_b__map_mbc7) | cram_addr_b__map_mmm01) | cram_addr_b__map_huc1) | cram_addr_b__map_huc3) | cram_addr_b__map_gb_camera) | cram_addr_b__map_tama) | cram_addr_b__map_rocket) | cram_addr_b__map_sachen) | cram_addr_b__map_megaduck) | cram_addr_b__map_misc;
	wire ram_enabled_b__map_mbc1;
	wire ram_enabled_b__map_mbc2;
	wire ram_enabled_b__map_mbc3;
	wire ram_enabled_b__map_mbc5;
	wire ram_enabled_b__map_mbc6;
	wire ram_enabled_b__map_mbc7;
	wire ram_enabled_b__map_mmm01;
	wire ram_enabled_b__map_huc1;
	wire ram_enabled_b__map_huc3;
	wire ram_enabled_b__map_gb_camera;
	wire ram_enabled_b__map_tama;
	wire ram_enabled_b__map_rocket;
	wire ram_enabled_b__map_sachen;
	wire ram_enabled_b__map_megaduck;
	wire ram_enabled_b__map_misc;
	wire ram_enabled_b = (((((((((((((ram_enabled_b__map_mbc1 | ram_enabled_b__map_mbc2) | ram_enabled_b__map_mbc3) | ram_enabled_b__map_mbc5) | ram_enabled_b__map_mbc6) | ram_enabled_b__map_mbc7) | ram_enabled_b__map_mmm01) | ram_enabled_b__map_huc1) | ram_enabled_b__map_huc3) | ram_enabled_b__map_gb_camera) | ram_enabled_b__map_tama) | ram_enabled_b__map_rocket) | ram_enabled_b__map_sachen) | ram_enabled_b__map_megaduck) | ram_enabled_b__map_misc;
	wire has_battery_b__map_mbc1;
	wire has_battery_b__map_mbc2;
	wire has_battery_b__map_mbc3;
	wire has_battery_b__map_mbc5;
	wire has_battery_b__map_mbc6;
	wire has_battery_b__map_mbc7;
	wire has_battery_b__map_mmm01;
	wire has_battery_b__map_huc1;
	wire has_battery_b__map_huc3;
	wire has_battery_b__map_gb_camera;
	wire has_battery_b__map_tama;
	wire has_battery_b__map_rocket;
	wire has_battery_b__map_sachen;
	wire has_battery_b__map_megaduck;
	wire has_battery_b__map_misc;
	wire has_battery_b = (((((((((((((has_battery_b__map_mbc1 | has_battery_b__map_mbc2) | has_battery_b__map_mbc3) | has_battery_b__map_mbc5) | has_battery_b__map_mbc6) | has_battery_b__map_mbc7) | has_battery_b__map_mmm01) | has_battery_b__map_huc1) | has_battery_b__map_huc3) | has_battery_b__map_gb_camera) | has_battery_b__map_tama) | has_battery_b__map_rocket) | has_battery_b__map_sachen) | has_battery_b__map_megaduck) | has_battery_b__map_misc;
	wire [15:0] savestate_back_b__map_mbc1;
	wire [15:0] savestate_back_b__map_mbc2;
	wire [15:0] savestate_back_b__map_mbc3;
	wire [15:0] savestate_back_b__map_mbc5;
	wire [15:0] savestate_back_b__map_mbc7;
	wire [15:0] savestate_back_b__map_huc1;
	wire [15:0] savestate_back_b__map_gb_camera;
	wire [15:0] savestate_back_b__map_rocket;
	wire [15:0] savestate_back_b__map_megaduck;
	wire [15:0] savestate_back_b__map_misc;
	wire [15:0] savestate_back_b = ((((((((savestate_back_b__map_mbc1 | savestate_back_b__map_mbc2) | savestate_back_b__map_mbc3) | savestate_back_b__map_mbc5) | savestate_back_b__map_mbc7) | savestate_back_b__map_huc1) | savestate_back_b__map_gb_camera) | savestate_back_b__map_rocket) | savestate_back_b__map_megaduck) | savestate_back_b__map_misc;
	wire [63:0] savestate_back2_b__map_mbc6;
	wire [63:0] savestate_back2_b__map_mbc7;
	wire [63:0] savestate_back2_b__map_mmm01;
	wire [63:0] savestate_back2_b__map_huc3;
	wire [63:0] savestate_back2_b__map_tama;
	wire [63:0] savestate_back2_b__map_sachen;
	wire [63:0] savestate_back2_b = ((((savestate_back2_b__map_mbc6 | savestate_back2_b__map_mbc7) | savestate_back2_b__map_mmm01) | savestate_back2_b__map_huc3) | savestate_back2_b__map_tama) | savestate_back2_b__map_sachen;
	wire [7:0] cram_wr_do_b__map_mbc7;
	wire [7:0] cram_wr_do_b__map_tama;
	wire [7:0] cram_wr_do_b = cram_wr_do_b__map_mbc7 | cram_wr_do_b__map_tama;
	wire cram_wr_b__map_mbc7;
	wire cram_wr_b__map_tama;
	wire cram_wr_b = cram_wr_b__map_mbc7 | cram_wr_b__map_tama;
	wire cart_oe_b__map_mbc3;
	wire cart_oe_b__map_mbc7;
	wire cart_oe_b__map_huc1;
	wire cart_oe_b__map_huc3;
	wire cart_oe_b__map_gb_camera;
	wire cart_oe_b__map_tama;
	wire cart_oe_b = ((((cart_oe_b__map_mbc3 | cart_oe_b__map_mbc7) | cart_oe_b__map_huc1) | cart_oe_b__map_huc3) | cart_oe_b__map_gb_camera) | cart_oe_b__map_tama;
	wire [31:0] RTC_timestampOut_b__map_mbc3;
	wire [31:0] RTC_timestampOut_b__map_huc3;
	wire [31:0] RTC_timestampOut_b = RTC_timestampOut_b__map_mbc3 | RTC_timestampOut_b__map_huc3;
	wire [47:0] RTC_savedtimeOut_b__map_mbc3;
	wire [47:0] RTC_savedtimeOut_b__map_huc3;
	wire [47:0] RTC_savedtimeOut_b = RTC_savedtimeOut_b__map_mbc3 | RTC_savedtimeOut_b__map_huc3;
	wire RTC_inuse_b__map_mbc3;
	wire RTC_inuse_b__map_huc3;
	wire RTC_inuse_b = RTC_inuse_b__map_mbc3 | RTC_inuse_b__map_huc3;
	wire ce = (speed ? ce_cpu2x : ce_cpu);
	wire no_mapper_single_bank = no_mapper & ~rom_mask[1];
	wire rom_override = rocket;
	wire cart_oe_override = ((((mbc3 | mbc7) | huc1) | huc3) | gb_camera) | tama;
	mbc1 map_mbc1(
		.enable(mbc1 | no_mapper_multi_bank),
		.mbc1m(mbc1m),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data),
		.savestate_back_b(savestate_back_b__map_mbc1),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_mbc1),
		.cram_addr_b(cram_addr_b__map_mbc1),
		.mbc_addr_b(mbc_addr_b__map_mbc1),
		.ram_enabled_b(ram_enabled_b__map_mbc1),
		.has_battery_b(has_battery_b__map_mbc1)
	);
	mbc2 map_mbc2(
		.enable(mbc2),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data),
		.savestate_back_b(savestate_back_b__map_mbc2),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_mbc2),
		.cram_addr_b(cram_addr_b__map_mbc2),
		.mbc_addr_b(mbc_addr_b__map_mbc2),
		.ram_enabled_b(ram_enabled_b__map_mbc2),
		.has_battery_b(has_battery_b__map_mbc2)
	);
	mbc3 map_mbc3(
		.enable(mbc3),
		.reset(reset),
		.mbc30(mbc30),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data),
		.savestate_back_b(savestate_back_b__map_mbc3),
		.ce_32k(ce_32k),
		.RTC_time(RTC_time),
		.RTC_timestampOut_b(RTC_timestampOut_b__map_mbc3),
		.RTC_savedtimeOut_b(RTC_savedtimeOut_b__map_mbc3),
		.RTC_inuse_b(RTC_inuse_b__map_mbc3),
		.bk_wr(bk_wr),
		.bk_rtc_wr(bk_rtc_wr),
		.bk_addr(bk_addr),
		.bk_data(bk_data),
		.img_size(img_size),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_rd(cart_rd),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cart_oe_b(cart_oe_b__map_mbc3),
		.nCS(nCS),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_mbc3),
		.cram_addr_b(cram_addr_b__map_mbc3),
		.mbc_addr_b(mbc_addr_b__map_mbc3),
		.ram_enabled_b(ram_enabled_b__map_mbc3),
		.has_battery_b(has_battery_b__map_mbc3)
	);
	mbc5 map_mbc5(
		.enable(mbc5),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data),
		.savestate_back_b(savestate_back_b__map_mbc5),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_mbc5),
		.cram_addr_b(cram_addr_b__map_mbc5),
		.mbc_addr_b(mbc_addr_b__map_mbc5),
		.ram_enabled_b(ram_enabled_b__map_mbc5),
		.has_battery_b(has_battery_b__map_mbc5),
		.rumbling(rumbling)
	);
	mbc6 map_mbc6(
		.enable(mbc6),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data2),
		.savestate_back_b(savestate_back2_b__map_mbc6),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_mbc6),
		.cram_addr_b(cram_addr_b__map_mbc6),
		.mbc_addr_b(mbc_addr_b__map_mbc6),
		.ram_enabled_b(ram_enabled_b__map_mbc6),
		.has_battery_b(has_battery_b__map_mbc6)
	);
	mbc7 map_mbc7(
		.enable(mbc7),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.ce_1x(ce_cpu),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data),
		.savestate_back_b(savestate_back_b__map_mbc7),
		.savestate_data2(savestate_data2),
		.savestate_back2_b(savestate_back2_b__map_mbc7),
		.joystick_analog_x(joystick_analog_0[7:0]),
		.joystick_analog_y(joystick_analog_0[15:8]),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_rd(cart_rd),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cart_oe_b(cart_oe_b__map_mbc7),
		.nCS(nCS),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_mbc7),
		.cram_addr_b(cram_addr_b__map_mbc7),
		.cram_wr_do_b(cram_wr_do_b__map_mbc7),
		.cram_wr_b(cram_wr_b__map_mbc7),
		.mbc_addr_b(mbc_addr_b__map_mbc7),
		.ram_enabled_b(ram_enabled_b__map_mbc7),
		.has_battery_b(has_battery_b__map_mbc7)
	);
	mmm01 map_mmm01(
		.enable(mmm01),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data2),
		.savestate_back_b(savestate_back2_b__map_mmm01),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_mmm01),
		.cram_addr_b(cram_addr_b__map_mmm01),
		.mbc_addr_b(mbc_addr_b__map_mmm01),
		.ram_enabled_b(ram_enabled_b__map_mmm01),
		.has_battery_b(has_battery_b__map_mmm01)
	);
	huc1 map_huc1(
		.enable(huc1),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data),
		.savestate_back_b(savestate_back_b__map_huc1),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_rd(cart_rd),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cart_oe_b(cart_oe_b__map_huc1),
		.cram_rd(cram_rd),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_huc1),
		.cram_addr_b(cram_addr_b__map_huc1),
		.mbc_addr_b(mbc_addr_b__map_huc1),
		.ram_enabled_b(ram_enabled_b__map_huc1),
		.has_battery_b(has_battery_b__map_huc1)
	);
	huc3 map_huc3(
		.enable(huc3),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data2),
		.savestate_back_b(savestate_back2_b__map_huc3),
		.ce_32k(ce_32k),
		.RTC_time(RTC_time),
		.RTC_timestampOut_b(RTC_timestampOut_b__map_huc3),
		.RTC_savedtimeOut_b(RTC_savedtimeOut_b__map_huc3),
		.RTC_inuse_b(RTC_inuse_b__map_huc3),
		.bk_rtc_wr(bk_rtc_wr),
		.bk_addr(bk_addr),
		.bk_data(bk_data),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_rd(cart_rd),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cart_oe_b(cart_oe_b__map_huc3),
		.nCS(nCS),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_huc3),
		.cram_addr_b(cram_addr_b__map_huc3),
		.mbc_addr_b(mbc_addr_b__map_huc3),
		.ram_enabled_b(ram_enabled_b__map_huc3),
		.has_battery_b(has_battery_b__map_huc3)
	);
	gb_camera map_gb_camera(
		.enable(gb_camera),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data),
		.savestate_back_b(savestate_back_b__map_gb_camera),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_rd(cart_rd),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cart_oe_b(cart_oe_b__map_gb_camera),
		.cram_rd(cram_rd),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_gb_camera),
		.cram_addr_b(cram_addr_b__map_gb_camera),
		.mbc_addr_b(mbc_addr_b__map_gb_camera),
		.ram_enabled_b(ram_enabled_b__map_gb_camera),
		.has_battery_b(has_battery_b__map_gb_camera)
	);
	tama map_tama(
		.enable(tama),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.ce_32k(ce_32k),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data2),
		.savestate_back_b(savestate_back2_b__map_tama),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_rd(cart_rd),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cart_oe_b(cart_oe_b__map_tama),
		.nCS(nCS),
		.cram_rd(cram_rd),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_tama),
		.cram_addr_b(cram_addr_b__map_tama),
		.cram_wr_do_b(cram_wr_do_b__map_tama),
		.cram_wr_b(cram_wr_b__map_tama),
		.mbc_addr_b(mbc_addr_b__map_tama),
		.ram_enabled_b(ram_enabled_b__map_tama),
		.has_battery_b(has_battery_b__map_tama)
	);
	rocket map_rocket(
		.enable(rocket),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data),
		.savestate_back_b(savestate_back_b__map_rocket),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.rom_di(rom_di),
		.rom_do_b(rom_do_b__map_rocket),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_rocket),
		.cram_addr_b(cram_addr_b__map_rocket),
		.mbc_addr_b(mbc_addr_b__map_rocket),
		.ram_enabled_b(ram_enabled_b__map_rocket),
		.has_battery_b(has_battery_b__map_rocket)
	);
	sachen map_sachen(
		.enable(sachen),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.isGBC_game(isGBC_game),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data2),
		.savestate_back_b(savestate_back2_b__map_sachen),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.nCS(nCS),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_sachen),
		.cram_addr_b(cram_addr_b__map_sachen),
		.mbc_addr_b(mbc_addr_b__map_sachen),
		.ram_enabled_b(ram_enabled_b__map_sachen),
		.has_battery_b(has_battery_b__map_sachen)
	);
	megaduck map_megaduck(
		.enable(megaduck),
		.duck_md0_mode(duck_md0_mode),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data),
		.savestate_back_b(savestate_back_b__map_megaduck),
		.has_ram(has_ram),
		.ram_mask(ram_mask),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_mbc_type(cart_mbc_type),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_megaduck),
		.cram_addr_b(cram_addr_b__map_megaduck),
		.mbc_addr_b(mbc_addr_b__map_megaduck),
		.ram_enabled_b(ram_enabled_b__map_megaduck),
		.has_battery_b(has_battery_b__map_megaduck)
	);
	misc_mapper map_misc(
		.enable(~reset & (wisdom_tree | mani161)),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.mapper_sel(mani161),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data),
		.savestate_back_b(savestate_back_b__map_misc),
		.rom_mask(rom_mask),
		.cart_addr(cart_addr),
		.cart_a15(cart_a15),
		.cart_wr(cart_wr),
		.cart_di(cart_di),
		.cram_di(cram_di),
		.cram_do_b(cram_do_b__map_misc),
		.cram_addr_b(cram_addr_b__map_misc),
		.mbc_addr_b(mbc_addr_b__map_misc),
		.ram_enabled_b(ram_enabled_b__map_misc),
		.has_battery_b(has_battery_b__map_misc)
	);
	assign {cram_do} = {cram_do_b};
	assign {savestate_back, savestate_back2} = {savestate_back_b, savestate_back2_b};
	assign {RTC_timestampOut, RTC_savedtimeOut, RTC_inuse} = {RTC_timestampOut_b, RTC_savedtimeOut_b, RTC_inuse_b};
	assign {cram_wr_do, cram_wr} = {cram_wr_do_b, cram_wr_b};
	assign mbc_addr = (no_mapper_single_bank ? {8'd0, cart_addr[14:0]} : mbc_addr_b);
	assign cram_addr = (no_mapper_single_bank ? {4'd0, cart_addr[12:0]} : cram_addr_b);
	assign has_battery = (no_mapper_single_bank ? cart_mbc_type == 8'h09 : has_battery_b);
	assign ram_enabled = (no_mapper_single_bank ? has_ram : ram_enabled_b);
	assign rom_do = (rom_override ? rom_do_b : rom_di);
	assign cart_oe = (cart_oe_override ? cart_oe_b : (cart_rd & ~cart_a15) | (cram_rd & ram_enabled));
endmodule
module mbc1 (
	enable,
	mbc1m,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_wr,
	cart_di,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input mbc1m;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back_b;
	input has_ram;
	input [1:0] ram_mask;
	input [6:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_wr;
	input [7:0] cart_di;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire ram_enabled;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire has_battery;
	wire [15:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 16'd0);
	reg mbc1_mode;
	reg [1:0] mbc_ram_bank_reg;
	wire [1:0] mbc1_bank2 = mbc_ram_bank_reg[1:0] & {2 {cart_addr[14] | mbc1_mode}};
	wire [1:0] mbc1_ram_bank = mbc1_bank2 & ram_mask[1:0];
	reg [4:0] mbc_rom_bank_reg;
	wire [4:0] mbc_rom_bank = (~cart_addr[14] ? 5'd0 : mbc_rom_bank_reg);
	wire [6:0] mbc1_rom_bank_mode = (mbc1m ? {1'b0, mbc1_bank2, mbc_rom_bank[3:0]} : {mbc1_bank2, mbc_rom_bank[4:0]});
	wire [6:0] mbc1_rom_bank = mbc1_rom_bank_mode & rom_mask[6:0];
	reg mbc_ram_enable;
	assign savestate_back[4:0] = mbc_rom_bank_reg;
	assign savestate_back[8:5] = 0;
	assign savestate_back[10:9] = mbc_ram_bank_reg;
	assign savestate_back[12:11] = 0;
	assign savestate_back[13] = mbc1_mode;
	assign savestate_back[14] = 0;
	assign savestate_back[15] = mbc_ram_enable;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			mbc_rom_bank_reg <= savestate_data[4:0];
			mbc_ram_bank_reg <= savestate_data[10:9];
			mbc1_mode <= savestate_data[13];
			mbc_ram_enable <= savestate_data[15];
		end
		else if (~enable) begin
			mbc_rom_bank_reg <= 5'd1;
			mbc_ram_bank_reg <= 2'd0;
			mbc1_mode <= 1'b0;
			mbc_ram_enable <= 1'b0;
		end
		else if (ce_cpu) begin
			if (cart_wr & ~cart_a15)
				case (cart_addr[14:13])
					2'b00: mbc_ram_enable <= cart_di[3:0] == 4'ha;
					2'b01: mbc_rom_bank_reg <= (cart_di[4:0] == 0 ? 5'd1 : cart_di[4:0]);
					2'b10: mbc_ram_bank_reg <= cart_di[1:0];
					2'b11: mbc1_mode <= cart_di[0];
				endcase
		end
	assign mbc_addr = {2'b00, mbc1_rom_bank, cart_addr[13:0]};
	assign ram_enabled = mbc_ram_enable & has_ram;
	assign cram_do = (ram_enabled ? cram_di : 8'hff);
	assign cram_addr = {2'b00, mbc1_ram_bank, cart_addr[12:0]};
	assign has_battery = cart_mbc_type == 8'h03;
endmodule
module mbc2 (
	enable,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_wr,
	cart_di,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back_b;
	input [1:0] ram_mask;
	input [6:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_wr;
	input [7:0] cart_di;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire ram_enabled;
	wire has_battery;
	wire [15:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 16'd0);
	reg [3:0] mbc_rom_bank_reg;
	wire [3:0] mbc_rom_bank = (~cart_addr[14] ? 4'd0 : mbc_rom_bank_reg);
	wire [3:0] mbc2_rom_bank = mbc_rom_bank & rom_mask[3:0];
	reg mbc_ram_enable;
	assign savestate_back[3:0] = mbc_rom_bank_reg;
	assign savestate_back[14:4] = 0;
	assign savestate_back[15] = mbc_ram_enable;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			mbc_rom_bank_reg <= savestate_data[3:0];
			mbc_ram_enable <= savestate_data[15];
		end
		else if (~enable) begin
			mbc_rom_bank_reg <= 4'd1;
			mbc_ram_enable <= 1'b0;
		end
		else if (ce_cpu) begin
			if ((cart_wr & ~cart_a15) & ~cart_addr[14]) begin
				if (cart_addr[8])
					mbc_rom_bank_reg <= (cart_di[3:0] == 4'd0 ? 4'd1 : cart_di[3:0]);
				else
					mbc_ram_enable <= cart_di[3:0] == 4'ha;
			end
		end
	assign mbc_addr = {5'd0, mbc2_rom_bank, cart_addr[13:0]};
	assign cram_do = (mbc_ram_enable ? {4'hf, cram_di[3:0]} : 8'hff);
	assign cram_addr = {8'd0, cart_addr[8:0]};
	assign has_battery = cart_mbc_type == 8'h06;
	assign ram_enabled = mbc_ram_enable;
endmodule
module mbc3 (
	enable,
	reset,
	mbc30,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	ce_32k,
	RTC_time,
	RTC_timestampOut_b,
	RTC_savedtimeOut_b,
	RTC_inuse_b,
	bk_wr,
	bk_rtc_wr,
	bk_addr,
	bk_data,
	img_size,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_rd,
	cart_wr,
	cart_di,
	cart_oe_b,
	nCS,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input reset;
	input mbc30;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back_b;
	input ce_32k;
	input [32:0] RTC_time;
	output wire [31:0] RTC_timestampOut_b;
	output wire [47:0] RTC_savedtimeOut_b;
	output wire RTC_inuse_b;
	input bk_wr;
	input bk_rtc_wr;
	input [16:0] bk_addr;
	input [15:0] bk_data;
	input [63:0] img_size;
	input has_ram;
	input [2:0] ram_mask;
	input [7:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_rd;
	input cart_wr;
	input [7:0] cart_di;
	output wire cart_oe_b;
	input nCS;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire cart_oe;
	wire ram_enabled;
	wire has_battery;
	wire [15:0] savestate_back;
	wire is_cram_addr = ~nCS & ~cart_addr[14];
	reg [31:0] RTC_timestampOut;
	reg [47:0] RTC_savedtimeOut;
	reg RTC_inuse;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign cart_oe_b = (enable ? cart_oe : 1'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 16'd0);
	assign RTC_timestampOut_b = (enable ? RTC_timestampOut : 32'd0);
	assign RTC_savedtimeOut_b = (enable ? RTC_savedtimeOut : 48'd0);
	assign RTC_inuse_b = (enable ? RTC_inuse : 1'd0);
	reg [7:0] mbc_rom_bank_reg;
	reg [2:0] mbc_ram_bank_reg;
	reg mbc_ram_enable;
	reg mbc3_mode;
	assign savestate_back[7:0] = mbc_rom_bank_reg;
	assign savestate_back[8] = 0;
	assign savestate_back[11:9] = mbc_ram_bank_reg;
	assign savestate_back[13:12] = 0;
	assign savestate_back[14] = mbc3_mode;
	assign savestate_back[15] = mbc_ram_enable;
	reg [2:0] rtc_index;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			mbc_rom_bank_reg <= savestate_data[7:0];
			mbc_ram_bank_reg <= savestate_data[11:9];
			mbc3_mode <= savestate_data[14];
			mbc_ram_enable <= savestate_data[15];
		end
		else if (~enable) begin
			mbc_rom_bank_reg <= 8'd1;
			mbc_ram_bank_reg <= 3'd0;
			mbc3_mode <= 1'b0;
			mbc_ram_enable <= 1'b0;
		end
		else if (ce_cpu) begin
			if (cart_wr & ~cart_a15)
				case (cart_addr[14:13])
					2'b00: mbc_ram_enable <= cart_di[3:0] == 4'ha;
					2'b01: mbc_rom_bank_reg <= ({cart_di[7] & mbc30, cart_di[6:0]} == 8'd0 ? 8'd1 : cart_di[7:0]);
					2'b10:
						if (cart_di[3]) begin
							mbc3_mode <= 1'b1;
							rtc_index <= cart_di[2:0];
						end
						else begin
							mbc3_mode <= 1'b0;
							mbc_ram_bank_reg <= cart_di[2:0];
						end
					2'b11:
						;
				endcase
		end
	wire [2:0] mbc3_ram_bank = mbc_ram_bank_reg[2:0] & ram_mask[2:0];
	wire [7:0] mbc_rom_bank = (~cart_addr[14] ? 8'd0 : mbc_rom_bank_reg);
	wire [7:0] mbc3_rom_bank = mbc_rom_bank[7:0] & rom_mask[7:0];
	assign mbc_addr = {1'b0, mbc3_rom_bank, cart_addr[13:0]};
	reg [7:0] cram_do_r;
	wire [7:0] rtc_return;
	always @(*) begin
		cram_do_r = 8'hff;
		if (mbc_ram_enable) begin
			if (mbc3_mode)
				cram_do_r = rtc_return;
			else if (has_ram)
				cram_do_r = cram_di;
		end
	end
	assign cram_do = cram_do_r;
	assign cram_addr = {1'b0, mbc3_ram_bank, cart_addr[12:0]};
	assign cart_oe = cart_rd & (~cart_a15 | ((is_cram_addr & mbc_ram_enable) & (mbc3_mode | has_ram)));
	assign has_battery = ((cart_mbc_type == 8'h0f) || (cart_mbc_type == 8'h10)) || (cart_mbc_type == 8'h13);
	assign ram_enabled = (mbc_ram_enable & ~mbc3_mode) & has_ram;
	reg [15:0] rtc_subseconds;
	reg [5:0] rtc_seconds;
	reg [5:0] rtc_seconds_latch;
	reg [5:0] rtc_minutes;
	reg [5:0] rtc_minutes_latch;
	reg [4:0] rtc_hours;
	reg [4:0] rtc_hours_latch;
	reg [9:0] rtc_days;
	reg [9:0] rtc_days_latch;
	reg rtc_overflow;
	reg rtc_overflow_latch;
	reg rtc_halt;
	wire rtc_subseconds_end = rtc_subseconds >= 32767;
	wire RTC_timestampNew = RTC_time[32];
	wire [31:0] RTC_timestampIn = RTC_time[31:0];
	reg [31:0] RTC_timestampSaved = 0;
	reg [31:0] RTC_savedtimeIn = 0;
	reg RTC_saveLoaded = 0;
	reg rtc_change;
	reg rtc_latch;
	reg RTC_saveLoaded_1;
	reg RTC_timestampNew_1;
	reg [31:0] diffSeconds;
	wire diffSeconds_fast_count = (diffSeconds > 0) && ~rtc_change;
	reg reset_1;
	always @(posedge clk_sys) begin
		reset_1 <= reset;
		if (!reset_1 && reset) begin
			rtc_halt <= 1'b0;
			RTC_inuse <= 1'b0;
			rtc_latch <= 1'b0;
		end
		else begin
			RTC_savedtimeOut[47:29] <= 0;
			if (rtc_change == 1'b0)
				RTC_savedtimeOut[28:0] <= {rtc_halt, rtc_overflow, rtc_days, rtc_hours, rtc_minutes, rtc_seconds};
			rtc_change <= 1'b0;
			if (ce_32k & ~rtc_halt)
				rtc_subseconds <= rtc_subseconds + 1'd1;
			if (mbc3_mode || ((bk_wr && enable) && img_size[9]))
				RTC_inuse <= 1'b1;
			RTC_saveLoaded <= 1'b0;
			if (bk_rtc_wr)
				case (bk_addr[7:0])
					0: RTC_timestampSaved[15:0] <= bk_data;
					1: RTC_timestampSaved[31:16] <= bk_data;
					2: RTC_savedtimeIn[15:0] <= bk_data;
					3: RTC_savedtimeIn[31:16] <= bk_data;
					4: RTC_saveLoaded <= 1'b1;
				endcase
			if (RTC_saveLoaded == 1'b1) begin
				if (RTC_timestampOut > RTC_timestampSaved)
					diffSeconds <= RTC_timestampOut - RTC_timestampSaved;
				rtc_seconds <= RTC_savedtimeIn[5:0];
				rtc_minutes <= RTC_savedtimeIn[11:6];
				rtc_hours <= RTC_savedtimeIn[16:12];
				rtc_days <= RTC_savedtimeIn[26:17];
				rtc_overflow <= RTC_savedtimeIn[27];
				rtc_halt <= RTC_savedtimeIn[28];
				RTC_inuse <= 1'b1;
			end
			else if (((ce_cpu && cart_wr) && is_cram_addr) && (mbc3_mode == 1'b1))
				case (rtc_index)
					0: begin
						rtc_seconds <= cart_di[5:0];
						rtc_subseconds <= 0;
					end
					1: rtc_minutes <= cart_di[5:0];
					2: rtc_hours <= cart_di[4:0];
					3: rtc_days[7:0] <= cart_di;
					4: begin
						rtc_days[8] <= cart_di[0];
						rtc_halt <= cart_di[6];
						rtc_overflow <= cart_di[7];
					end
				endcase
			else begin
				if (ce_32k & rtc_subseconds_end) begin
					rtc_subseconds <= 0;
					RTC_timestampOut <= RTC_timestampOut + 1'd1;
				end
				else if (diffSeconds_fast_count)
					diffSeconds <= diffSeconds - 1'd1;
				if ((ce_32k & rtc_subseconds_end) | diffSeconds_fast_count) begin
					if (~rtc_halt) begin
						rtc_change <= 1'b1;
						rtc_seconds <= rtc_seconds + 1'd1;
						if (rtc_seconds == 59) begin
							rtc_seconds <= 6'd0;
							rtc_minutes <= rtc_minutes + 1'd1;
							if (rtc_minutes == 59) begin
								rtc_minutes <= 6'd0;
								rtc_hours <= rtc_hours + 1'd1;
								if (rtc_hours == 23) begin
									rtc_hours <= 5'd0;
									rtc_days <= rtc_days + 1'd1;
									if (rtc_days == 511) begin
										rtc_days <= 10'd0;
										rtc_overflow <= 1'b1;
									end
								end
							end
						end
					end
				end
			end
			if ((((ce_cpu && cart_wr) && ~cart_a15) && (cart_addr[14:13] == 2'b11)) && ~|cart_di[7:1]) begin
				rtc_latch <= cart_di[0];
				if (~rtc_latch & cart_di[0]) begin
					rtc_seconds_latch <= rtc_seconds;
					rtc_minutes_latch <= rtc_minutes;
					rtc_hours_latch <= rtc_hours;
					rtc_days_latch <= rtc_days;
					rtc_overflow_latch <= rtc_overflow;
				end
			end
			RTC_timestampNew_1 <= RTC_timestampNew;
			if (RTC_timestampNew != RTC_timestampNew_1)
				RTC_timestampOut <= RTC_timestampIn;
		end
	end
	assign rtc_return = (rtc_index == 0 ? rtc_seconds_latch : (rtc_index == 1 ? rtc_minutes_latch : (rtc_index == 2 ? rtc_hours_latch : (rtc_index == 3 ? rtc_days_latch[7:0] : (rtc_index == 4 ? {rtc_overflow_latch, rtc_halt, 5'b00000, rtc_days_latch[8]} : 8'hff)))));
endmodule
module mbc5 (
	enable,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_wr,
	cart_di,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b,
	rumbling
);
	input enable;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back_b;
	input has_ram;
	input [3:0] ram_mask;
	input [8:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_wr;
	input [7:0] cart_di;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	output wire rumbling;
	wire [22:0] mbc_addr;
	wire ram_enabled;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire has_battery;
	wire [15:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 16'd0);
	reg [3:0] mbc_ram_bank_reg;
	assign rumbling = mbc_ram_bank_reg[3];
	wire [3:0] mbc5_ram_bank = mbc_ram_bank_reg & ram_mask;
	reg [8:0] mbc_rom_bank_reg;
	wire [8:0] mbc_rom_bank = (~cart_addr[14] ? 9'd0 : mbc_rom_bank_reg);
	wire [8:0] mbc5_rom_bank = mbc_rom_bank & rom_mask;
	reg mbc_ram_enable;
	assign savestate_back[8:0] = mbc_rom_bank_reg;
	assign savestate_back[12:9] = mbc_ram_bank_reg;
	assign savestate_back[14:13] = 0;
	assign savestate_back[15] = mbc_ram_enable;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			mbc_rom_bank_reg <= savestate_data[8:0];
			mbc_ram_bank_reg <= savestate_data[12:9];
			mbc_ram_enable <= savestate_data[15];
		end
		else if (~enable) begin
			mbc_rom_bank_reg <= 9'd1;
			mbc_ram_bank_reg <= 4'd0;
			mbc_ram_enable <= 1'b0;
		end
		else if (ce_cpu) begin
			if (cart_wr & ~cart_a15)
				case (cart_addr[14:13])
					2'b00: mbc_ram_enable <= cart_di == 8'h0a;
					2'b01:
						if (cart_addr[12])
							mbc_rom_bank_reg[8] <= cart_di[0];
						else
							mbc_rom_bank_reg[7:0] <= cart_di;
					2'b10: mbc_ram_bank_reg <= cart_di[3:0];
				endcase
		end
	assign mbc_addr = {mbc5_rom_bank, cart_addr[13:0]};
	assign ram_enabled = mbc_ram_enable & has_ram;
	assign cram_do = (ram_enabled ? cram_di : 8'hff);
	assign cram_addr = {mbc5_ram_bank, cart_addr[12:0]};
	assign has_battery = (cart_mbc_type == 8'h1b) || (cart_mbc_type == 8'h1e);
endmodule
module mbc6 (
	enable,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_wr,
	cart_di,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [63:0] savestate_data;
	output wire [63:0] savestate_back_b;
	input has_ram;
	input [1:0] ram_mask;
	input [5:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_wr;
	input [7:0] cart_di;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire ram_enabled;
	wire has_battery;
	wire [63:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 64'd0);
	reg [6:0] rom_bank_reg_a;
	reg [6:0] rom_bank_reg_b;
	reg [2:0] ram_bank_reg_a;
	reg [2:0] ram_bank_reg_b;
	reg ram_enable;
	assign savestate_back[6:0] = rom_bank_reg_a;
	assign savestate_back[13:7] = rom_bank_reg_b;
	assign savestate_back[16:14] = ram_bank_reg_a;
	assign savestate_back[19:17] = ram_bank_reg_b;
	assign savestate_back[20] = ram_enable;
	assign savestate_back[63:21] = 0;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			rom_bank_reg_a <= savestate_data[6:0];
			rom_bank_reg_b <= savestate_data[13:7];
			ram_bank_reg_a <= savestate_data[16:14];
			ram_bank_reg_b <= savestate_data[19:17];
			ram_enable <= savestate_data[20];
		end
		else if (~enable) begin
			rom_bank_reg_a <= 7'd0;
			rom_bank_reg_b <= 7'd0;
			ram_bank_reg_a <= 3'd0;
			ram_bank_reg_b <= 3'd0;
			ram_enable <= 1'b0;
		end
		else if (ce_cpu) begin
			if (cart_wr) begin
				if (~cart_a15 && !cart_addr[14:13])
					case (cart_addr[12:10])
						3'd0: ram_enable <= cart_di[3:0] == 4'ha;
						3'd1: ram_bank_reg_a <= cart_di[2:0];
						3'd2: ram_bank_reg_b <= cart_di[2:0];
						3'd3:
							;
						3'd4:
							;
						default:
							;
					endcase
				if (~cart_a15 && (cart_addr[14:13] == 2'b01))
					case (cart_addr[12:11])
						2'd0: rom_bank_reg_a <= cart_di[6:0];
						2'd1:
							;
						2'd2: rom_bank_reg_b <= cart_di[6:0];
						2'd3:
							;
					endcase
			end
		end
	reg [6:0] rom_bank;
	always @(*)
		if (~cart_addr[14])
			rom_bank = {6'd0, cart_addr[13]};
		else if (~cart_addr[13])
			rom_bank = rom_bank_reg_a;
		else
			rom_bank = rom_bank_reg_b;
	reg [2:0] ram_bank;
	always @(*)
		if (~cart_addr[12])
			ram_bank = ram_bank_reg_a;
		else
			ram_bank = ram_bank_reg_b;
	wire [6:0] rom_bank_m = rom_bank & {rom_mask[5:0], 1'b1};
	wire [2:0] ram_bank_m = ram_bank & {ram_mask[1:0], 1'b1};
	assign mbc_addr = {3'd0, rom_bank_m, cart_addr[12:0]};
	assign cram_do = (ram_enabled ? cram_di : 8'hff);
	assign cram_addr = {2'd0, ram_bank_m, cart_addr[11:0]};
	assign has_battery = has_ram;
	assign ram_enabled = ram_enable & has_ram;
endmodule
module mbc7 (
	enable,
	reset,
	clk_sys,
	ce_cpu,
	ce_1x,
	savestate_load,
	savestate_data,
	savestate_back_b,
	savestate_data2,
	savestate_back2_b,
	joystick_analog_x,
	joystick_analog_y,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_rd,
	cart_wr,
	cart_di,
	cart_oe_b,
	nCS,
	cram_di,
	cram_do_b,
	cram_addr_b,
	cram_wr_b,
	cram_wr_do_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input reset;
	input clk_sys;
	input ce_cpu;
	input ce_1x;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back_b;
	input [63:0] savestate_data2;
	output wire [63:0] savestate_back2_b;
	input [7:0] joystick_analog_x;
	input [7:0] joystick_analog_y;
	input has_ram;
	input [3:0] ram_mask;
	input [8:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_rd;
	input cart_wr;
	input [7:0] cart_di;
	output wire cart_oe_b;
	input nCS;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire cram_wr_b;
	output wire [7:0] cram_wr_do_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire cart_oe;
	wire ram_enabled;
	wire has_battery;
	wire [15:0] savestate_back;
	wire [63:0] savestate_back2;
	wire [7:0] cram_wr_do;
	wire cram_wr;
	wire is_cram_addr = ~nCS & ~cart_addr[14];
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign cart_oe_b = (enable ? cart_oe : 1'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 16'd0);
	assign savestate_back2_b = (enable ? savestate_back2 : 64'd0);
	assign cram_wr_do_b = (enable ? cram_wr_do : 8'd0);
	assign cram_wr_b = (enable ? cram_wr : 1'd0);
	reg [6:0] rom_bank_reg;
	reg ram_enable1;
	reg ram_enable2;
	reg [15:0] accelerometer_x;
	reg [15:0] accelerometer_y;
	reg accel_latched;
	reg eeprom_di;
	reg eeprom_clk;
	reg eeprom_cs;
	wire ram_reg_en = ram_enable1 & ram_enable2;
	wire ram_reg_sel = is_cram_addr & ~cart_addr[12];
	assign savestate_back[6:0] = rom_bank_reg;
	assign savestate_back[7] = ram_enable1;
	assign savestate_back[8] = ram_enable2;
	assign savestate_back[9] = eeprom_di;
	assign savestate_back[10] = eeprom_clk;
	assign savestate_back[11] = eeprom_cs;
	assign savestate_back[15:12] = 0;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			rom_bank_reg <= savestate_data[6:0];
			ram_enable1 <= savestate_data[7];
			ram_enable2 <= savestate_data[8];
			eeprom_di <= savestate_data[9];
			eeprom_clk <= savestate_data[10];
			eeprom_cs <= savestate_data[11];
		end
		else if (~enable) begin
			rom_bank_reg <= 7'd1;
			ram_enable1 <= 1'b0;
			ram_enable2 <= 1'b0;
			accel_latched <= 1'b0;
			accelerometer_x <= 16'h8000;
			accelerometer_y <= 16'h8000;
			eeprom_di <= 1'b0;
			eeprom_clk <= 1'b0;
			eeprom_cs <= 1'b0;
		end
		else if (ce_cpu) begin
			if (cart_wr) begin
				if (~cart_a15)
					case (cart_addr[14:13])
						2'b00: ram_enable1 <= cart_di[3:0] == 4'ha;
						2'b01: rom_bank_reg <= cart_di[6:0];
						2'b10: ram_enable2 <= cart_di == 8'h40;
					endcase
				if (ram_reg_en & ram_reg_sel)
					case (cart_addr[7:4])
						0:
							if (cart_di == 8'h55) begin
								accel_latched <= 1'b0;
								accelerometer_x <= 16'h8000;
								accelerometer_y <= 16'h8000;
							end
						1:
							if ((cart_di == 8'haa) && ~accel_latched) begin
								accel_latched <= 1'b1;
								accelerometer_x <= 16'h81d0 - $signed(joystick_analog_x);
								accelerometer_y <= 16'h81d0 - $signed(joystick_analog_y);
							end
						8: {eeprom_cs, eeprom_clk, eeprom_di} <= {cart_di[7:6], cart_di[1]};
					endcase
			end
		end
	wire [7:0] cram_addr_e;
	wire eeprom_do;
	eeprom93LC56 eeprom(
		.enable(enable),
		.clk_sys(clk_sys),
		.ce(ce_1x),
		.data_clk(eeprom_clk),
		.data_in(eeprom_di),
		.cs(eeprom_cs),
		.ram_di(cram_di),
		.ram_addr(cram_addr_e),
		.ram_wr(cram_wr),
		.ram_do(cram_wr_do),
		.data_out(eeprom_do),
		.savestate_load(savestate_load),
		.savestate_data(savestate_data2),
		.savestate_back(savestate_back2)
	);
	reg [7:0] cram_do_r;
	always @(*) begin
		cram_do_r = 8'hff;
		if (ram_reg_en & ram_reg_sel)
			case (cart_addr[7:4])
				2: cram_do_r = accelerometer_x[7:0];
				3: cram_do_r = accelerometer_x[15:8];
				4: cram_do_r = accelerometer_y[7:0];
				5: cram_do_r = accelerometer_y[15:8];
				6: cram_do_r = 8'h00;
				7: cram_do_r = 8'hff;
				8: {cram_do_r[7:6], cram_do_r[1:0]} = {eeprom_cs, eeprom_clk, eeprom_di, eeprom_do};
				default:
					;
			endcase
	end
	wire [6:0] rom_bank = (~cart_addr[14] ? 7'd0 : rom_bank_reg);
	wire [6:0] rom_bank_m = rom_bank & rom_mask[6:0];
	assign mbc_addr = {2'b00, rom_bank_m, cart_addr[13:0]};
	assign cram_do = cram_do_r;
	assign cram_addr = {9'd0, cram_addr_e};
	assign cart_oe = cart_rd & (~cart_a15 | (ram_reg_en & ram_reg_sel));
	assign has_battery = 1;
	assign ram_enabled = 0;
endmodule
module eeprom93LC56 (
	enable,
	clk_sys,
	ce,
	data_clk,
	data_in,
	cs,
	ram_di,
	ram_addr,
	ram_do,
	ram_wr,
	data_out,
	savestate_load,
	savestate_data,
	savestate_back
);
	input enable;
	input clk_sys;
	input ce;
	input data_clk;
	input data_in;
	input cs;
	input [7:0] ram_di;
	output wire [7:0] ram_addr;
	output wire [7:0] ram_do;
	output wire ram_wr;
	output wire data_out;
	input savestate_load;
	input [63:0] savestate_data;
	output wire [63:0] savestate_back;
	reg old_data_clk;
	reg old_cs;
	reg [9:0] command;
	reg command_start;
	reg command_run;
	reg command_init;
	reg [4:0] data_clk_cnt;
	reg [16:0] data;
	reg write_en;
	reg writing;
	reg [7:0] rw_cnt;
	reg [7:0] ram_addr_r;
	reg [7:0] ram_do_r;
	reg ram_wr_r;
	wire command_write = command[9:8] == 2'b01;
	wire command_read = command[9:8] == 2'b10;
	wire command_erase = command[9:8] == 2'b11;
	wire command_ewds = command[9:6] == 4'b0000;
	wire command_wral = command[9:6] == 4'b0001;
	wire command_eral = command[9:6] == 4'b0010;
	wire command_ewen = command[9:6] == 4'b0011;
	assign savestate_back[0] = old_data_clk;
	assign savestate_back[1] = old_cs;
	assign savestate_back[11:2] = command;
	assign savestate_back[12] = command_start;
	assign savestate_back[13] = command_run;
	assign savestate_back[14] = command_init;
	assign savestate_back[19:15] = data_clk_cnt;
	assign savestate_back[36:20] = data;
	assign savestate_back[37] = write_en;
	assign savestate_back[38] = writing;
	assign savestate_back[46:39] = rw_cnt;
	assign savestate_back[54:47] = ram_addr_r;
	assign savestate_back[62:55] = ram_do_r;
	assign savestate_back[63] = ram_wr_r;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			old_data_clk <= savestate_data[0];
			old_cs <= savestate_data[1];
			command <= savestate_data[11:2];
			command_start <= savestate_data[12];
			command_run <= savestate_data[13];
			command_init <= savestate_data[14];
			data_clk_cnt <= savestate_data[19:15];
			data <= savestate_data[36:20];
			write_en <= savestate_data[37];
			writing <= savestate_data[38];
			rw_cnt <= savestate_data[46:39];
			ram_addr_r <= savestate_data[54:47];
			ram_do_r <= savestate_data[62:55];
			ram_wr_r <= savestate_data[63];
		end
		else if (~enable) begin
			old_data_clk <= 0;
			old_cs <= 0;
			command <= 0;
			command_start <= 0;
			command_run <= 0;
			command_init <= 0;
			data_clk_cnt <= 0;
			write_en <= 0;
			writing <= 0;
			ram_wr_r <= 0;
		end
		else if (ce) begin
			old_data_clk <= data_clk;
			old_cs <= cs;
			if (~cs) begin
				command_start <= 0;
				command_run <= 0;
				command_init <= 0;
			end
			else begin
				if (~old_data_clk & data_clk) begin
					data_clk_cnt <= data_clk_cnt + 1'b1;
					if ((~command_start & data_in) & ~writing) begin
						command_start <= 1;
						data_clk_cnt <= 0;
					end
					if (command_start & ~command_run) begin
						command <= {command[8:0], data_in};
						if (data_clk_cnt == 9) begin
							data_clk_cnt <= 0;
							command_run <= 1;
							command_init <= 1;
						end
					end
					if (command_run) begin
						if (command_read) begin
							data <= {data[15:0], 1'b0};
							if (data_clk_cnt == 15) begin
								data_clk_cnt <= 0;
								rw_cnt <= 0;
								command[6:0] <= command[6:0] + 1'b1;
							end
						end
						if (command_write | command_wral)
							data <= {data[15:0], data_in};
					end
				end
				if (command_init) begin
					command_init <= 0;
					if (command_ewds)
						write_en <= 0;
					if (command_ewen)
						write_en <= 1;
					if (command_read) begin
						rw_cnt <= 0;
						data[16] <= 1'b0;
					end
				end
				if (command_run) begin
					if (command_read && (rw_cnt <= 2)) begin
						ram_addr_r <= {command[6:0], rw_cnt[0]};
						case (rw_cnt)
							1: data[15:8] <= ram_di;
							2: data[7:0] <= ram_di;
							default:
								;
						endcase
						rw_cnt <= rw_cnt + 1'b1;
					end
				end
			end
			if ((old_cs & ~cs) & write_en) begin
				if ((command_erase | command_eral) || ((command_write | command_wral) && (data_clk_cnt == 16))) begin
					writing <= 1;
					rw_cnt <= 0;
				end
			end
			ram_wr_r <= 0;
			if (writing) begin
				ram_wr_r <= 1;
				ram_addr_r <= (command_wral | command_eral ? rw_cnt : {command[6:0], rw_cnt[0]});
				ram_do_r <= (command_erase | command_eral ? 8'hff : (rw_cnt[0] ? data[7:0] : data[15:8]));
				rw_cnt <= rw_cnt + 1'b1;
				if (rw_cnt == (command_wral | command_eral ? 255 : 1))
					writing <= 0;
			end
		end
	assign ram_addr = ram_addr_r;
	assign ram_do = ram_do_r;
	assign ram_wr = ram_wr_r;
	assign data_out = (command_run & command_read ? data[16] : ~writing);
endmodule
module megaduck (
	enable,
	duck_md0_mode,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_wr,
	cart_di,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input duck_md0_mode;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back_b;
	input has_ram;
	input [1:0] ram_mask;
	input [6:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_wr;
	input [7:0] cart_di;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire ram_enabled;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire has_battery;
	wire [15:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 16'd0);
	reg [7:0] bank_top;
	reg [7:0] bank_bottom;
	reg [1:0] ram_bank;
	wire [7:0] rom_bank = (cart_addr[14] ? bank_top : bank_bottom);
	wire [1:0] duck_ram_bank = ram_bank & ram_mask[1:0];
	wire duck_ram_enabled = duck_md0_mode & has_ram;
	wire [16:0] duck_cram_addr = {2'b00, duck_ram_bank, cart_addr[12:0]};
	wire duck_bank_write = (cart_wr & ~cart_a15) & (cart_addr == 15'h0001);
	wire duck_pair_write = (cart_wr & cart_a15) & ~cart_addr[14];
	wire duck_md0_bank_write = (cart_wr & ~cart_a15) & (cart_addr == 15'h1000);
	wire [7:0] savestate_bank_bottom = (duck_md0_mode ? {bank_bottom[7:1], ram_bank[0]} : bank_bottom);
	wire [7:0] savestate_bank_top = (duck_md0_mode ? {bank_top[7:1], ram_bank[1]} : bank_top);
	assign savestate_back[7:0] = savestate_bank_bottom;
	assign savestate_back[15:8] = savestate_bank_top;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			if (duck_md0_mode) begin
				bank_bottom <= {savestate_data[7:1], 1'b0};
				bank_top <= {savestate_data[15:9], 1'b1};
				ram_bank <= {savestate_data[8], savestate_data[0]};
			end
			else begin
				bank_bottom <= savestate_data[7:0];
				bank_top <= savestate_data[15:8];
				ram_bank <= 2'd0;
			end
		end
		else if (~enable) begin
			bank_bottom <= 8'd0;
			bank_top <= 8'd1;
			ram_bank <= 2'd0;
		end
		else if (ce_cpu) begin
			if (duck_md0_mode) begin
				if (duck_md0_bank_write) begin
					bank_top <= {3'd0, cart_di[3:0], 1'b1};
					bank_bottom <= {3'd0, cart_di[3:0], 1'b0};
					ram_bank <= cart_di[5:4];
				end
			end
			else if (duck_bank_write)
				bank_top <= (cart_di[7:0] == 0 ? 8'd1 : cart_di);
			else if (duck_pair_write) begin
				bank_top <= {cart_di[6:0], 1'b1};
				bank_bottom <= {cart_di[6:0], 1'b0};
			end
		end
	assign mbc_addr = {1'b0, rom_bank, cart_addr[13:0]};
	assign ram_enabled = duck_ram_enabled;
	assign cram_do = (ram_enabled ? cram_di : 8'hff);
	assign cram_addr = (ram_enabled ? duck_cram_addr : 17'd0);
	assign has_battery = duck_ram_enabled;
endmodule
module misc_mapper (
	enable,
	clk_sys,
	ce_cpu,
	mapper_sel,
	savestate_load,
	savestate_data,
	savestate_back_b,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_wr,
	cart_di,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input clk_sys;
	input ce_cpu;
	input mapper_sel;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back_b;
	input [8:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input cart_wr;
	input [7:0] cart_di;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire ram_enabled;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire has_battery;
	wire [15:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 16'd0);
	reg [7:0] rom_bank_reg;
	reg map_disable;
	assign savestate_back[7:0] = rom_bank_reg;
	assign savestate_back[8] = map_disable;
	assign savestate_back[15:9] = 0;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			rom_bank_reg <= savestate_data[7:0];
			map_disable <= savestate_data[8];
		end
		else if (~enable) begin
			rom_bank_reg <= 8'd0;
			map_disable <= 1'b0;
		end
		else if (ce_cpu) begin
			if (cart_wr & ~cart_a15) begin
				if (mapper_sel) begin
					if (~map_disable) begin
						rom_bank_reg <= {5'd0, cart_di[2:0]};
						map_disable <= 1'b1;
					end
				end
				else
					rom_bank_reg <= cart_addr[7:0];
			end
		end
	wire [7:0] rom_bank = rom_bank_reg & rom_mask[8:1];
	assign mbc_addr = {rom_bank, cart_addr[14:0]};
	assign cram_do = 8'hff;
	assign cram_addr = {4'b0000, cart_addr[12:0]};
	assign ram_enabled = 0;
	assign has_battery = 0;
endmodule
module mmm01 (
	enable,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_wr,
	cart_di,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [63:0] savestate_data;
	output wire [63:0] savestate_back_b;
	input has_ram;
	input [3:0] ram_mask;
	input [8:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_wr;
	input [7:0] cart_di;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire ram_enabled;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire has_battery;
	wire [63:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 64'd0);
	reg [8:0] rom_bank_reg;
	reg [3:0] ram_bank_reg;
	reg [3:0] rom_bank_we_n_18_15;
	reg [1:0] ram_bank_we_n_14_13;
	reg ram_enable;
	reg map_en;
	reg mbc1_mode;
	reg mbc1_mode_we_n;
	reg rom_mux;
	assign savestate_back[8:0] = rom_bank_reg;
	assign savestate_back[12:9] = ram_bank_reg;
	assign savestate_back[16:13] = rom_bank_we_n_18_15;
	assign savestate_back[18:17] = ram_bank_we_n_14_13;
	assign savestate_back[19] = ram_enable;
	assign savestate_back[20] = map_en;
	assign savestate_back[21] = mbc1_mode;
	assign savestate_back[22] = mbc1_mode_we_n;
	assign savestate_back[23] = rom_mux;
	assign savestate_back[63:24] = 0;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			rom_bank_reg <= savestate_data[8:0];
			ram_bank_reg <= savestate_data[12:9];
			rom_bank_we_n_18_15 <= savestate_data[16:13];
			ram_bank_we_n_14_13 <= savestate_data[18:17];
			ram_enable <= savestate_data[19];
			map_en <= savestate_data[20];
			mbc1_mode <= savestate_data[21];
			mbc1_mode_we_n <= savestate_data[22];
			rom_mux <= savestate_data[23];
		end
		else if (~enable) begin
			rom_bank_reg <= 9'd0;
			ram_bank_reg <= 4'd0;
			rom_bank_we_n_18_15 <= 4'd0;
			ram_bank_we_n_14_13 <= 2'd0;
			ram_enable <= 1'd0;
			map_en <= 1'd0;
			mbc1_mode <= 1'd0;
			mbc1_mode_we_n <= 1'd0;
			rom_mux <= 1'd0;
		end
		else if (ce_cpu) begin
			if (cart_wr & ~cart_a15)
				case (cart_addr[14:13])
					2'b00: begin
						ram_enable <= cart_di[3:0] == 4'ha;
						if (~map_en) begin
							ram_bank_we_n_14_13 <= cart_di[5:4];
							map_en <= cart_di[6];
						end
					end
					2'b01: begin
						rom_bank_reg[0] <= cart_di[0];
						if (~rom_bank_we_n_18_15[0])
							rom_bank_reg[1] <= cart_di[1];
						if (~rom_bank_we_n_18_15[1])
							rom_bank_reg[2] <= cart_di[2];
						if (~rom_bank_we_n_18_15[2])
							rom_bank_reg[3] <= cart_di[3];
						if (~rom_bank_we_n_18_15[3])
							rom_bank_reg[4] <= cart_di[4];
						if (~map_en)
							rom_bank_reg[6:5] <= cart_di[6:5];
					end
					2'b10: begin
						if (~ram_bank_we_n_14_13[0])
							ram_bank_reg[0] <= cart_di[0];
						if (~ram_bank_we_n_14_13[1])
							ram_bank_reg[1] <= cart_di[1];
						if (~map_en) begin
							ram_bank_reg[3:2] <= cart_di[3:2];
							rom_bank_reg[8:7] <= cart_di[5:4];
							mbc1_mode_we_n <= cart_di[6];
						end
					end
					2'b11: begin
						if (~mbc1_mode_we_n)
							mbc1_mode <= cart_di[0];
						if (~map_en) begin
							rom_bank_we_n_18_15 <= cart_di[5:2];
							rom_mux <= cart_di[6];
						end
					end
				endcase
		end
	wire [1:0] mbc1_bank2 = (~mbc1_mode & ~cart_addr[14] ? 2'd0 : ram_bank_reg[1:0]);
	wire [3:0] ram_bank = {ram_bank_reg[3:2], (rom_mux ? rom_bank_reg[6:5] : mbc1_bank2)};
	wire [4:0] rom_bank_low_m = {rom_bank_reg[4:1] & ~rom_bank_we_n_18_15, rom_bank_reg[0]};
	reg [8:0] rom_bank;
	always @(*) begin
		rom_bank[8:7] = rom_bank_reg[8:7];
		rom_bank[6:5] = (rom_mux ? mbc1_bank2 : rom_bank_reg[6:5]);
		rom_bank[4:0] = rom_bank_reg[4:0];
		if (~cart_addr[14]) begin
			rom_bank[4:1] = rom_bank_reg[4:1] & rom_bank_we_n_18_15;
			rom_bank[0] = 1'b0;
		end
		else if (rom_bank_low_m == 5'd0)
			rom_bank[0] = 1'b1;
		if (~map_en)
			rom_bank[8:1] = 8'hff;
	end
	wire [8:0] rom_bank_m = rom_bank & rom_mask;
	wire [3:0] ram_bank_m = ram_bank & ram_mask;
	assign mbc_addr = {rom_bank_m, cart_addr[13:0]};
	assign ram_enabled = ram_enable & has_ram;
	assign cram_do = (ram_enabled ? cram_di : 8'hff);
	assign cram_addr = {4'd0, ram_bank_m, cart_addr[8:0]};
	assign has_battery = cart_mbc_type == 8'h0d;
endmodule
module rocket (
	enable,
	clk_sys,
	ce_cpu,
	savestate_load,
	savestate_data,
	savestate_back_b,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_wr,
	cart_di,
	rom_di,
	rom_do_b,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input clk_sys;
	input ce_cpu;
	input savestate_load;
	input [15:0] savestate_data;
	output wire [15:0] savestate_back_b;
	input has_ram;
	input [1:0] ram_mask;
	input [4:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_wr;
	input [7:0] cart_di;
	input [7:0] rom_di;
	output wire [7:0] rom_do_b;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire [7:0] rom_do;
	wire ram_enabled;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire has_battery;
	wire [15:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign rom_do_b = (enable ? rom_do : 8'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 16'd0);
	reg [3:0] rom_bank_reg;
	reg rom_outer_bank;
	reg header_end;
	reg prev_a15;
	reg [5:0] a15_cnt;
	assign savestate_back[3:0] = rom_bank_reg;
	assign savestate_back[4] = rom_outer_bank;
	assign savestate_back[5] = header_end;
	assign savestate_back[6] = prev_a15;
	assign savestate_back[12:7] = a15_cnt;
	assign savestate_back[15:13] = 0;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			rom_bank_reg <= savestate_data[3:0];
			rom_outer_bank <= savestate_data[4];
			header_end <= savestate_data[5];
			prev_a15 <= savestate_data[6];
			a15_cnt <= savestate_data[12:7];
		end
		else if (~enable) begin
			rom_bank_reg <= 4'd1;
			rom_outer_bank <= 1'b0;
			header_end <= 1'b0;
			prev_a15 <= 1'b1;
			a15_cnt <= 6'd0;
		end
		else if (ce_cpu) begin
			if (cart_wr & ~cart_a15) begin
				if (cart_addr[14:13] == 2'b01) begin
					if (&cart_addr[7:6])
						rom_outer_bank <= cart_di[0];
					else
						rom_bank_reg <= (cart_di[3:0] == 0 ? 4'd1 : cart_di[3:0]);
				end
			end
			prev_a15 <= cart_a15;
			if ((~prev_a15 & cart_a15) & ~header_end) begin
				a15_cnt <= a15_cnt + 1'b1;
				if (a15_cnt == 6'd47)
					header_end <= 1'b1;
			end
		end
	wire [415:0] header_xor = 416'hdfce9778cd2ff00b0bea7883081d9a45112be111f888f88efe882ac4fffcd98722ab677d772ca8eeff9b9991aa9b333e;
	wire [3:0] rom_bank_a = (~cart_addr[14] ? 4'd0 : rom_bank_reg);
	wire [4:0] rom_bank = {rom_outer_bank, rom_bank_a};
	wire [4:0] rom_bank_m = rom_bank & rom_mask[4:0];
	assign mbc_addr = {4'b0000, rom_bank_m, cart_addr[13:0]};
	assign rom_do = (~header_end ? rom_di ^ header_xor[(51 - cart_addr[5:0]) * 8+:8] : rom_di);
	assign cram_do = 8'hff;
	assign cram_addr = {4'b0000, cart_addr[12:0]};
	assign ram_enabled = 0;
	assign has_battery = 0;
endmodule
module sachen (
	enable,
	clk_sys,
	ce_cpu,
	isGBC_game,
	savestate_load,
	savestate_data,
	savestate_back_b,
	cart_addr,
	cart_a15,
	cart_wr,
	cart_di,
	nCS,
	cram_di,
	cram_do_b,
	cram_addr_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input clk_sys;
	input ce_cpu;
	input isGBC_game;
	input savestate_load;
	input [63:0] savestate_data;
	output wire [63:0] savestate_back_b;
	input [14:0] cart_addr;
	input cart_a15;
	input cart_wr;
	input [7:0] cart_di;
	input nCS;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire ram_enabled;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire has_battery;
	wire [63:0] savestate_back;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 64'd0);
	reg [7:0] rom_bank_reg;
	reg [7:0] base_rom_bank;
	reg [7:0] rom_bank_mask;
	reg header_end;
	reg prev_a15;
	reg prev_nCS;
	reg [5:0] a15_cnt;
	reg a7_set;
	reg init;
	wire map_wr_en = &rom_bank_reg[5:4];
	assign savestate_back[7:0] = rom_bank_reg;
	assign savestate_back[15:8] = base_rom_bank;
	assign savestate_back[23:16] = rom_bank_mask;
	assign savestate_back[24] = header_end;
	assign savestate_back[25] = prev_a15;
	assign savestate_back[26] = prev_nCS;
	assign savestate_back[32:27] = a15_cnt;
	assign savestate_back[33] = a7_set;
	assign savestate_back[34] = init;
	assign savestate_back[63:35] = 0;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			rom_bank_reg <= savestate_data[7:0];
			base_rom_bank <= savestate_data[15:8];
			rom_bank_mask <= savestate_data[23:16];
			header_end <= savestate_data[24];
			prev_a15 <= savestate_data[25];
			prev_nCS <= savestate_data[26];
			a15_cnt <= savestate_data[32:27];
			a7_set <= savestate_data[33];
			init <= savestate_data[34];
		end
		else if (~enable) begin
			rom_bank_reg <= 8'd1;
			base_rom_bank <= 8'd0;
			rom_bank_mask <= 8'd0;
			header_end <= 1'b0;
			prev_a15 <= 1'b1;
			prev_nCS <= 1'b1;
			a15_cnt <= 6'd0;
			a7_set <= 1'b0;
			init <= 1'b0;
		end
		else if (ce_cpu) begin
			if (cart_wr & ~cart_a15)
				case (cart_addr[14:13])
					2'b00:
						if (map_wr_en)
							base_rom_bank <= cart_di[7:0];
					2'b01: rom_bank_reg <= (cart_di[7:0] == 0 ? 8'd1 : cart_di[7:0]);
					2'b10:
						if (map_wr_en)
							rom_bank_mask <= cart_di[7:0];
					default:
						;
				endcase
			if (~init) begin
				init <= 1'b1;
				a7_set <= ~isGBC_game;
			end
			prev_a15 <= cart_a15;
			if ((~prev_a15 & cart_a15) & ~header_end) begin
				a15_cnt <= a15_cnt + 1'b1;
				if (a15_cnt == 6'd47) begin
					a7_set <= ~a7_set;
					if (~a7_set)
						a15_cnt <= 0;
					if (a7_set)
						header_end <= 1'b1;
				end
			end
			prev_nCS <= nCS;
			if (((isGBC_game & ~header_end) & ~prev_nCS) & nCS) begin
				a7_set <= 1'b1;
				a15_cnt <= 0;
			end
		end
	wire [7:0] rom_bank_a = (~cart_addr[14] ? 8'd0 : rom_bank_reg);
	wire [7:0] rom_bank = (rom_bank_a & ~rom_bank_mask) | (base_rom_bank & rom_bank_mask);
	wire header_read = (~cart_a15 && !cart_addr[14:9]) && cart_addr[8];
	wire [6:0] header_addr = {cart_addr[0], cart_addr[5], cart_addr[1], cart_addr[3:2], cart_addr[4], cart_addr[6]};
	assign mbc_addr[22] = 0;
	assign mbc_addr[21:14] = rom_bank;
	assign mbc_addr[13:8] = cart_addr[13:8];
	assign mbc_addr[7] = cart_addr[7] | a7_set;
	assign mbc_addr[6:0] = (header_read ? header_addr : cart_addr[6:0]);
	assign cram_do = 8'hff;
	assign cram_addr = {4'd0, cart_addr[12:0]};
	assign ram_enabled = 0;
	assign has_battery = 0;
endmodule
module tama (
	enable,
	clk_sys,
	ce_cpu,
	ce_32k,
	savestate_load,
	savestate_data,
	savestate_back_b,
	has_ram,
	ram_mask,
	rom_mask,
	cart_addr,
	cart_a15,
	cart_mbc_type,
	cart_rd,
	cart_wr,
	cart_di,
	cart_oe_b,
	nCS,
	cram_rd,
	cram_di,
	cram_do_b,
	cram_addr_b,
	cram_wr_b,
	cram_wr_do_b,
	mbc_addr_b,
	ram_enabled_b,
	has_battery_b
);
	input enable;
	input clk_sys;
	input ce_cpu;
	input ce_32k;
	input savestate_load;
	input [63:0] savestate_data;
	output wire [63:0] savestate_back_b;
	input has_ram;
	input [3:0] ram_mask;
	input [8:0] rom_mask;
	input [14:0] cart_addr;
	input cart_a15;
	input [7:0] cart_mbc_type;
	input cart_rd;
	input cart_wr;
	input [7:0] cart_di;
	output wire cart_oe_b;
	input nCS;
	input cram_rd;
	input [7:0] cram_di;
	output wire [7:0] cram_do_b;
	output wire [16:0] cram_addr_b;
	output wire cram_wr_b;
	output wire [7:0] cram_wr_do_b;
	output wire [22:0] mbc_addr_b;
	output wire ram_enabled_b;
	output wire has_battery_b;
	wire [22:0] mbc_addr;
	wire ram_enabled;
	wire [7:0] cram_do;
	wire [16:0] cram_addr;
	wire has_battery;
	wire [63:0] savestate_back;
	wire [7:0] cram_wr_do;
	wire cram_wr;
	wire cart_oe;
	assign mbc_addr_b = (enable ? mbc_addr : 23'd0);
	assign cram_do_b = (enable ? cram_do : 8'd0);
	assign cram_addr_b = (enable ? cram_addr : 17'd0);
	assign ram_enabled_b = (enable ? ram_enabled : 1'd0);
	assign has_battery_b = (enable ? has_battery : 1'd0);
	assign savestate_back_b = (enable ? savestate_back : 64'd0);
	assign cram_wr_do_b = (enable ? cram_wr_do : 8'd0);
	assign cram_wr_b = (enable ? cram_wr : 1'd0);
	assign cart_oe_b = (enable ? cart_oe : 1'd0);
	reg unlocked;
	reg [3:0] reg_index;
	reg [4:0] rom_bank_reg;
	reg [7:0] reg_data_in;
	reg [7:0] reg_data_out;
	reg [4:0] reg_addr;
	reg ram_read;
	reg [1:0] rtc_sel;
	reg reg_start;
	reg cram_wr_r;
	reg ram_io;
	reg prev_cram_rd;
	reg prev_cart_wr;
	reg [6:0] rtc_seconds;
	reg [14:0] rtc_subseconds;
	reg [6:0] rtc_minutes;
	reg [5:0] rtc_hours;
	reg [5:0] rtc_days;
	reg [4:0] rtc_month;
	reg [7:0] rtc_year;
	reg rtc_24hours;
	reg [3:0] rtc_index;
	reg [1:0] rtc_leap_year;
	wire sec_inc = &rtc_subseconds;
	reg [5:0] days_in_month;
	always @(*)
		case (rtc_month)
			5'h04, 5'h06, 5'h09, 5'h11: days_in_month = 6'h30;
			5'h02: days_in_month = (rtc_leap_year == 2'b00 ? 6'h29 : 6'h28);
			default: days_in_month = 6'h31;
		endcase
	assign savestate_back[4:0] = rom_bank_reg;
	assign savestate_back[5] = unlocked;
	assign savestate_back[9:6] = reg_index;
	assign savestate_back[17:10] = reg_data_in;
	assign savestate_back[25:18] = reg_data_out;
	assign savestate_back[30:26] = reg_addr;
	assign savestate_back[31] = ram_read;
	assign savestate_back[33:32] = rtc_sel;
	assign savestate_back[34] = reg_start;
	assign savestate_back[35] = cram_wr_r;
	assign savestate_back[36] = ram_io;
	assign savestate_back[37] = prev_cram_rd;
	assign savestate_back[38] = prev_cart_wr;
	assign savestate_back[63:39] = 0;
	always @(posedge clk_sys)
		if (savestate_load & enable) begin
			rom_bank_reg <= savestate_data[4:0];
			unlocked <= savestate_data[5];
			reg_index <= savestate_data[9:6];
			reg_data_in <= savestate_data[17:10];
			reg_data_out <= savestate_data[25:18];
			reg_addr <= savestate_data[30:26];
			ram_read <= savestate_data[31];
			rtc_sel <= savestate_data[33:32];
			reg_start <= savestate_data[34];
			cram_wr_r <= savestate_data[35];
			ram_io <= savestate_data[36];
			prev_cram_rd <= savestate_data[37];
			prev_cart_wr <= savestate_data[38];
		end
		else if (~enable) begin
			rom_bank_reg <= 5'd0;
			unlocked <= 1'd0;
			reg_index <= 4'd0;
			reg_data_in <= 8'd0;
			reg_data_out <= 8'd0;
			reg_addr <= 5'd0;
			ram_read <= 1'd0;
			rtc_sel <= 2'd0;
			reg_start <= 1'd0;
			cram_wr_r <= 1'd0;
			ram_io <= 1'd0;
			prev_cram_rd <= 1'd0;
			prev_cart_wr <= 1'd0;
		end
		else begin
			if (ce_cpu) begin
				prev_cart_wr <= cart_wr;
				if (((prev_cart_wr & ~cart_wr) & ~nCS) & ~cart_addr[14]) begin
					if (cart_addr[0]) begin
						reg_index <= cart_di[3:0];
						if (cart_di[3:0] == 4'ha)
							unlocked <= 1'b1;
					end
					else if (unlocked)
						case (reg_index)
							4'd0: rom_bank_reg[3:0] <= cart_di[3:0];
							4'd1: rom_bank_reg[4] <= cart_di[0];
							4'd4: reg_data_in[3:0] <= cart_di[3:0];
							4'd5: reg_data_in[7:4] <= cart_di[3:0];
							4'd6: {rtc_sel, ram_read, reg_addr[4]} <= cart_di[3:0];
							4'd7: begin
								reg_addr[3:0] <= cart_di[3:0];
								reg_start <= 1'b1;
							end
							default:
								;
						endcase
				end
			end
			if (ce_32k) begin
				rtc_subseconds <= rtc_subseconds + 1'b1;
				if (sec_inc) begin
					rtc_seconds[3:0] <= rtc_seconds[3:0] + 1'b1;
					if (rtc_seconds[3:0] == 4'h9) begin
						rtc_seconds[3:0] <= 0;
						rtc_seconds[6:4] <= rtc_seconds[6:4] + 1'b1;
						if (rtc_seconds[6:4] == 3'h5) begin
							rtc_seconds[6:4] <= 0;
							rtc_minutes[3:0] <= rtc_minutes[3:0] + 1'b1;
							if (rtc_minutes[3:0] == 4'h9) begin
								rtc_minutes[3:0] <= 0;
								rtc_minutes[6:4] <= rtc_minutes[6:4] + 1'b1;
								if (rtc_minutes[6:4] == 3'h5) begin
									rtc_minutes[6:4] <= 0;
									rtc_hours[3:0] <= rtc_hours[3:0] + 1'b1;
									if (rtc_24hours & (rtc_hours[5:0] == 6'h23))
										rtc_hours[5:0] <= 0;
									else if (~rtc_24hours & (rtc_hours[4:0] == 5'h12))
										rtc_hours[4:0] <= 5'h01;
									else if (rtc_hours[3:0] == 4'h9) begin
										rtc_hours[3:0] <= 0;
										rtc_hours[5:4] <= rtc_hours[5:4] + 1'b1;
									end
									if (~rtc_24hours & (rtc_hours[4:0] == 5'h11))
										rtc_hours[5] <= ~rtc_hours[5];
									if ((rtc_24hours & (rtc_hours[5:0] == 6'h23)) || ((~rtc_24hours & rtc_hours[5]) & (rtc_hours[4:0] == 5'h11))) begin
										rtc_days[3:0] <= rtc_days[3:0] + 1'b1;
										if (rtc_days[3:0] == 4'h9) begin
											rtc_days[3:0] <= 0;
											rtc_days[5:4] <= rtc_days[5:4] + 1'b1;
										end
										if (rtc_days[5:0] == days_in_month) begin
											rtc_days <= 6'h01;
											rtc_month[3:0] <= rtc_month[3:0] + 1'b1;
											if (rtc_month[3:0] == 4'h9) begin
												rtc_month[3:0] <= 0;
												rtc_month[4] <= rtc_month[4] + 1'b1;
											end
											if (rtc_month == 5'h12) begin
												rtc_month <= 5'h01;
												rtc_year[3:0] <= rtc_year[3:0] + 1'b1;
												rtc_leap_year <= rtc_leap_year + 1'b1;
												if (rtc_year[3:0] == 4'h9) begin
													rtc_year[3:0] <= 0;
													rtc_year[7:4] <= rtc_year[7:4] + 1'b1;
													if (rtc_year[7:4] == 4'h9)
														rtc_year[7:4] <= 0;
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
			if (ce_cpu) begin
				cram_wr_r <= 0;
				ram_io <= 0;
				if (reg_start) begin
					reg_start <= 0;
					if (|rtc_sel) begin
						if (rtc_sel == 2'd1)
							case (reg_addr)
								5'h04: begin
									rtc_minutes <= reg_data_in[6:0];
									rtc_seconds <= 0;
									rtc_subseconds <= 0;
								end
								5'h05: rtc_hours <= reg_data_in[5:0];
								5'h06: rtc_index <= 0;
								default:
									;
							endcase
						if (rtc_sel == 2'd2)
							case ({reg_addr, reg_data_in[3:0]})
								6'h07: rtc_days[3:0] <= reg_data_in[7:4];
								6'h08: rtc_days[5:4] <= reg_data_in[5:4];
								6'h09: rtc_month[3:0] <= reg_data_in[7:4];
								6'h0a: rtc_month[4] <= reg_data_in[4];
								6'h0b: rtc_year[3:0] <= reg_data_in[7:4];
								6'h0c: rtc_year[7:4] <= reg_data_in[7:4];
								6'h2a: rtc_24hours <= reg_data_in[4];
								6'h2b: rtc_leap_year <= reg_data_in[5:4];
								default:
									;
							endcase
					end
					else begin
						cram_wr_r <= ~ram_read;
						ram_io <= 1;
					end
				end
				if (ram_io & ram_read)
					reg_data_out <= cram_di;
				prev_cram_rd <= cram_rd;
				if ((((prev_cram_rd & ~cram_rd) & ~cart_addr[0]) & |rtc_sel) & (reg_index[3:1] == 3'b110))
					rtc_index <= rtc_index + 1'b1;
			end
		end
	wire [4:0] rom_bank = (~cart_addr[14] ? 5'd0 : rom_bank_reg);
	wire [4:0] rom_bank_m = rom_bank & rom_mask[4:0];
	assign mbc_addr = {4'b0000, rom_bank_m, cart_addr[13:0]};
	reg [3:0] rtc_do_r;
	always @(*) begin
		rtc_do_r = 4'h0;
		case (rtc_index)
			4'h0: rtc_do_r[3:0] = rtc_minutes[3:0];
			4'h1: rtc_do_r[2:0] = rtc_minutes[6:4];
			4'h2: rtc_do_r[3:0] = rtc_hours[3:0];
			4'h3: rtc_do_r[1:0] = rtc_hours[5:4];
			4'h4: rtc_do_r[3:0] = rtc_days[3:0];
			4'h5: rtc_do_r[1:0] = rtc_days[5:4];
			4'h6: rtc_do_r[3:0] = rtc_month[3:0];
			4'h7: rtc_do_r[0] = rtc_month[4];
			default:
				;
		endcase
	end
	reg [3:0] cram_do_r;
	always @(*) begin
		cram_do_r = 4'hf;
		if (~cart_addr[0]) begin
			if (~unlocked)
				cram_do_r = 4'd0;
			else
				case (reg_index)
					4'ha: cram_do_r = 4'd1;
					4'hc: cram_do_r = (|rtc_sel ? rtc_do_r : reg_data_out[3:0]);
					4'hd: cram_do_r = (|rtc_sel ? rtc_do_r : reg_data_out[7:4]);
					default:
						;
				endcase
		end
	end
	assign cram_wr = cram_wr_r;
	assign cram_wr_do = reg_data_in;
	assign cram_do = {4'hf, cram_do_r};
	assign cram_addr = {12'd0, reg_addr};
	assign cart_oe = (cart_rd & ~cart_a15) | (cram_rd & ~cart_addr[0]);
	assign has_battery = 1;
	assign ram_enabled = 0;
endmodule
module gb_machine (
	clk_sys,
	reset,
	model,
	fast_boot,
	joy,
	dl,
	dl_wr,
	dl_addr,
	dl_data,
	dl_wait,
	mem_rd,
	mem_wr,
	mem_cram,
	mem_addr,
	mem_cram_addr,
	mem_din,
	mem_q,
	ram_mask_file,
	has_save,
	bram_save,
	rtc_time,
	bk_rtc_wr,
	bk_addr,
	bk_data,
	rtc_timestamp,
	rtc_savedtime,
	lcd_ce,
	lcd_clkena,
	lcd_data,
	lcd_data_gb,
	lcd_mode,
	lcd_on,
	lcd_vsync,
	is_gbc,
	audio_l,
	audio_r,
	speed
);
	input clk_sys;
	input reset;
	input [1:0] model;
	input fast_boot;
	input [7:0] joy;
	input dl;
	input dl_wr;
	input [24:0] dl_addr;
	input [15:0] dl_data;
	output wire dl_wait;
	output wire mem_rd;
	output wire mem_wr;
	output wire mem_cram;
	output wire [22:0] mem_addr;
	output wire [16:0] mem_cram_addr;
	output wire [7:0] mem_din;
	input [7:0] mem_q;
	output wire [7:0] ram_mask_file;
	output wire has_save;
	output wire bram_save;
	input [32:0] rtc_time;
	input bk_rtc_wr;
	input [16:0] bk_addr;
	input [15:0] bk_data;
	output wire [31:0] rtc_timestamp;
	output wire [47:0] rtc_savedtime;
	output wire lcd_ce;
	output wire lcd_clkena;
	output wire [14:0] lcd_data;
	output wire [1:0] lcd_data_gb;
	output wire [1:0] lcd_mode;
	output wire lcd_on;
	output wire lcd_vsync;
	output wire is_gbc;
	output wire [15:0] audio_l;
	output wire [15:0] audio_r;
	output wire speed;
	wire ce;
	wire ce_n;
	wire ce_2x;
	wire paused;
	ce_gen u_ce(
		.clk_sys(clk_sys),
		.pause(1'b0),
		.fast(1'b0),
		.ce(ce),
		.ce_n(ce_n),
		.ce_2x(ce_2x),
		.paused(paused)
	);
	reg ce_32k = 1'b0;
	reg [9:0] ce_32k_div = 10'd0;
	always @(posedge clk_sys) begin
		ce_32k_div <= ce_32k_div + 1'b1;
		ce_32k <= ~|ce_32k_div;
	end
	wire isGBC_game;
	reg isGBC = 1'b0;
	always @(posedge clk_sys)
		if (reset)
			isGBC <= (model == 2'd1) | ((model == 2'd0) & isGBC_game);
	assign is_gbc = isGBC;
	wire [1:0] joy_p54;
	wire [3:0] joy_dir = ~joy[3:0] | {4 {joy_p54[0]}};
	wire [3:0] joy_buttons = ~{joy[7], joy[6], joy[5], joy[4]} | {4 {joy_p54[1]}};
	wire [3:0] joy_din = joy_dir & joy_buttons;
	wire [14:0] ext_bus_addr;
	wire ext_bus_a15;
	wire cart_rd;
	wire cart_wr;
	wire cart_oe;
	wire nCS;
	wire [7:0] cart_do;
	wire [7:0] cart_di;
	wire [7:0] cart_ram_size;
	wire [63:0] ss_ext_din;
	wire [63:0] ss_ext_dout;
	wire [9:0] ss_ext_adr;
	wire ss_ext_wren;
	wire ss_ext_rst;
	gb u_gb(
		.reset(reset),
		.clk_sys(clk_sys),
		.ce(ce),
		.ce_n(ce_n),
		.ce_2x(ce_2x),
		.joystick(8'd0),
		.isGBC(isGBC),
		.real_cgb_boot(1'b0),
		.isSGB(1'b0),
		.extra_spr_en(1'b0),
		.ext_bus_addr(ext_bus_addr),
		.ext_bus_a15(ext_bus_a15),
		.cart_rd(cart_rd),
		.cart_wr(cart_wr),
		.cart_do(cart_do),
		.cart_di(cart_di),
		.cart_oe(cart_oe),
		.nCS(nCS),
		.PHI(),
		.sdram_rd(mem_rd),
		.cgb_boot_download(1'b0),
		.dmg_boot_download(1'b0),
		.sgb_boot_download(1'b0),
		.ioctl_wr(1'b0),
		.ioctl_addr(25'd0),
		.ioctl_dout(16'd0),
		.boot_gba_en(1'b0),
		.fast_boot_en(fast_boot),
		.audio_l(audio_l),
		.audio_r(audio_r),
		.audio_no_pops(1'b0),
		.megaduck(1'b0),
		.lcd_clkena(lcd_clkena),
		.lcd_data(lcd_data),
		.lcd_data_gb(lcd_data_gb),
		.lcd_mode(lcd_mode),
		.lcd_on(lcd_on),
		.lcd_vsync(lcd_vsync),
		.joy_p54(joy_p54),
		.joy_din(joy_din),
		.speed(speed),
		.DMA_on(),
		.gg_reset(1'b0),
		.gg_en(1'b0),
		.gg_code(129'd0),
		.gg_available(),
		.sc_int_clock2(),
		.serial_clk_in(1'b0),
		.serial_clk_out(),
		.serial_data_in(1'b1),
		.serial_data_out(),
		.increaseSSHeaderCount(1'b0),
		.cart_ram_size(cart_ram_size),
		.save_state(1'b0),
		.load_state(1'b0),
		.savestate_number(2'd0),
		.sleep_savestate(),
		.savestate_ovr(),
		.SaveStateExt_Din(ss_ext_din),
		.SaveStateExt_Adr(ss_ext_adr),
		.SaveStateExt_wren(ss_ext_wren),
		.SaveStateExt_rst(ss_ext_rst),
		.SaveStateExt_Dout(ss_ext_dout),
		.SaveStateExt_load(),
		.Savestate_CRAMAddr(),
		.Savestate_CRAMRdEn(),
		.Savestate_CRAMRWrEn(),
		.Savestate_CRAMWriteData(),
		.Savestate_CRAMReadData(16'd0),
		.SAVE_out_Din(),
		.SAVE_out_Dout(64'd0),
		.SAVE_out_Adr(),
		.SAVE_out_rnw(),
		.SAVE_out_ena(),
		.SAVE_out_be(),
		.SAVE_out_done(1'b0),
		.savestate_sdram_busy(1'b0),
		.rewind_on(1'b0),
		.rewind_active(1'b0)
	);
	cart_top u_cart(
		.reset(reset),
		.clk_sys(clk_sys),
		.ce_cpu(ce),
		.ce_cpu2x(ce_2x),
		.speed(speed),
		.megaduck(1'b0),
		.duck_md0_mode(1'b0),
		.mapper_sel(3'd0),
		.cart_addr(ext_bus_addr),
		.cart_a15(ext_bus_a15),
		.cart_rd(cart_rd),
		.cart_wr(cart_wr),
		.cart_do(cart_do),
		.cart_di(cart_di),
		.cart_oe(cart_oe),
		.nCS(nCS),
		.mbc_addr(mem_addr),
		.dn_write(),
		.cart_ready(),
		.is_cram_addr(mem_cram),
		.cram_rd(),
		.cram_wr(mem_wr),
		.cram_bram_wr(),
		.cram_addr(mem_cram_addr),
		.cart_download(dl),
		.ram_mask_file(ram_mask_file),
		.ram_size(cart_ram_size),
		.has_save(has_save),
		.bram_save(bram_save),
		.isGBC_game(isGBC_game),
		.isSGB_game(),
		.ioctl_download(dl),
		.ioctl_wr(dl_wr),
		.ioctl_addr(dl_addr),
		.ioctl_dout(dl_data),
		.ioctl_wait(dl_wait),
		.bk_wr(1'b0),
		.bk_rtc_wr(bk_rtc_wr),
		.bk_addr(bk_addr),
		.bk_data(bk_data),
		.bk_q(),
		.img_size(64'd0),
		.rom_di(mem_q),
		.joystick_analog_0(16'd0),
		.ce_32k(ce_32k),
		.RTC_time(rtc_time),
		.RTC_timestampOut(rtc_timestamp),
		.RTC_savedtimeOut(rtc_savedtime),
		.RTC_inuse(),
		.SaveStateExt_Din(ss_ext_din),
		.SaveStateExt_Adr(ss_ext_adr),
		.SaveStateExt_wren(ss_ext_wren),
		.SaveStateExt_rst(ss_ext_rst),
		.SaveStateExt_Dout(ss_ext_dout),
		.savestate_load(1'b0),
		.savestate_ovr(1'b0),
		.Savestate_CRAMAddr(20'd0),
		.Savestate_CRAMRWrEn(1'b0),
		.Savestate_CRAMWriteData(16'd0),
		.Savestate_CRAM_Q(),
		.rumbling()
	);
	assign mem_din = cart_di;
	assign lcd_ce = ce;
endmodule
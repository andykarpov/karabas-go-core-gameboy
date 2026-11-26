`timescale 1ns / 1ps
`default_nettype wire
/*
 gb_clocks.v (after ws_clocks.v of karabas-go-core-wonderswan)

 The clocks of the Game Boy core from CLK_50MHZ (the pin):

 1. The machine: DCM_CLKGEN 50 * 47 / 70 = 33.571 MHz (33.554432 of MiSTer / 2 = +0.05 %: the game
    runs 0.05 % fast; a PLL alone gives 33.33, -0.66 %) -> BUFG -> PLL x24 (VCO 805.7 MHz, cleans
    the jitter of CLKFX).
      clk_sys  /24  33.571 MHz: gb_machine (ce = clk_sys / 8 = 4.196 MHz), the MCU link, the loader,
                    the frame buffer writes and the SRAM, the audio
      clk_ram  /8   100.71 MHz: the SDRAM controller (3 x clk_sys, the rising edges together)
      clk_sdr  /8   100.71 MHz, 330 degrees: SDR_CLK only (an ODDR2), the chip a little ahead of the
                    controller, as core-wonderswan / core-sega
    The PLL is held in reset until the DCM locks.
 2. The video: PLL from 50 MHz, VCO 800 MHz:
      clk_vid  /20  40.0 MHz: 800 x 600 at 60 Hz (VESA), the OSD, HDMI; FT_CLK_OUT 8 MHz (/5)
      clk_ser, clk_ser_n  /4  200 MHz, 0 and 180 degrees: the HDMI serialiser
 The two groups are not related: the frame buffer crosses with a toggle and a line buffer, the audio
 with a toggle (TIG in the ucf).
*/
module gb_clocks (
	input wire clk_in,
	output wire clk_sys,
	output wire clk_ram,
	output wire clk_sdr,
	output wire clk_vid,
	output wire clk_ser,
	output wire clk_ser_n,
	output wire locked_sys,
	output wire locked_vid
);


wire clk_50_ibufg, clk_50_bufg;
IBUFG ibufg_50 (.I(clk_in), .O(clk_50_ibufg));
BUFG bufg_50 (.I(clk_50_ibufg), .O(clk_50_bufg));

wire fx, fx_buf, dcm_locked;
DCM_CLKGEN #(
	.CLKFX_MULTIPLY(47),
	.CLKFX_DIVIDE(70),
	.CLKFXDV_DIVIDE(2),
	.CLKFX_MD_MAX(0.68),
	.CLKIN_PERIOD(20.0),
	.SPREAD_SPECTRUM("NONE"),
	.STARTUP_WAIT("FALSE")
) dcm (
	.CLKIN(clk_50_bufg),
	.RST(1'b0),
	.FREEZEDCM(1'b0),
	.PROGCLK(1'b0),
	.PROGDATA(1'b0),
	.PROGEN(1'b0),
	.CLKFX(fx),
	.CLKFX180(),
	.CLKFXDV(),
	.LOCKED(dcm_locked),
	.PROGDONE(),
	.STATUS()
);
BUFG bufg_fx (.I(fx), .O(fx_buf));

wire [5:0] pll_sys;
kg_pll #(
	.CLKIN_PERIOD(29.787),
	.DIVCLK_DIVIDE(1),
	.CLKFBOUT_MULT(24),
	.CLKOUT0_DIVIDE(24),
	.CLKOUT1_DIVIDE(8),
	.CLKOUT2_DIVIDE(8), .CLKOUT2_PHASE(330.0),
	.IBUFG(0),
	.BUFG_MASK(6'b000111)
) pll_m (
	.clk_in(fx_buf),
	.rst(!dcm_locked),
	.clk_out(pll_sys),
	.locked(locked_sys)
);
assign clk_sys = pll_sys[0];
assign clk_ram = pll_sys[1];
assign clk_sdr = pll_sys[2];

wire [5:0] pll_vid;
kg_pll #(
	.CLKIN_PERIOD(20.0),
	.DIVCLK_DIVIDE(1),
	.CLKFBOUT_MULT(16),
	.CLKOUT0_DIVIDE(20),
	.CLKOUT1_DIVIDE(4),
	.CLKOUT2_DIVIDE(4), .CLKOUT2_PHASE(180.0),
	.IBUFG(0),
	.BUFG_MASK(6'b000111)
) pll_v (
	.clk_in(clk_50_bufg),
	.rst(1'b0),
	.clk_out(pll_vid),
	.locked(locked_vid)
);
assign clk_vid = pll_vid[0];
assign clk_ser = pll_vid[1];
assign clk_ser_n = pll_vid[2];

endmodule

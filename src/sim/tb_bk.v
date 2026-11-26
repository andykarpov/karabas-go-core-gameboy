`timescale 1ns / 1ps
`default_nettype wire

/*
 tb_bk.v - iverilog check of gb_bk.v (sim/run_bk.sh, ~10 s, after tb_bk.v of core-wonderswan): the
 memory port of kg_bk_ram as it drives it (mem_req held until mem_ack, a sector byte by byte from
 offset 0), gb_bk and gb_mem (the cartridge bus of the machine) on gb_sdram and sdram_model.
 Checked:
 - cartridge RAM (ram_secs 16 = 8 KB): a sector written byte by byte at offset 0x600 and read back;
   the machine reads the same bytes through gb_mem (cram_addr 0x600 / 0x7FF); a byte the machine
   writes (cram 0x1235) read through the port;
 - the RTC sector (sector 16): loaded with a time and registers -> bk_rtc_wr words 0..4 with the
   little endian words of the bytes; loaded with time FFFFFFFF (a new file) -> no bk_rtc_wr; read
   -> the time and registers of the machine at byte 0, FF after byte 9.
 Prints "tb_bk: 0 errors".
*/

module tb_bk;

reg clk_ram = 1'b0, clk = 1'b0;
always #5 clk_ram = ~clk_ram;   // clk_sys = clk_ram / 3, rising edges aligned
always #15 clk = ~clk;

integer errors = 0;
task check(input [255:0] what, input [31:0] got, input [31:0] want);
	if (got !== want) begin
		$display("ERROR %0s: got %h, want %h", what, got, want);
		errors = errors + 1;
	end
endtask

reg init = 1'b1;
reg mem_req = 1'b0, mem_we = 1'b0;
reg [17:0] mem_addr = 18'd0;
reg [7:0] mem_din = 8'd0;
wire mem_ack;
wire [7:0] mem_dout;
wire [25:1] sdr_addr;
wire [15:0] sdr_din, sdr_dout;
wire sdr_req, sdr_rnw, sdr_ready;
reg [31:0] rtc_ts = 32'h11223344;
reg [47:0] rtc_sv = 48'h0000_0ABC_DEF1;
wire bk_rtc_wr;
wire [16:0] bk_addr;
wire [15:0] bk_data;

gb_bk dut (
	.clk(clk), .clk_ram(clk_ram), .ram_secs(9'd16),
	.mem_req(mem_req), .mem_we(mem_we), .mem_addr(mem_addr), .mem_din(mem_din),
	.mem_ack(mem_ack), .mem_dout(mem_dout),
	.rtc_timestamp(rtc_ts), .rtc_savedtime(rtc_sv),
	.bk_rtc_wr(bk_rtc_wr), .bk_addr(bk_addr), .bk_data(bk_data),
	.sdr_addr(sdr_addr), .sdr_din(sdr_din), .sdr_req(sdr_req), .sdr_rnw(sdr_rnw),
	.sdr_dout(sdr_dout), .sdr_ready(sdr_ready)
);

// the words given to cart_top
reg [15:0] rtc_words [0:7];
integer rtc_n = 0;
always @(posedge clk) if (bk_rtc_wr) begin
	if (bk_addr < 17'd8) rtc_words[bk_addr] <= bk_data;
	rtc_n = rtc_n + 1;
end

// the machine side: gb_mem
reg m_rd = 1'b0, m_wr = 1'b0;
reg [16:0] m_cram_addr = 17'd0;
reg [7:0] m_din = 8'd0;
wire [7:0] m_q;
wire [25:1] m_sdr_addr;
wire [15:0] m_sdr_din, m_sdr_dout;
wire [1:0] m_sdr_be;
wire m_sdr_req, m_sdr_rnw, m_sdr_ready, refresh;
gb_mem mem (
	.clk(clk), .loading(1'b0),
	.mem_rd(m_rd), .mem_wr(m_wr), .mem_cram(1'b1), .mem_addr(23'd0), .mem_cram_addr(m_cram_addr),
	.mem_din(m_din), .mem_q(m_q),
	.sdr_addr(m_sdr_addr), .sdr_din(m_sdr_din), .sdr_be(m_sdr_be), .sdr_req(m_sdr_req),
	.sdr_rnw(m_sdr_rnw), .sdr_dout(m_sdr_dout), .sdr_ready(m_sdr_ready), .refresh(refresh)
);

wire [15:0] dq;
wire [12:0] a;
wire [1:0] ba;
wire ras_n, cas_n, we_n, cs_n, dqml, dqmh;
wire [31:0] sdram_errors;
gb_sdram sdram (
	.init(init), .clk(clk_ram), .doRefresh(refresh),
	.SDRAM_DQ(dq), .SDRAM_A(a), .SDRAM_DQML(dqml), .SDRAM_DQMH(dqmh), .SDRAM_BA(ba),
	.SDRAM_nCS(cs_n), .SDRAM_nWE(we_n), .SDRAM_nRAS(ras_n), .SDRAM_nCAS(cas_n),
	.ch1_addr(25'd0), .ch1_dout(), .ch1_din(16'd0), .ch1_req(1'b0), .ch1_rnw(1'b1), .ch1_ready(),
	.ch2_addr(sdr_addr), .ch2_dout(sdr_dout), .ch2_din(sdr_din), .ch2_req(sdr_req), .ch2_rnw(sdr_rnw),
	.ch2_ready(sdr_ready),
	.ch3_addr(m_sdr_addr), .ch3_dout(m_sdr_dout), .ch3_din(m_sdr_din), .ch3_be(m_sdr_be),
	.ch3_req(m_sdr_req), .ch3_rnw(m_sdr_rnw), .ch3_ready(m_sdr_ready)
);
sdram_model chip (
	.clk(clk_ram), .dq(dq), .a(a), .ba(ba), .cs_n(cs_n), .ras_n(ras_n), .cas_n(cas_n), .we_n(we_n),
	.dqml(dqml), .dqmh(dqmh), .errors(sdram_errors)
);

// a byte through the memory port, as kg_bk_ram: the request held until the ack
task bkm(input we, input [17:0] ad, input [7:0] d, output [7:0] q);
	begin
		@(posedge clk); mem_req <= 1'b1; mem_we <= we; mem_addr <= ad; mem_din <= d;
		@(posedge clk); while (!mem_ack) @(posedge clk);
		q = mem_dout; mem_req <= 1'b0;
	end
endtask

// a machine access through gb_mem: sdram_rd / cram_wr high for 16 clocks (a bus half cycle)
task mach(input wr, input [16:0] ad, input [7:0] d, output [7:0] q);
	begin
		@(posedge clk); m_cram_addr <= ad; m_din <= d; m_rd <= !wr; m_wr <= wr;
		repeat (16) @(posedge clk);
		q = m_q; m_rd <= 1'b0; m_wr <= 1'b0;
		repeat (16) @(posedge clk);
	end
endtask

function [7:0] pat(input integer i);
	pat = i[7:0] ^ 8'h5A ^ { i[9:8], 6'd0 };
endfunction

// an RTC sector: time, registers, FF
task rtc_sector(input [31:0] ts, input [47:0] sv);
	integer k;
	reg [79:0] b;
	begin
		b = { sv, ts };
		for (k = 0; k < 512; k = k + 1) bkm(1'b1, 18'h2000 + k, k < 10 ? b[k * 8 +: 8] : 8'hFF, q);
		repeat (10) @(posedge clk);
	end
endtask

integer i, bad;
reg [7:0] q;
initial begin
	repeat (20) @(posedge clk_ram);
	init = 1'b0;
	repeat (13000) @(posedge clk_ram);   // the SDRAM start (12100 clocks)

	// ---- cartridge RAM: a sector at 0x600 ----
	for (i = 0; i < 512; i = i + 1) bkm(1'b1, 18'h600 + i, pat(i), q);
	bad = 0;
	for (i = 0; i < 512; i = i + 1) begin
		bkm(1'b0, 18'h600 + i, 8'd0, q);
		if (q !== pat(i)) bad = bad + 1;
	end
	check("RAM sector read back", bad, 0);
	mach(1'b0, 17'h600, 8'd0, q); check("machine sees the sector (byte 0)", q, pat(0));
	mach(1'b0, 17'h7FF, 8'd0, q); check("machine sees the sector (byte 511)", q, pat(511));
	mach(1'b1, 17'h1235, 8'hC3, q);
	mach(1'b1, 17'h1234, 8'h3C, q);
	bkm(1'b0, 18'h1235, 8'd0, q); check("machine write, odd byte", q, 8'hC3);
	bkm(1'b0, 18'h1234, 8'd0, q); check("machine write, even byte", q, 8'h3C);
	bkm(1'b0, 18'h1236, 8'd0, q); check("machine write, neighbour untouched", q, 8'h00);

	// ---- the RTC sector ----
	rtc_n = 0;
	rtc_sector(32'h6789ABCD, 48'h0000_1357_9BDF);
	check("RTC load: 5 words", rtc_n, 5);
	check("RTC word 0", rtc_words[0], 16'hABCD);
	check("RTC word 1", rtc_words[1], 16'h6789);
	check("RTC word 2", rtc_words[2], 16'h9BDF);
	check("RTC word 3", rtc_words[3], 16'h1357);
	check("RTC word 4", rtc_words[4], 16'h0000);
	rtc_n = 0;
	rtc_sector(32'hFFFFFFFF, 48'hFFFF_FFFF_FFFF);
	check("RTC load of a new file: nothing", rtc_n, 0);
	bkm(1'b0, 18'h2000, 8'd0, q); check("RTC read byte 0", q, 8'h44);
	rtc_ts = 32'h0;          // a change after byte 0 is not seen (one pair)
	bkm(1'b0, 18'h2003, 8'd0, q); check("RTC read byte 3", q, 8'h11);
	bkm(1'b0, 18'h2004, 8'd0, q); check("RTC read byte 4", q, 8'hF1);
	bkm(1'b0, 18'h2006, 8'd0, q); check("RTC read byte 6", q, 8'hBC);
	bkm(1'b0, 18'h2007, 8'd0, q); check("RTC read byte 7", q, 8'h0A);
	bkm(1'b0, 18'h200A, 8'd0, q); check("RTC read byte 10", q, 8'hFF);

	check("sdram model errors", sdram_errors, 0);
	$display("tb_bk: %0d errors", errors);
	$finish;
end

initial begin
	#40000000;
	$display("ERROR: timeout");
	$display("tb_bk: %0d errors", errors + 1);
	$finish;
end

endmodule

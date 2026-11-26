// sim_gb.cpp - harness of gb_machine (Game Boy / GBC), the cartridge memory in C++.
//
// One clk_sys period = 2 steps; inputs change after the falling edge, outputs are sampled there.
// The cartridge is loaded as MiSTer ioctl does: dl high, one 16-bit word (little endian, byte
// address) per dl_wr, the next word only when dl_wait is low; then dl low, reset released.
// The cartridge memory answers mem_rd with the byte on the next clock (the SDRAM of the boards
// gives it within the CPU cycle); mem_wr writes the cartridge RAM.
//
// usage: Vgb_machine --rom FILE [--frames N] [--ppm PREFIX] [--model 0|1|2] [--slow-boot]
//                    [--keys HEX@F,...] [--expect-ppm FILE]
//   --frames N        run N LCD frames (lcd_vsync rising edges) after the reset (default 10)
//   --ppm PREFIX      write PREFIX.ppm of the last frame (160 x 144, RGB)
//   --model           0 Auto (the header), 1 GBC, 2 GB
//   --slow-boot       the boot ROM animation (default: fast boot)
//   --keys HEX@F      from frame F on, joy = HEX ({start, select, b, a, down, up, left, right})
//   --expect-ppm FILE the last frame must equal this PPM (P6 160 x 144)
//   --trace N         print the first N cartridge reads (clock, address, data)
//   --cram-dump FILE  write the cartridge RAM (128 KB) at the end
// Prints one line per frame (checksum, pixels) and "PASS" / "FAIL: ..." at the end.

#include "Vgb_machine.h"
#include "verilated.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <string>
#include <vector>

static Vgb_machine *top;
static std::vector<uint8_t> rom, cram(128 * 1024, 0xFF);
static uint64_t clocks;

static void edge_rise() { top->clk_sys = 1; top->eval(); }
static void edge_fall() { top->clk_sys = 0; top->eval(); clocks++; }

static const int W = 160, H = 144;
static uint8_t fb[W * H * 3];

static void shade_rgb(int s, uint8_t *p) { // GB: 0 = white .. 3 = black (DMG-like greys)
	static const uint8_t g[4] = {0xFF, 0xAA, 0x55, 0x00};
	p[0] = p[1] = p[2] = g[s & 3];
}
static void bgr555_rgb(int c, uint8_t *p) {
	int r = c & 31, g = (c >> 5) & 31, b = (c >> 10) & 31;
	p[0] = (r << 3) | (r >> 2); p[1] = (g << 3) | (g >> 2); p[2] = (b << 3) | (b >> 2);
}

static bool write_ppm(const std::string &f) {
	FILE *o = fopen(f.c_str(), "wb");
	if (!o) return false;
	fprintf(o, "P6\n%d %d\n255\n", W, H);
	fwrite(fb, 1, sizeof fb, o);
	fclose(o);
	return true;
}
static bool read_ppm(const std::string &f, std::vector<uint8_t> &d) {
	FILE *i = fopen(f.c_str(), "rb");
	if (!i) return false;
	int w, h, m;
	if (fscanf(i, "P6 %d %d %d", &w, &h, &m) != 3 || w != W || h != H) { fclose(i); return false; }
	fgetc(i);
	d.resize(W * H * 3);
	bool ok = fread(d.data(), 1, d.size(), i) == d.size();
	fclose(i);
	return ok;
}

int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);
	std::string romf, ppm, expect, cramf;
	int frames = 10, model = 0, trace = 0;
	bool slow = false;
	struct Key { int frame, val; };
	std::vector<Key> keys;
	for (int i = 1; i < argc; i++) {
		std::string a = argv[i];
		auto nx = [&]() { return std::string(i + 1 < argc ? argv[++i] : ""); };
		if (a == "--rom") romf = nx();
		else if (a == "--frames") frames = atoi(nx().c_str());
		else if (a == "--ppm") ppm = nx();
		else if (a == "--model") model = atoi(nx().c_str());
		else if (a == "--slow-boot") slow = true;
		else if (a == "--trace") trace = atoi(nx().c_str());
		else if (a == "--expect-ppm") expect = nx();
		else if (a == "--cram-dump") cramf = nx();
		else if (a == "--keys") {
			std::string s = nx(); size_t p = 0;
			while (p < s.size()) {
				size_t c = s.find(',', p); if (c == std::string::npos) c = s.size();
				std::string k = s.substr(p, c - p); size_t at = k.find('@');
				if (at != std::string::npos) keys.push_back({atoi(k.substr(at + 1).c_str()), (int)strtol(k.substr(0, at).c_str(), 0, 16)});
				p = c + 1;
			}
		}
	}
	FILE *rf = fopen(romf.c_str(), "rb");
	if (!rf) { printf("FAIL: no rom %s\n", romf.c_str()); return 1; }
	fseek(rf, 0, SEEK_END); rom.resize(ftell(rf)); fseek(rf, 0, SEEK_SET);
	if (fread(rom.data(), 1, rom.size(), rf) != rom.size()) { printf("FAIL: read\n"); return 1; }
	fclose(rf);

	top = new Vgb_machine;
	top->model = model; top->fast_boot = !slow; top->joy = 0;
	top->dl = 0; top->dl_wr = 0; top->dl_addr = 0; top->dl_data = 0;
	top->rtc_time = 0; top->mem_q = 0xFF;
	top->reset = 1;
	for (int i = 0; i < 64; i++) { edge_rise(); edge_fall(); }

	// load: dl high, words while dl_wait low
	top->dl = 1;
	for (int i = 0; i < 16; i++) { edge_rise(); edge_fall(); }
	for (size_t a = 0; a < rom.size(); a += 2) {
		int guard = 0;
		while (top->dl_wait && guard++ < 64) { edge_rise(); edge_fall(); }
		top->dl_addr = a; top->dl_data = rom[a] | ((a + 1 < rom.size() ? rom[a + 1] : 0xFF) << 8);
		top->dl_wr = 1; edge_rise(); edge_fall(); top->dl_wr = 0;
		edge_rise(); edge_fall();
	}
	for (int i = 0; i < 16; i++) { edge_rise(); edge_fall(); }
	top->dl = 0;
	for (int i = 0; i < 64; i++) { edge_rise(); edge_fall(); }
	top->reset = 0;

	int frame = 0, x = 0, y = 0, old_vs = top->lcd_vsync, pend = 0;
	uint32_t pend_addr = 0;
	bool pend_cram = false;
	uint64_t limit = (uint64_t)(frames + 400) * 600000ull; // generous: the LCD may be off for a while
	memset(fb, 0xFF, sizeof fb);
	while (frame < frames && clocks < limit) {
		// keys
		for (auto &k : keys) if (frame >= k.frame) top->joy = k.val;
		edge_rise();
		// memory: data of the read registered at the previous rise
		if (pend) {
			uint8_t d = 0xFF;
			if (pend_cram) d = cram[pend_addr & (cram.size() - 1)];
			else if (!rom.empty()) d = rom[pend_addr % rom.size()];
			top->mem_q = d; pend = 0;
			if (trace > 0) { trace--; printf("rd %10llu %s %06x = %02x\n", (unsigned long long)clocks, pend_cram ? "cram" : "rom ", pend_addr, d); }
		}
		if (top->mem_rd) { pend = 1; pend_addr = top->mem_cram ? top->mem_cram_addr : top->mem_addr; pend_cram = top->mem_cram; }
		if (top->mem_wr && top->mem_cram) cram[top->mem_cram_addr & (cram.size() - 1)] = top->mem_din;
		// video
		if (top->lcd_ce && top->lcd_clkena && top->lcd_on && y < H) {
			if (x < W) {
				uint8_t *p = fb + (y * W + x) * 3;
				if (top->is_gbc) bgr555_rgb(top->lcd_data, p); else shade_rgb(top->lcd_data_gb, p);
			}
			if (++x == W) { x = 0; y++; }
		}
		if (top->lcd_vsync && !old_vs) {
			uint32_t sum = 0; int nonwhite = 0;
			for (int i = 0; i < W * H * 3; i++) sum = sum * 31 + fb[i];
			for (int i = 0; i < W * H; i++) if (fb[i * 3] != 0xFF || fb[i * 3 + 1] != 0xFF || fb[i * 3 + 2] != 0xFF) nonwhite++;
			printf("frame %3d  clk %10llu  lines %3d  sum %08x  non-white %5d\n", frame, (unsigned long long)clocks, y, sum, nonwhite);
			frame++; x = 0; y = 0;
		}
		old_vs = top->lcd_vsync;
		edge_fall();
	}
	if (!ppm.empty()) write_ppm(ppm + ".ppm");
	if (!cramf.empty()) { FILE *o = fopen(cramf.c_str(), "wb"); if (o) { fwrite(cram.data(), 1, cram.size(), o); fclose(o); } }
	if (frame < frames) { printf("FAIL: only %d frames in %llu clocks\n", frame, (unsigned long long)clocks); return 1; }
	if (!expect.empty()) {
		std::vector<uint8_t> ref;
		if (!read_ppm(expect, ref)) { printf("FAIL: cannot read %s\n", expect.c_str()); return 1; }
		int diff = 0;
		for (int i = 0; i < W * H; i++) if (memcmp(fb + i * 3, ref.data() + i * 3, 3)) diff++;
		if (diff) { printf("FAIL: %d pixels differ from %s\n", diff, expect.c_str()); return 1; }
	}
	printf("PASS\n");
	delete top;
	return 0;
}

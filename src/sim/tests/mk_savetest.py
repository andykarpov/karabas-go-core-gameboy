#!/usr/bin/env python3
"""The save / MBC3 clock test ROM: savetest.gb (32 KB, MBC3 + TIMER + RAM + BATTERY, 8 KB RAM).

  python3 mk_savetest.py LOGO_SOURCE.gb OUT.gb

Once at the start it counts its starts in the cartridge RAM (A000 += 1) and writes the marker "GB"
(A001..A002); then, round and round: latch the clock (6000 = 0, 1), read the MBC3 registers seconds,
minutes, hours, days low (RAM bank 08..0B at A000) and store them at A010..A013 (RAM bank 0). So the
.sav holds the number of starts and the clock of the last round; the RTC sector of the .sav (after the
8 KB) its time and registers. The Nintendo logo of the header (0104..0133) is copied from
LOGO_SOURCE (the boot ROM checks it); the header checksum is computed. No picture (the LCD is left
as the boot ROM leaves it).
"""
import sys

src, out = sys.argv[1], sys.argv[2]
logo = open(src, "rb").read()[0x104:0x134]

rom = bytearray(b"\xFF" * 0x8000)
rom[0x100:0x104] = bytes([0x00, 0xC3, 0x50, 0x01])        # nop; jp 0150
rom[0x104:0x134] = logo
rom[0x134:0x144] = b"SAVETEST".ljust(16, b"\x00")          # title, CGB flag 00 (GB)
rom[0x144:0x146] = b"00"
rom[0x146] = 0x00
rom[0x147] = 0x10                                          # MBC3 + TIMER + RAM + BATTERY
rom[0x148] = 0x00                                          # 32 KB
rom[0x149] = 0x02                                          # 8 KB RAM
rom[0x14A] = 0x01
rom[0x14B] = 0x33
rom[0x14C] = 0x00
x = 0
for i in range(0x134, 0x14D):
    x = (x - rom[i] - 1) & 0xFF
rom[0x14D] = x


def ld_a(v):            # ld a, v
    return [0x3E, v]


def st(addr):           # ld (addr), a
    return [0xEA, addr & 0xFF, addr >> 8]


def ld_mem(addr):       # ld a, (addr)
    return [0xFA, addr & 0xFF, addr >> 8]


code = []
code += [0xF3]                                             # di
code += ld_a(0x0A) + st(0x0000)                            # RAM / RTC on
code += ld_a(0x00) + st(0x4000)                            # RAM bank 0
code += [0x21, 0x00, 0xA0, 0x34]                           # ld hl, a000; inc (hl)
code += ld_a(ord("G")) + st(0xA001) + ld_a(ord("B")) + st(0xA002)
loop = 0x150 + len(code)
code += ld_a(0x00) + st(0x6000) + ld_a(0x01) + st(0x6000)  # latch the clock
for reg, r in ((0x08, 0x47), (0x09, 0x4F), (0x0A, 0x57), (0x0B, 0x5F)):  # -> b, c, d, e
    code += ld_a(reg) + st(0x4000) + ld_mem(0xA000) + [r]
code += ld_a(0x00) + st(0x4000)
for i, r in enumerate((0x78, 0x79, 0x7A, 0x7B)):           # ld a, b / c / d / e
    code += [r] + st(0xA010 + i)
code += [0x01, 0x00, 0x40]                                 # ld bc, 4000: a delay
code += [0x0B, 0x78, 0xB1, 0x20, 0xFB]                     # dec bc; ld a, b; or c; jr nz, -5
code += [0xC3, loop & 0xFF, loop >> 8]                     # jp loop
rom[0x150:0x150 + len(code)] = bytes(code)

open(out, "wb").write(rom)
print("%s: %d bytes of code, loop at %04x" % (out, len(code), loop))

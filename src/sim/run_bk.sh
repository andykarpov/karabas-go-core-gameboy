#!/bin/bash
# The save path (iverilog, ~15 s): tb_rtc.v (gb_rtc: the firmware RTC -> Unix seconds) and tb_bk.v
# (gb_bk + gb_mem on gb_sdram and the chip model: the cartridge RAM and the RTC sector of the .sav).
set -e
cd "$(dirname "$0")"
mkdir -p build
echo "JOB-STAGE: tb_rtc"
iverilog -g2005 -o build/tb_rtc tb_rtc.v ../rtl/karabas/gb_rtc.v
vvp -n build/tb_rtc > build/tb_rtc.log
grep -E 'ERROR|tb_rtc:' build/tb_rtc.log
grep -q 'tb_rtc: 0 errors' build/tb_rtc.log || exit 1
echo "JOB-STAGE: tb_bk"
iverilog -g2005 -o build/tb_bk tb_bk.v ../rtl/karabas/gb_bk.v ../rtl/karabas/gb_mem.v ../rtl/karabas/gb_sdram.v sdram_model.v
vvp -n build/tb_bk > build/tb_bk.log
grep -E 'ERROR|tb_bk:' build/tb_bk.log
grep -q 'tb_bk: 0 errors' build/tb_bk.log || exit 1

#!/bin/bash
# gb_fb.v (iverilog): tb_fb.v, three pattern frames through the SRAM model, the 800 x 600 output
# compared pixel by pixel: GBC colours with no blend and with blend, GB shades.
set -e
cd "$(dirname "$0")"
mkdir -p build
for c in "0 0" "0 1" "1 0"; do
	set -- $c
	echo "JOB-STAGE: tb_fb gb $1 blend $2"
	iverilog -g2005 -DGB=$1 -DBLEND=$2 -o build/tb_fb_$1$2 tb_fb.v ../rtl/karabas/gb_fb.v ../../modules/rtl/mem/kg_sdpram.v
	vvp -n build/tb_fb_$1$2 > build/tb_fb_$1$2.log
	grep -E 'PASS|FAIL|pixel|line|checked' build/tb_fb_$1$2.log | head -12
	grep -q '^PASS' build/tb_fb_$1$2.log || exit 1
done
echo "gb_fb ok"

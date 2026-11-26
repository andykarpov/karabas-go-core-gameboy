#!/bin/bash
# The checks (~3 min): gb_fb (iverilog, run_fb.sh), then dmg-acid2 (GB) through the board path
# (gb_loader, gb_mem, gb_sdram on the chip model: sim_sys.cpp) and cgb-acid2 (GBC) on gb_machine
# alone (sim_gb.cpp; the board path too: 2 min more): their reference frames pixel for pixel
# (test ROMs and references: Matt Currie, MIT).
set -e
cd "$(dirname "$0")/.."
sim/run_fb.sh
sim/build.sh
M=sim/build/obj/Vgb_machine
MS=sim/build/obj_sys/Vsim_top
T=sim/tests
echo "JOB-STAGE: dmg-acid2"
$MS --rom $T/dmg-acid2.gb  --frames 45 --ppm sim/build/dmg-acid2 --expect-ppm $T/dmg-acid2-reference.ppm | tail -3
echo "JOB-STAGE: cgb-acid2"
$M --rom $T/cgb-acid2.gbc --frames 85 --ppm sim/build/cgb-acid2 --expect-ppm $T/cgb-acid2-reference.ppm | tail -2
echo "all checks passed"

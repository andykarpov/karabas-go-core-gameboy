#!/bin/bash
# Ф0 checks of the machine (verilator, ~2.5 min): dmg-acid2 (GB) and cgb-acid2 (GBC) must give
# their reference frames pixel for pixel (test ROMs and references: Matt Currie, MIT).
set -e
cd "$(dirname "$0")/.."
sim/build.sh
M=sim/build/obj/Vgb_machine
T=sim/tests
echo "JOB-STAGE: dmg-acid2"
$M --rom $T/dmg-acid2.gb  --frames 45 --ppm sim/build/dmg-acid2 --expect-ppm $T/dmg-acid2-reference.ppm | tail -2
echo "JOB-STAGE: cgb-acid2"
$M --rom $T/cgb-acid2.gbc --frames 85 --ppm sim/build/cgb-acid2 --expect-ppm $T/cgb-acid2-reference.ppm | tail -2
echo "all checks passed"

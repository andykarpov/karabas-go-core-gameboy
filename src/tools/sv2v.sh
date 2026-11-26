#!/bin/bash
# The Verilog of the machine (MiSTer gb as in open-pocket-gbc, rtl/gb + rtl/gb_port, and
# rtl/karabas/gb_machine.v) as one Verilog-2001 file for XST and the simulation:
#   tools/sv2v.sh  ->  rtl/gbv/gb_machine_sv2v.v (in git; the board builds do not need sv2v)
# The VHDL (T80 / GBse, gbc_snd, the savestate packages) goes to XST / ghdl as it is.
set -e
cd "$(dirname "$0")/.."
SV2V=${SV2V:-/opt/sv2v/sv2v}
mkdir -p rtl/gbv
V="rtl/gb_port/gb_stubs.v rtl/gb_port/gb_rams.sv rtl/gb_port/ce_gen.sv
   rtl/gb/gb.v rtl/gb/video.v rtl/gb/sprites.v rtl/gb/sprites_extra.v rtl/gb/sprites_extra_store.v
   rtl/gb/timer.v rtl/gb/hdma.v rtl/gb/link.v rtl/gb/cart.v
   $(ls rtl/gb/mappers/*.v rtl/gb/mappers/*.sv) rtl/karabas/gb_machine.v"
$SV2V -DSYNTHESIS --top=gb_machine $V -w rtl/gbv/gb_machine_sv2v.v
wc -l rtl/gbv/gb_machine_sv2v.v

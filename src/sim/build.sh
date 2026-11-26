#!/bin/bash
# Builds the verilator model of gb_machine: the VHDL (GBse / T80, gbc_snd) through
# ghdl --synth --out=verilog, the Verilog of rtl/gbv/gb_machine_sv2v.v (tools/sv2v.sh) and the
# harness sim_gb.cpp. Output in src/sim/build/ (obj/Vgb_machine). Rebuilds only when a source is
# newer. Run the model from src: the boot ROM is read from rtl/gb_port/boot_rom.hex.
set -e
cd "$(dirname "$0")"
SRC=..
B=build
HERE=$PWD
mkdir -p $B/ghdl
VHDL="rtl/gb/bus_savestates.vhd rtl/gb/reg_savestates.vhd rtl/gb/T80/T80_Pack.vhd rtl/gb/T80/T80_ALU.vhd
      rtl/gb/T80/T80_MCode.vhd rtl/gb/T80/T80_Reg.vhd rtl/gb/T80/T80.vhd rtl/gb/T80/GBse.vhd rtl/gb/gbc_snd.vhd"
GO="--std=08 -frelaxed -fsynopsys -Wno-shared -Wno-hide -Wno-binding --workdir=sim/$B/ghdl"
newer() { [ ! -e "$1" ] || [ -n "$(cd $SRC && find $2 -newer sim/$1 2>/dev/null)" ]; }

for u in GBse gbc_snd; do
	GEN=$B/${u}_ghdl.v
	if newer $GEN "$VHDL sim/build.sh"; then
		echo "JOB-STAGE: ghdl $u"
		(cd $SRC && ghdl --synth --out=verilog $GO $VHDL -e $u 2> sim/$B/ghdl_$u.log) > $GEN.tmp
		grep -q error $B/ghdl_$u.log && { grep error $B/ghdl_$u.log | head; exit 1; }
		mv $GEN.tmp $GEN
	fi
done

OWN="rtl/gbv/gb_machine_sv2v.v"
EXE=$B/obj/Vgb_machine
if newer $EXE "$OWN sim/$B/GBse_ghdl.v sim/$B/gbc_snd_ghdl.v sim/sim_gb.cpp sim/build.sh"; then
	echo "JOB-STAGE: verilator"
	(cd $SRC && verilator -O3 --x-assign fast --x-initial fast --default-language 1364-2005 \
		-Wno-fatal -Wno-lint -Wno-style -Wno-BLKANDNBLK -Wno-MULTIDRIVEN -Wno-UNOPTFLAT -Wno-WIDTH \
		-Wno-CASEINCOMPLETE --no-timing --top-module gb_machine -Mdir sim/$B/obj --cc \
		sim/$B/GBse_ghdl.v sim/$B/gbc_snd_ghdl.v $OWN \
		--exe $HERE/sim_gb.cpp -o Vgb_machine > sim/$B/verilator.log 2>&1) || { grep -E '%Error' $B/verilator.log | head -20; exit 1; }
	echo "JOB-STAGE: c++"
	make -s -j8 -C $B/obj -f Vgb_machine.mk OPT_FAST=-O2 > $B/make.log 2>&1 || { tail -30 $B/make.log; exit 1; }
fi
echo "model ok"

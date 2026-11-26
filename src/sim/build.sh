#!/bin/bash
# Builds the verilator models: the VHDL (GBse / T80, gbc_snd) through ghdl --synth --out=verilog,
# the Verilog of rtl/gbv/gb_machine_sv2v.v (tools/sv2v.sh), and
#   obj/Vgb_machine     gb_machine alone, the cartridge memory in the harness sim_gb.cpp
#   obj_sys/Vsim_top    the board path sim_top.v (gb_loader, gb_mem, gb_sdram, sdram_model), sim_sys.cpp
# Output in src/sim/build/. Rebuilds only when a source is newer. Run the models from src: the boot
# ROM is read from rtl/gb_port/boot_rom.hex.
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

model() { # obj top harness sources...
	local OBJ=$1 TOP=$2 CPP=$3; shift 3
	local EXE=$B/$OBJ/V$TOP
	if newer $EXE "$* sim/$B/GBse_ghdl.v sim/$B/gbc_snd_ghdl.v sim/$CPP sim/build.sh"; then
		echo "JOB-STAGE: verilator $TOP"
		(cd $SRC && verilator -O3 --x-assign fast --x-initial fast --default-language 1364-2005 \
			-Wno-fatal -Wno-lint -Wno-style -Wno-BLKANDNBLK -Wno-MULTIDRIVEN -Wno-UNOPTFLAT -Wno-WIDTH \
			-Wno-CASEINCOMPLETE --no-timing --top-module $TOP -Mdir sim/$B/$OBJ --cc \
			sim/$B/GBse_ghdl.v sim/$B/gbc_snd_ghdl.v "$@" \
			--exe $HERE/$CPP -o V$TOP > sim/$B/verilator_$OBJ.log 2>&1) || { grep -E '%Error' $B/verilator_$OBJ.log | head -20; exit 1; }
		echo "JOB-STAGE: c++ $TOP"
		make -s -j8 -C $B/$OBJ -f V$TOP.mk OPT_FAST=-O2 > $B/make_$OBJ.log 2>&1 || { tail -30 $B/make_$OBJ.log; exit 1; }
	fi
}
model obj gb_machine sim_gb.cpp rtl/gbv/gb_machine_sv2v.v
model obj_sys sim_top sim_sys.cpp rtl/gbv/gb_machine_sv2v.v rtl/karabas/gb_loader.v rtl/karabas/gb_mem.v \
	rtl/karabas/gb_sdram.v sim/sdram_model.v sim/sim_top.v
echo "model ok"

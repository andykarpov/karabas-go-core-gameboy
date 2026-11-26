#!/bin/bash
# The XST source lists: measure/gb.prj (the machine alone) and karabas_<board>.prj (the machine, the
# board glue of rtl/karabas, the modules of karabas-go-modules in tools/board_modules.prj, the top).
set -e
cd "$(dirname "$0")/.."
MACHINE=$(for f in bus_savestates reg_savestates T80/T80_Pack T80/T80_ALU T80/T80_MCode T80/T80_Reg T80/T80 \
	T80/GBse gbc_snd; do echo "vhdl work \"rtl/gb/$f.vhd\""; done; echo 'verilog work "rtl/gbv/gb_machine_sv2v.v"')
echo "$MACHINE" > measure/gb.prj
GLUE="gb_clocks gb_sdram gb_loader gb_mem gb_kbd gb_fb gb_bk gb_rtc"
for b in minig go mini; do
	{ echo "$MACHINE"
	  for g in $GLUE; do echo "verilog work \"rtl/karabas/$g.v\""; done
	  cat tools/board_modules.prj
	  echo "verilog work \"rtl/karabas_${b}_top.v\""
	} > karabas_$b.prj
done

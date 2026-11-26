# Game Boy core: the ISE 14.7 flow of the boards (Ф1+) and the Ф0 fit check of the machine.
#
#   make gb-xst       XST of gb_machine alone (-iobuf NO): LUTs, FFs, block RAMs, clock estimate
#   make gb-report    the numbers of the last gb-xst
#   make clean        the intermediate files
#
# Verilog of the machine: tools/sv2v.sh -> rtl/gbv/gb_machine_sv2v.v (in git).

ISE_SETTINGS ?= /opt/Xilinx/14.7/ISE_DS/settings64.sh

SHELL = /bin/bash
.SHELLFLAGS = -e -o pipefail -c

XIL = source $(ISE_SETTINGS) > /dev/null;

prj_src = $(shell sed -n 's/^[a-z]* work "\(.*\)"/\1/p' $(1) 2>/dev/null)

.PHONY: gb-xst gb-report clean

gb_machine.ngc: measure/gb.xst measure/gb.prj $(call prj_src,measure/gb.prj) rtl/gb_port/boot_rom.hex
	mkdir -p xst_gb/projnav.tmp
	$(XIL) xst -intstyle ise -ifn measure/gb.xst -ofn measure/xst_gb.log

gb-xst: gb_machine.ngc

gb-report:
	@grep -E "Number of Slice (Registers|LUTs)|Number of Block RAM/FIFO|Maximum Frequency|Minimum period" measure/xst_gb.log

clean:
	rm -rf xst_gb _xmsgs xlnx_auto_0_xdb *.ngc *.ngr *.lso *.srp

# Game Boy core: the ISE 14.7 flow of the boards (as core-wonderswan) and the Ф0 fit check.
#
#   make minig        a board: <board>-xst (.ngc), <board>-impl (.bin), <board>-core (.kg)
#   make minig-report LUTs, slices, block RAMs and the timing result of the last build
#   make gb-xst       XST of gb_machine alone (-iobuf NO): LUTs, FFs, block RAMs, clock estimate
#   make gb-report    the numbers of the last gb-xst
#   make clean        the intermediate files
#
# Verilog of the machine: tools/sv2v.sh -> rtl/gbv/gb_machine_sv2v.v (in git); the source lists:
# tools/mkprj.sh (measure/gb.prj, karabas_<board>.prj, in git).

ISE_SETTINGS ?= /opt/Xilinx/14.7/ISE_DS/settings64.sh

SHELL = /bin/bash
.SHELLFLAGS = -e -o pipefail -c

XIL = source $(ISE_SETTINGS) > /dev/null;

prj_src = $(shell sed -n 's/^[a-z]* work "\(.*\)"/\1/p' $(1) 2>/dev/null)

PART = xc6slx25-ftg256-2
BOARDS = minig
KG = gameboy.kg
JSON = core.json

# map / par options (cost table 2 by default, the rule of all the cores)
MAP_T_minig ?= 2
MAP_T_go ?= 2
MAP_T_mini ?= 2
MAP = -logic_opt off -ol high -xe n -xt 3 -register_duplication off -r 4 -global_opt off -mt 2 -detail -ir off -pr b -lc auto -power off
PAR = -ol high -xe c -mt 4

INCLUDES = $(wildcard ../modules/rtl/mcu/*.vh)

.PHONY: all gb-xst gb-report clean $(BOARDS) $(BOARDS:=-xst) $(BOARDS:=-impl) $(BOARDS:=-core) $(BOARDS:=-report)

all: $(BOARDS)

define board
SRC_$(1) := $$(call prj_src,karabas_$(1).prj)

karabas_$(1).ngc: karabas_$(1).prj karabas_$(1).xst $$(SRC_$(1)) $(INCLUDES) rtl/gb_port/boot_rom.hex
	mkdir -p xst/projnav.tmp
	$(XIL) xst -intstyle ise -ifn karabas_$(1).xst -ofn karabas_$(1).syr

karabas_$(1).bin: karabas_$(1).ngc karabas_$(1).ucf karabas_$(1).ut
	$(XIL) ngdbuild -intstyle ise -dd _ngo -nt timestamp -uc karabas_$(1).ucf -p $(PART) karabas_$(1).ngc karabas_$(1).ngd
	$(XIL) map -intstyle ise -p $(PART) -w $(MAP) -t $(MAP_T_$(1)) -o karabas_$(1)_map.ncd karabas_$(1).ngd karabas_$(1).pcf
	$(XIL) par -w -intstyle ise $(PAR) karabas_$(1)_map.ncd karabas_$(1).ncd karabas_$(1).pcf
	$(XIL) trce -intstyle ise -v 3 -s 2 -n 3 -fastpaths -xml karabas_$(1).twx karabas_$(1).ncd -o karabas_$(1).twr karabas_$(1).pcf -ucf karabas_$(1).ucf
	$(XIL) bitgen -intstyle ise -f karabas_$(1).ut karabas_$(1).ncd

kg_$(1).stamp: karabas_$(1).bin $(JSON)
	python3 tools/check_osd.py $(JSON)
	python3 make_core.py $(JSON) $(KG) --boards $(1)
	touch $$@

$(1): kg_$(1).stamp
$(1)-xst: karabas_$(1).ngc
$(1)-impl: karabas_$(1).bin
$(1)-core: kg_$(1).stamp
$(1)-report:
	@grep -E "Number of (Slice LUTs|occupied Slices|RAMB16BWERs|RAMB8BWERs):" karabas_$(1)_map.mrp
	@grep -E "constraints? (was|were) met|constraints? not met|Timing Score" karabas_$(1).par | sort -u
endef

$(foreach b,$(BOARDS),$(eval $(call board,$(b))))

gb_machine.ngc: measure/gb.xst measure/gb.prj $(call prj_src,measure/gb.prj) rtl/gb_port/boot_rom.hex
	mkdir -p xst_gb/projnav.tmp
	$(XIL) xst -intstyle ise -ifn measure/gb.xst -ofn measure/xst_gb.log

gb-xst: gb_machine.ngc

gb-report:
	@grep -E "Number of Slice (Registers|LUTs)|Number of Block RAM/FIFO|Maximum Frequency|Minimum period" measure/xst_gb.log

clean:
	rm -rf xst xst_gb _xmsgs _ngo xlnx_auto_0_xdb *.ngc *.ngr *.ngd *.ncd *.pcf *.lso *.srp *.syr *.bld *.mrp *.map \
		*.par *.pad *.twr *.twx *.xrpt *.unroutes *.drc *.bgn *.bit *_pad.csv *_pad.txt *.ptwx *.xpi *.ngm kg_*.stamp

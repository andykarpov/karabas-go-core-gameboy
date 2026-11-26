# Game Boy / Game Boy Color core for Karabas Go / Mini / Mini G

[Русская версия](README.ru.md)

Nintendo Game Boy and Game Boy Color for the Karabas Go board family (Xilinx Spartan-6 XC6SLX25). A port of the [MiSTer Gameboy core](https://github.com/MiSTer-devel/Gameboy_MiSTer), taken in the form of [Open Pocket GBC](https://github.com/LakoMoor/open-pocket-gbc) by LakoMoor (no gated clocks, no tri-state buses in the mappers), with the board glue of [karabas-go-modules](https://github.com/andykarpov/karabas-go-modules).

| Board | Core file | Video | Sound |
|---|---|---|---|
| Karabas Go | `gameboy.kg` | VGA | I2S DAC (PCM5102) |
| Karabas Mini | `gameboy.kg` | HDMI | HDMI, analog output (sigma-delta) |
| Karabas Mini G | `gameboy.kg` | HDMI | HDMI, I2S DAC |

The core file is in `src/`. The boot ROMs are the open ones of MiSTer (based on [SameBoy](https://github.com/LIJI32/SameBoy), MIT licence), built into the core file: no Nintendo boot ROM is needed. Game images are not included: put your own `.gb` / `.gbc` files on the SD card in `/gameboy`. Free homebrew games to try the core with: [µCity](https://github.com/AntonioND/ucity) (GBC, GPL-3.0), [Libbet and the Magic Floor](https://github.com/pinobatch/libbet) (zlib), and the test ROMs [dmg-acid2](https://github.com/mattcurrie/dmg-acid2) / [cgb-acid2](https://github.com/mattcurrie/cgb-acid2) (MIT).

Status: checked on Mini G. The Go and Mini builds have not been run on a board yet.

## Features

- **Machines:** Game Boy (DMG) and Game Boy Color, GBC double speed, HDMA. The cartridge header selects the model, or the OSD forces one.
- **Mappers:** all of the MiSTer core: MBC1 (and multicarts), MBC2, MBC3 (with the clock), MBC5, MBC6, MBC7, MMM01, HuC1, HuC3, TAMA5, the Game Boy Camera mapper, Sachen, Rocket, Wisdom Tree. ROMs up to 8 MB.
- **Video:** the 160 x 144 picture scaled 4 x 4 (640 x 576) into 800 x 600 at 60 Hz. The machine runs at its own 59.73 Hz: a frame buffer in the SRAM shows the last complete frame, so frames are never torn. Game Boy palettes: grey, green (DMG), Pocket, light green. Game Boy Color: the LCD colour correction (as Gambatte) or the raw colours. Frame blend mixes the last two frames, for the games that use the slow LCD for transparency.
- **Sound:** stereo over HDMI and on the DAC / analog output. The line input of the board (and its MIDI synth) is mixed in (Mini G, Mini).
- **Saves:** the battery RAM of a cartridge is kept in `/gameboy/saves/<game>.sav` on the SD card, written a second after the game changes it, in the format of MiSTer (the RAM, then one 512-byte sector of the clock for MBC3 with a timer).
- **Clock:** the MBC3 clock keeps running while the board is off: at the start it adds the time since the last save, from the clock of the board.

Not done: Super Game Boy, the link cable, save states, cheats; the saves of MBC7 and TAMA5 cartridges (their RAM is in block RAM).

## Getting started

1. Copy `gameboy.kg` (one file for Go, Mini and Mini G) to the root of the SD card.
2. Put your games in `/gameboy` on the SD card.
3. Choose Game Boy in the core menu, choose a game in the file browser (**Menu+Esc** opens it again). Next time the core starts the last game again.

"Menu" is the Windows key of the keyboard.

## OSD menu

| Item | Values | Hotkey |
|---|---|---|
| Model | Auto (the header) / GBC / GB | Menu+M |
| GB palette | Grey / Green / Pocket / Light | Menu+P |
| GBC colours | LCD (colour correction) / Raw | |
| Frame blend | Off / On | |
| Boot | Logo (the boot animation) / Fast | |
| Reset | resets the machine | F12 |

## Controls

| Game Boy | Keyboard | USB pad |
|---|---|---|
| D-pad | arrows | d-pad |
| A | X | A |
| B | Z | B |
| Start | Enter | Start |
| Select | Space or Backspace | Mode, C or X |

The keyboard and both pads drive the one machine.

## Building

Clone with `--recursive` (the `modules` submodule). ISE 14.7: `cd src && make` for all boards or `make minig` for one. The Mini and Go tops (and the timing part of their ucf) are made from the Mini G top by `src/tools/mktops.py`. The Verilog / SystemVerilog of the core is converted to one Verilog-2001 file by `src/tools/sv2v.sh` (into `src/rtl/gbv`); the source lists by `src/tools/mkprj.sh`.

Checks: `src/sim/run.sh` (about 3 min): the frame buffer (`tb_fb`, pixel by pixel), then the whole machine in Verilator (the VHDL through ghdl) running dmg-acid2 through the board path (loader, SDRAM controller, SDRAM model) and cgb-acid2, both compared with their reference pictures. `src/sim/run_bk.sh` (10 s): the clock conversion (`tb_rtc`) and the save memory bridge (`tb_bk`). `src/sim/tests/savetest.gb` (made by `mk_savetest.py`) counts its starts and copies the MBC3 clock into the cartridge RAM: a test of the saves on a board. The plan and the design notes are in [docs/PLAN.md](docs/PLAN.md) (Russian).

## Licence

GPL-3.0 (see [LICENSE](LICENSE)). The MiSTer core is GPL-2.0-or-later, Open Pocket GBC is GPL-3.0, the boot ROMs are MIT (SameBoy).

Game Boy is a trademark of Nintendo. This project is not affiliated with Nintendo.

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Nintendo Game Boy / Game Boy Color core for the Karabas Go, Mini and Mini G boards: Xilinx Spartan-6 XC6SLX25, ISE 14.7 (XST).

Status: Ф0 merged into local master 2026-11-26 (machine import, `src/sim/run.sh` acid2 checks pass, XST 8385 LUT / 28 RAMB16, clk_sys 33.554 MHz); Ф1 (Mini G) next. Machine alone: `cd src && make gb-xst`; after an RTL change run `src/tools/sv2v.sh`. Docs, in Russian: `docs/PLAN.md` (research, decisions, architecture, phases), `docs/BACKLOG.md`. Follow the phases; record a changed decision in PLAN.md.

Base: the MiSTer Gameboy core as it is in [LakoMoor/open-pocket-gbc](https://github.com/LakoMoor/open-pocket-gbc) `rtl/gb` (GPL-3.0; = MiSTer-devel/Gameboy_MiSTer rtl with the gated clocks removed, the mappers' tri-state buses as wired-OR, the cheat engine left out) plus its `rtl/gb_port` stubs (savestates, cheats). The MiSTer repo itself is the reference (and the source of the SameBoy-based boot ROMs, MIT). Get both with `tools/fetch_upstream.sh` (git-ignored, pinned). Keep the upstream headers; mark changed lines `// karabas:`. The core is GPL v3 (`LICENSE`).

All file work goes through the firmware (OSD, `FL` / `F` items, burst): no loader or soft CPU in the core (the RISC-V menu of open-pocket-gbc is not taken).

Pieces from our cores: `../karabas-go-core-wonderswan` (the closest: cartridge in SDRAM `ws_sdram` / `ws_loader`, SRAM frame buffer `ws_fb`, saves `ws_bk` + `kg_bk_ram`, cart RTC from the fw RTC, `tools/vhdl93.py`, `tools/sv2v.sh`, `tools/mktops.py`, verilator sim harness), `../karabas-go-core-sega`.

## Rules of the core

The rules of the other karabas-go cores apply: one clock with enables (no gated / derived clocks), standard video timing with syncs always present, `FT_CLK_OUT` about 8 MHz on Mini / Mini G, Go `FDC_*` outputs 0 when unused, Mini / Mini G drive T3 (`FLASH_CS_N`), OSD switch index = item position unless `"index"`, an OSD value shows 10 characters at most, FL slots 0..7 only, Verilog-2001 for XST (`sv2v` for SV), VHDL-93 for XST, imported code marked `karabas:`.

- No game ROMs in the repo or the `.kg`; free test ROMs (dmg-acid2 / cgb-acid2, homebrew) only under `src/sim/tests` if their licence allows.
- `karabas-go-modules` is shared with other sessions: change it only in a git worktree, PR there, then move the submodule.
- Before a step that needs the board or the HDMI capture, tell the user; capture frames only after a yes; ask before a firmware flash.
- One branch per phase of `docs/PLAN.md`, one PR at its end (local master until the repo is public).
- Heavy builds: Mini G only while working on one feature, all boards for a release; map with cost table 2 first.

## Memory

The Claude Code memory of this repo is shared with all karabas-go repos: `~/.claude/projects/<this project>/memory` is a symlink to `../karabas-go-notes` (private repo `andykarpov/karabas-go-notes`, `link.sh` there makes the links). Its `MEMORY.md` is split by repo; commit and push it after every memory change.

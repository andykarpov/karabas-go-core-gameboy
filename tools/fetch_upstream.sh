#!/bin/sh
# Fetch the Game Boy upstream sources into upstream/ (git-ignored), pinned commits.
#  - LakoMoor/open-pocket-gbc (GPL-3.0): the MiSTer Gameboy core on the Tang Nano 20K, its rtl/gb is
#    the MiSTer rtl with no gated clocks, wired-OR mappers and the cheat engine left out = the base here
#  - MiSTer-devel/Gameboy_MiSTer (GPL-2.0+): the original, reference, SameBoy-based boot ROMs (MIT)
set -eu
cd "$(dirname "$0")/.."
mkdir -p upstream
get() { # dir url commit
	[ -d "upstream/$1/.git" ] || git clone -q "$2" "upstream/$1"
	git -C "upstream/$1" fetch -q origin
	git -C "upstream/$1" checkout -q "$3"
	echo "$1 $(git -C "upstream/$1" rev-parse --short HEAD)"
}
get open_pocket_gbc https://github.com/LakoMoor/open-pocket-gbc.git    865574cf0c5d9c5dfb2b850a8019dd04cab8979f
get gameboy_mister  https://github.com/MiSTer-devel/Gameboy_MiSTer.git f6796f3a021db61f804c3151678941ce4d74a3b9
echo "upstream ok"

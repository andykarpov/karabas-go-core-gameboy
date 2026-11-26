# План ядра Game Boy / Game Boy Color для Karabas Go / Mini / Mini G

Цель: ядро Nintendo Game Boy (DMG) и Game Boy Color (CGB) для плат Karabas (XC6SLX25, ISE 14.7). Картридж — файлом `.gb` / `.gbc` с SD через прошивку (OSD `F`, burst), сейвы картриджа на SD, часы MBC3 от RTC платы. Загрузчика и soft-CPU в ядре нет. Открытые вопросы: `docs/BACKLOG.md`.

## Что изучено (2026-11-26)

| Проект | Что есть | Лицензия | Роль |
|---|---|---|---|
| [MiSTer-devel/Gameboy_MiSTer](https://github.com/MiSTer-devel/Gameboy_MiSTer) (f6796f3, 2026-09) | GB / GBC / SGB, двойная скорость, HDMA, мапперы MBC1/2/3/5/6/7, HuC1/3, MMM01, TAMA5, камера, Sachen, Rocket, MegaDuck; savestates, rewind, читы, link; clk_sys 67,108864 МГц, `ce` ÷16 = 4,194304 МГц; память — `dpram` в BRAM: VRAM 2 × 8 К, WRAM 32 К, HRAM 128, boot ROM 4 К; ПЗУ картриджа в SDRAM, ОЗУ картриджа в BRAM / SDRAM | GPL-2.0+ (заголовки), boot ROM SameBoy — MIT | **эталон**, boot ROM |
| [LakoMoor/open-pocket-gbc](https://github.com/LakoMoor/open-pocket-gbc) (865574c, 2026-10) | тот же `rtl/gb` MiSTer, но: без gated clocks (`clk_sys` + `clken`), мапперы без tristate (wired-OR), читы выключены (`GG_ENGINE`), `gb_port/`: заглушки savestates / CODES / megaduck, обёртки RAM, boot ROM; на GW2AR-18 при 33,75 МГц (÷8, игра на 0,6 % быстрее), буфер кадра в SDRAM, HDMI 480p 3× | GPL-3.0 | **основа** `rtl/gb` + `gb_port` |
| наш `karabas-go-core-wonderswan` (того же автора база open-pocket-ws) | картридж в SDRAM, буфер кадра в SRAM (`ws_fb`), сейвы `kg_bk_ram`, RTC картриджа от RTC прошивки, vhdl93.py, sv2v, mktops.py | наш | **обвязка платы** |

Разница open-pocket-gbc и MiSTer в `rtl/gb` (без CRLF): `gb.v` (38 строк: клоки RAM, `GG_ENGINE`, boot ROM без загрузки), мапперы (tristate → 0), `video.v` (7 строк, массив портов для Verilator), `gbc_snd.vhd` (2 строки). Всё это нужно и нам: XST плохо переносит tristate внутри и gated clocks.

## Решения (предложены 2026-11-26, пользователь сказал «поехали»; поменять — сказать)

1. **Основа — `rtl/gb` из open-pocket-gbc** + его заглушки; MiSTer — эталон для сверки. Импорт с пометкой `// karabas:` и кредитом.
2. **Клок 33,554432 МГц** (`ce` ÷8, как open-pocket-gbc; Ф0: Fmax машины в XST 57 МГц, 67 МГц не проходит). От 50 МГц: DCM_CLKGEN + PLL, как `ws_clocks`.
3. **Видео: буфер кадра в SRAM**, вывод 800 × 600 @ 60 Гц, картинка ×4 = 640 × 576 по центру (кадр GB 59,73 Гц — тройной буфер, как `ws_fb`). Режимы 640 × 480 ×3 — в беклог, если понадобится.
4. **Boot ROM:** открытые SameBoy-based из MiSTer (DMG + CGB, MIT) — в репо и `.kg`; быстрый старт (без анимации) — пункт OSD. Оригинальные Nintendo boot ROM не кладём.
5. **Картридж:** ПЗУ до 8 МБ в SDRAM (OSD `F`, `.gb` / `.gbc`, каталог SD `/gameboy`), разбор заголовка ядром (как MiSTer `ioctl`). ОЗУ картриджа (до 128 КБ) — SDRAM / BRAM по Ф0, сейвы — `kg_bk_ram` в `<игра>.sav`.
6. **Id ядра `gameboy`**, файл `gameboy.kg`. Сначала Mini G, Go и Mini — в фазе релиза. Репо локальное, публичное к первому релизу (спросить).
7. Не берём: savestates, rewind, читы, link cable, SGB, MegaDuck — в беклог. Мапперы — все (Ф0: +914 LUT).

## Архитектура (черновик, уточняется в Ф0)

```
 gb (MiSTer)  ── GBse (T80) + видео + звук APU + таймер + HDMA + мапперы (cart.v)
              ── BRAM: VRAM 16 К, WRAM 32 К, HRAM, boot ROM 4 К (≈ 26 из 52 RAMB16)
 gb_sdram ───── ПЗУ картриджа (+ ОЗУ картриджа), канал загрузки от kg_mcu
 kg_mcu2 ────── F (.gb/.gbc → SDRAM, заголовок → cart), HID (геймпад / клавиатура), OSD, RTC, kg_bk_ram (сейвы)
 gb_fb ──────── 160 × 144 RGB → SRAM (3 буфера) → 800 × 600 ×4
 верх платы ─── клоки, kg_osd_overlay, HDMI + звук, ЦАП
```

## Фазы

Одна ветка на фазу, один PR в конце (локальный master до публикации).

### Ф0. Импорт, симуляция, оценка размера
- `src/rtl/gb/` из open-pocket-gbc (+ `gb_port`), `vhdl93.py` для VHDL (T80, APU), `sv2v` для `.sv`, лишние мапперы / модули — по размеру.
- Verilator: boot ROM SameBoy доходит до картриджа, тестовые ROM (dmg-acid2 / cgb-acid2, homebrew) рисуют кадр → PNG, сверка с эталонной картинкой.
- `make gb-xst`: LUT / FF / RAMB16 / Fmax машины при 67 и 33 МГц; решение по клоку.

**Итог Ф0 (2026-11-26):** `src/rtl/gb/` + `gb_port/` из open-pocket-gbc, обёртка `rtl/karabas/gb_machine.v` (gb + cart_top + ce_gen, ПЗУ / ОЗУ картриджа снаружи, загрузка MiSTer `ioctl`), `tools/sv2v.sh` → `rtl/gbv/gb_machine_sv2v.v` (в git). Правки `karabas:` — порты RAM без значений по умолчанию (sv2v → XST «multi-source»), шина `sprites_extra_store` без tristate (OR), метка ALU в T80 (`ghdl --synth`: `alu_q` против `ALU_Q`). XST машины: 8385 LUT (55 %), 3194 FF, 28 RAMB16, 57 МГц — со всеми мапперами (`ALL_MAPPERS`, +914 LUT против набора open-pocket-gbc). **Клок 33,554432 МГц** (`ce` ÷8, как open-pocket-gbc): 67 МГц не проходит. `src/sim/run.sh` (~2,5 мин, Verilator + ghdl): dmg-acid2 и cgb-acid2 совпадают с эталонными кадрами пиксель в пиксель (CGB boot ROM с быстрым стартом — картинка с ~75-го кадра). Пиксель LCD = `lcd_ce & lcd_clkena` (как `lcd.v` MiSTer).

### Ф1. Game Boy на Mini G
- Верх Mini G (от wonderswan), клоки, `gb_sdram` + загрузка `F`, `gb_fb` 800 × 600, OSD, геймпад / клавиатура → кнопки GB, звук HDMI + ЦАП.
- OSD: Model (Auto / GBC / GB), Boot (Logo / Fast), Frame blend, Reset. Проверка на плате.

**Итог Ф1 (2026-11-26):** `rtl/karabas/`: `gb_clocks` (DCM 50 × 47 / 70 → PLL: clk_sys 33,571 МГц, clk_ram 100,71, видео 40 / 200), `gb_sdram` (= `ws_sdram`), `gb_loader` (файл → SDRAM ch1 + MiSTer `ioctl` в cart_top), `gb_mem` (шина картриджа → ch3 по фронту `sdram_rd` / `cram_wr`, ОЗУ картриджа с 8 МБ, refresh вне циклов чтения), `gb_kbd`, `gb_fb` (кольцо 8 кадров в SRAM, 160 × 144 ×4 в 800 × 600 @ 60, смешение двух кадров). Симуляция: `sim/run_fb.sh` (iverilog, три режима попиксельно), `sim/sim_top.v` + `sim_sys.cpp` — путь платы (загрузчик → SDRAM-модель → машина): dmg-acid2 и cgb-acid2 = эталон, ошибок SDRAM 0. Сборка Mini G 26112601: 68 % LUT, 88 % слайсов, 29 RAMB16 + 4 RAMB8, тайминги сошлись (map -t 2). **На плате (26112601):** HDMI 800 × 600 принят захватом, OSD и файловый браузер (`/gameboy`), dmg-acid2 и cgb-acid2 — правильные картинки, µCity (MBC5, 128 КБ) — заставка и меню, клавиатура и геймпад, звук по HDMI есть (пик −19 дБ, постоянное смещение ≈ +1800 — DC-фильтр в Ф3).

### Ф2. Сейвы и часы
- ОЗУ картриджа → `kg_bk_ram` (`.sav`), MBC3 RTC от RTC прошивки (как wonderswan).

### Ф3. Опции, Go / Mini, релиз
- OSD: палитры DMG, коррекция цвета GBC, быстрый старт, (смешение кадров — против мерцания).
- Верхи Go / Mini (`mktops.py`), три платы, `gameboy.kg`, README.md + README.ru.md, `cores.json` karabas-go.

## Риски

| Риск | Что делаем |
|---|---|
| Fmax машины ниже 67 МГц в XST | клок 33,55 МГц (÷8), как open-pocket-gbc |
| BRAM: машина ~26 RAMB16 + OSD / HDMI | ОЗУ картриджа в SDRAM, lcd_color_lut в LUT / ROM |
| Мапперы с tristate, SV-файлы | версии open-pocket-gbc (wired-OR) + sv2v |
| Частота кадра 59,73 Гц ≠ 60 | тройной буфер в SRAM (как wonderswan), редкий повтор кадра |
| Права на игры | в репо и `.kg` только открытые boot ROM; тесты — свободные ROM |

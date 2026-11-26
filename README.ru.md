# Ядро Game Boy / Game Boy Color для Karabas Go / Mini / Mini G

[English version](README.md)

Nintendo Game Boy и Game Boy Color для плат семейства Karabas Go (Xilinx Spartan-6 XC6SLX25). Порт [ядра Gameboy для MiSTer](https://github.com/MiSTer-devel/Gameboy_MiSTer) в варианте [Open Pocket GBC](https://github.com/LakoMoor/open-pocket-gbc) (LakoMoor: без стробируемых клоков, мапперы без tristate-шин), с обвязкой платы из [karabas-go-modules](https://github.com/andykarpov/karabas-go-modules).

| Плата | Файл ядра | Видео | Звук |
|---|---|---|---|
| Karabas Go | `gameboy.kg` | VGA | I2S ЦАП (PCM5102) |
| Karabas Mini | `gameboy.kg` | HDMI | HDMI, аналоговый выход (сигма-дельта) |
| Karabas Mini G | `gameboy.kg` | HDMI | HDMI, I2S ЦАП |

Файл ядра лежит в `src/`. Загрузочные ПЗУ — открытые из MiSTer (на основе [SameBoy](https://github.com/LIJI32/SameBoy), лицензия MIT), они встроены в файл ядра: ПЗУ Nintendo не нужны. Образов игр в комплекте нет: положите свои `.gb` / `.gbc` на SD-карту в `/gameboy`. Свободные homebrew-игры для проверки: [µCity](https://github.com/AntonioND/ucity) (GBC, GPL-3.0), [Libbet and the Magic Floor](https://github.com/pinobatch/libbet) (zlib), тестовые ROM [dmg-acid2](https://github.com/mattcurrie/dmg-acid2) / [cgb-acid2](https://github.com/mattcurrie/cgb-acid2) (MIT).

Состояние: проверено на Mini G. Сборки для Go и Mini на платах ещё не запускались.

## Возможности

- **Машины:** Game Boy (DMG) и Game Boy Color, двойная скорость GBC, HDMA. Модель выбирается по заголовку картриджа или задаётся в OSD.
- **Мапперы:** все из ядра MiSTer: MBC1 (и мультикартриджи), MBC2, MBC3 (с часами), MBC5, MBC6, MBC7, MMM01, HuC1, HuC3, TAMA5, маппер Game Boy Camera, Sachen, Rocket, Wisdom Tree. ПЗУ до 8 МБ.
- **Видео:** картинка 160 × 144, увеличенная 4 × 4 (640 × 576), в режиме 800 × 600 @ 60 Гц. Машина работает на своих 59,73 Гц: буфер кадров в SRAM показывает последний целый кадр, кадр никогда не рвётся. Палитры Game Boy: серая, зелёная (DMG), Pocket, светло-зелёная. Game Boy Color: коррекция цвета ЖК (как в Gambatte) или исходные цвета. Смешение кадров усредняет два последних кадра — для игр, которые используют медленный ЖК для прозрачности.
- **Звук:** стерео по HDMI и на ЦАП / аналоговый выход. Линейный вход платы (и её MIDI-синтезатор) подмешивается в звук (Mini G, Mini).
- **Сохранения:** батарейное ОЗУ картриджа хранится в `/gameboy/saves/<игра>.sav` на SD-карте и пишется через секунду после изменения, в формате MiSTer (ОЗУ, затем сектор 512 байт часов для MBC3 с таймером).
- **Часы:** часы MBC3 идут и при выключенной плате: при старте к ним прибавляется время с последнего сохранения по часам платы.

Не сделано: Super Game Boy, кабель связи, сохранения состояния, читы; сохранения картриджей MBC7 и TAMA5 (их ОЗУ в блочной памяти).

## Начало работы

1. Скопируйте `gameboy.kg` (один файл для Go, Mini и Mini G) в корень SD-карты.
2. Положите игры в `/gameboy` на SD-карте.
3. Выберите Game Boy в меню ядер и игру в файловом браузере (**Menu+Esc** открывает его снова). В следующий раз ядро запустит последнюю игру само.

«Menu» — клавиша Windows на клавиатуре.

## Меню OSD

| Пункт | Значения | Горячая клавиша |
|---|---|---|
| Model | Auto (по заголовку) / GBC / GB | Menu+M |
| GB palette | Grey / Green / Pocket / Light | Menu+P |
| GBC colours | LCD (коррекция цвета) / Raw | |
| Frame blend | Off / On | |
| Boot | Logo (анимация загрузки) / Fast | |
| Reset | сброс машины | F12 |

## Управление

| Game Boy | Клавиатура | USB-геймпад |
|---|---|---|
| Крестовина | стрелки | крестовина |
| A | X | A |
| B | Z | B |
| Start | Enter | Start |
| Select | Пробел или Backspace | Mode, C или X |

Клавиатура и оба геймпада управляют одной машиной.

## Сборка

Клонируйте с `--recursive` (сабмодуль `modules`). ISE 14.7: `cd src && make` — все платы, `make minig` — одна. Верхние модули Mini и Go (и временная часть их ucf) делает из верха Mini G скрипт `src/tools/mktops.py`. Verilog / SystemVerilog ядра сводится в один файл Verilog-2001 скриптом `src/tools/sv2v.sh` (в `src/rtl/gbv`), списки исходников — `src/tools/mkprj.sh`.

Проверки: `src/sim/run.sh` (около 3 мин): буфер кадров (`tb_fb`, попиксельно), затем вся машина в Verilator (VHDL через ghdl): dmg-acid2 через путь платы (загрузчик, контроллер SDRAM, модель SDRAM) и cgb-acid2, обе сравниваются с эталонными картинками. `src/sim/run_bk.sh` (10 с): перевод времени (`tb_rtc`) и мост памяти сохранений (`tb_bk`). `src/sim/tests/savetest.gb` (делает `mk_savetest.py`) считает свои запуски и копирует часы MBC3 в ОЗУ картриджа — тест сохранений на плате. План и заметки по устройству — [docs/PLAN.md](docs/PLAN.md).

## Лицензия

GPL-3.0 (см. [LICENSE](LICENSE)). Ядро MiSTer — GPL-2.0-or-later, Open Pocket GBC — GPL-3.0, загрузочные ПЗУ — MIT (SameBoy).

Game Boy — товарный знак Nintendo. Проект не связан с Nintendo.

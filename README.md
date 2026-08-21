# Apple IIe Core for MEGA65 (using the MiSTer2MEGA65 Framework)

A port of the Apple IIe FPGA reconstruction to the **MEGA65**, built on the **M2M framework**.  
This core delivers a cycle‑accurate Apple IIe experience on modern MEGA65 hardware, including disk, audio, and expansion‑card support.

## Overview

This project adapts the MiST/MiSTer Apple IIe core for the MEGA65 architecture using the M2M hardware abstraction layer.  
The original implementation was a VHDL reconstruction of a 1980s Apple ][+, later extended with //e features, language card, Mockingboard, and slot‑based expansions.

The MEGA65 version integrates these features while providing a modern OSD, stable disk I/O, and MEGA65‑native input/video/audio routing.

## Credits:  

MiSTer2MEGA65 Framework - sy2002 & MJoergen  
 * https://github.com/sy2002/MiSTer2MEGA65/

MiSTer Apple IIe Core - Sorgelig, Alanswx, Newsdee, Steven-a-wilson & birdybro  
 * https://github.com/alanswx/Apple-II_MiSTer/  
 * https://github.com/MiSTer-devel/Apple-II_MiSTer/  

---

## Features

- **Disk loading via OSD**  
  Supports: `.nib` only at this stage
  **Note:** Only `.nib` images persist disk writes.

- **Hard‑disk support**  
  Support is planned   

- **MEGA65 Keyboard mapping**  
  Supports MEGA65 key mapping or Apple II

- **Tape loading** via ADC‑in  
  Support is planned   

- **Selectable CPU**  
  6502 or 65C02

- **Custom video ROM loading**  
  Default: US/UK character ROM

- **Joystick support**  
  Commodore or Atari style joysticks supported  
  A second button is also supported via PotX/PotY

- **Mouse support**  
  Amiga-compatible quadrature mice are supported through the MEGA65 joystick port 2.  
  Commodore 1350 and 1351 mouse support is planned for a future release.
  Atari ST mice - very feasible with another quadrature mapping.  
  **Do not connect an original Apple II mouse to the MEGA65.** Although Apple II and Amiga mice use a similar connector, the Apple mouse has an electrically incompatible pinout, including different **+5 V and GND pin assignments**, and may damage the mouse or MEGA65.

- **Display modes**  
  Color, amber, green, monochrome  
  Optional scanlines

- **Color palette selection**  
  NTSC //e, Apple IIgs, AppleWin  
  **No custom palette supported yet**

- **Memory & expansion cards**
  - 64K base + 64K auxiliary RAM (80‑column + DHGR)
  - Saturn 128K RAM expansion ( currently untested but enabled in the core )
  - Language card
  - ProDOS‑compatible clock card
  - Super Serial Card ( currently untested but enabled in the core )
  - Mockingboard Model A


## Keyboard Shortcuts

- **Restore**               — Closed Apple  
- **MEGA**                  — Open Apple  
- **MEGA+Ctrl+F13**         — Soft Reset
- **MEGA+Ctrl+F13+Restore** — Memory Test 

### MEGA65 Keyboard Mapping

The optional **MEGA65 Keyboard Layout** remaps the Apple IIe keyboard to follow the symbols and legends printed on the physical MEGA65 keyboard. This makes typing considerably more intuitive than using the original Apple II key positions.

Most keys produce the character shown on the keycap. **Shift** is used for the normal shifted legends, while **ALT** acts as a second modifier for symbols printed on the **front face of the MEGA65 keycaps**.

#### ALT / Front-Face Symbols

| MEGA65 Key | Output |
|---|---|
| `ALT` + `←` | `` ` `` |
| `ALT` + `,` | `~` |
| `ALT` + `.` | `\|` |
| `ALT` + `/` | `\` |
| `ALT` + `:` | `{` |
| `ALT` + `;` | `}` |
| `ALT` + `=` | `_` |

#### Shifted Symbols

The normal shifted mappings follow the MEGA65 keycap legends where applicable:

| MEGA65 Key | Output |
|---|---|
| `Shift` + `:` | `[` |
| `Shift` + `;` | `]` |

Where the MEGA65 provides a dedicated key for a symbol, that key is used directly. For example, `+` has its own key, so `Shift` + `=` remains `+`. Similarly, `Shift` + `-` remains `-`, with `_` available using `ALT` + `=`.

The MEGA65 `£/#` key maps to the equivalent Apple II `Shift` + `3` character. Whether this appears as `£` or `#` depends on the selected Apple II video/character ROM.

The non-directional `↑` power-symbol key is currently unused in MEGA65 layout mode. The directional cursor keys are unaffected and retain their normal Apple II cursor functions.

The original **Apple II Keyboard Layout** remains available through the OSD for users who prefer the original positional keyboard mapping.

---

## Apple II Slot Map

| Slot | Device |
|------|--------|
| 0 | Language card |
| 1 | Clock card (ProDOS compatible) |
| 2 | Super Serial Card (untested) |
| 3 | 80‑column + 64K RAM expansion |
| 4 | Mockingboard Model A |
| 5 | Saturn 128K RAM expansion (untested)|
| 6 | Disk II controller |
| 7 | HDD controller - (support planned) |

---

## A note about PoTX/PotY polarity

**Note – Commodore Joysticks and Power-On Self-Test**

When using a Commodore-style joystick with a second fire button connected through **POTX/POTY**, ensure that the **joy button 2 - polarity** setting in the OSD is correct.

If the polarity is reversed, Button 2 may appear permanently pressed to the Apple II during startup. This is equivalent to holding the **Closed Apple** key while powering on the machine and can cause the Apple IIe to enter its built-in **Power-On Self-Test / RAM test** instead of booting normally.

If the core unexpectedly starts the RAM test when a joystick is connected, change the **Button 2 Polarity** setting in the OSD and reset the core.

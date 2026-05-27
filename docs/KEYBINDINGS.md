# DEVILSEC · Keybindings

A complete reference. The scheme is built around a **modifier convention**:

| Modifier              | Meaning                                              |
|-----------------------|------------------------------------------------------|
| `Super`               | window operations — focus, swap, close, layout       |
| `Super + Shift`       | workspace operations — send window                   |
| `Super + Alt`         | DEVILSEC actions — styx, themes, screenshots         |
| `Super + Ctrl`        | resize and structural changes                        |

Once internalised, this gets out of your way.

---

## Core

| Keys                       | Action                                          |
|----------------------------|-------------------------------------------------|
| `Super + Return`           | Open terminal (kitty)                           |
| `Super + d`                | Application launcher (rofi)                     |
| `Super + Tab`              | Window switcher                                 |
| `Super + r`                | Run command                                     |
| `Super + w`                | Close focused window                            |
| `Super + Shift + w`        | Kill focused window                             |
| `Super + Alt + r`          | Reload bspwm                                    |
| `Super + Alt + q`          | Quit bspwm session                              |
| `Super + Alt + l`          | Lock screen                                     |

## DEVILSEC actions

| Keys                       | Action                                          |
|----------------------------|-------------------------------------------------|
| **`Super + Alt + s`**      | **Open styx (graphical)**                       |
| `Super + Alt + w`          | Cycle wallpaper                                 |
| `Super + Alt + t`          | Cycle theme                                     |
| `Print`                    | Screenshot region (flameshot GUI)               |
| `Super + Print`            | Screenshot full screen                          |
| `Super + Shift + Print`    | Screenshot current monitor                      |

## Focus & movement

| Keys                                | Action                                  |
|-------------------------------------|-----------------------------------------|
| `Super + Left/Down/Up/Right`        | Focus window in direction               |
| `Super + h/j/k/l`                   | Focus window in direction (vim style)   |
| `Super + Shift + Left/Down/Up/Right`| Swap windows                            |
| `Super + Shift + h/j/k/l`           | Swap windows (vim style)                |
| `Super + p` / `Super + n`           | Focus previous / next in tree           |
| `Super + [` / `Super + ]`           | Focus older / newer in history          |

## Workspaces

| Keys                       | Action                                          |
|----------------------------|-------------------------------------------------|
| `Super + 1..9`             | Switch to workspace                             |
| `Super + Shift + 1..9`     | Send window to workspace                        |
| `Super + Alt + 1..9`       | Send and follow                                 |
| `Super + ,`                | Previous workspace                              |
| `Super + .`                | Next workspace                                  |

## Layout

| Keys                       | Action                                          |
|----------------------------|-------------------------------------------------|
| `Super + f`                | Toggle floating                                 |
| `Super + Shift + f`        | Toggle fullscreen                               |
| `Super + m`                | Cycle layout (monocle ↔ tiled)                  |
| `Super + Shift + p`        | Toggle pseudo-tiled                             |
| `Super + Shift + b`        | Balance tree                                    |

## Resize

| Keys                                | Action                                  |
|-------------------------------------|-----------------------------------------|
| `Super + Ctrl + Left/Down/Up/Right` | Resize edge                             |
| `Super + Ctrl + h/j/k/l`            | Resize edge (vim style)                 |
| `Super + Mouse Left`                | Select/drag with mouse                  |
| `Super + Mouse Middle`              | Move window                             |
| `Super + Mouse Right`               | Resize from corner                      |

## Media keys

| Keys                       | Action                                          |
|----------------------------|-------------------------------------------------|
| `XF86AudioRaiseVolume`     | Volume +5%                                      |
| `XF86AudioLowerVolume`     | Volume -5%                                      |
| `XF86AudioMute`            | Toggle mute                                     |
| `XF86AudioPlay/Stop/...`   | Media player control (playerctl)                |
| `XF86MonBrightnessUp/Down` | Backlight ± 5%                                  |

## Inside kitty (terminal)

| Keys                       | Action                                          |
|----------------------------|-------------------------------------------------|
| `Ctrl + Shift + t`         | New tab in current directory                    |
| `Ctrl + Shift + Enter`     | New window in current directory                 |
| `Ctrl + Shift + w`         | Close tab                                       |
| `Ctrl + Shift + l/h`       | Next / previous window                          |
| `Ctrl + Shift + +/-`       | Font bigger / smaller                           |
| `Ctrl + Shift + 0`         | Reset font size                                 |

## Inside rofi

| Keys                       | Action                                          |
|----------------------------|-------------------------------------------------|
| `Ctrl + j` / `Ctrl + k`    | Next / previous entry                           |
| `Ctrl + Tab`               | Next mode                                       |
| `Ctrl + Shift + Tab`       | Previous mode                                   |
| `Enter`                    | Select                                          |
| `Escape`                   | Cancel                                          |

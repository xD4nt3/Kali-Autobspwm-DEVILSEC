<div align="center">

# DEVILSEC Environment

<img src="docs/devilsec-preview.png" width="850" alt="DEVILSEC Kali bspwm environment preview">

<br>

![Kali Linux](https://img.shields.io/badge/Kali-Linux-557C94?style=for-the-badge&logo=kalilinux&logoColor=white)
![bspwm](https://img.shields.io/badge/WM-bspwm-8A2BE2?style=for-the-badge)
![Shell](https://img.shields.io/badge/Shell-zsh-DC2641?style=for-the-badge)
![Terminal](https://img.shields.io/badge/Terminal-kitty-D4AF37?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-7FB069?style=for-the-badge)

### A custom offensive-security desktop environment for Kali Linux.

**bspwm · sxhkd · polybar · picom · kitty · rofi · zsh · styx · offensive arsenal**

> “Power, given by others, is never truly yours.”

</div>

---

## Overview

**DEVILSEC Environment** is a custom Kali Linux setup designed for offensive security, CTFs, Active Directory labs, web hacking, pivoting, recon and daily operator workflow.

It transforms a clean Kali installation into a fast, minimal, keyboard-driven and highly customized desktop based on **bspwm**, with a full hacker-style visual layer, custom wallpapers, terminal workflow, keybindings, helper scripts and a centralized control panel called **`styx`**.

This environment was built with a practical idea:

> Less clicking. More hacking.

---

## Preview

<img src="docs/devilsec-preview.png" width="850">
<img src="docs/devilsec2.png" width="850">
<img src="docs/preview0.png" width="850">
<img src="docs/preview2.png" width="850">
<img src="docs/preview3.png" width="850">
<img src="docs/preview4.png" width="850">

## Features

### Desktop Stack

| Component | Purpose |
|---|---|
| `bspwm` | Tiling window manager |
| `sxhkd` | Keyboard shortcut daemon |
| `polybar` | Status bar with launchers and system info |
| `picom` | Compositor, shadows and transparency |
| `kitty` | GPU terminal with tabs and background opacity |
| `rofi` | Application launcher and menus |
| `dunst` | Notification daemon |
| `zsh` | Main shell |
| `starship` | Modern prompt |
| `fastfetch` | Terminal system banner |
| `styx` | DEVILSEC control panel |

---

## What makes it different?

### `styx` control panel

`styx` is the command center of the environment.

It allows you to control wallpapers, themes, opacity, polybar, brightness, gamma, tools, scope and help panels from a terminal UI or from rofi.

```bash
styx
styx -g
styx -m wallpaper
styx -m opacity
styx -m theme
styx -m polybar
styx -m tools
styx -m scope
styx -m help
```

Open graphical `styx` with:

```text
Super + Alt + S
```

---

### Keyboard layout switcher

DEVILSEC includes an instant keyboard layout switcher for X11.

Useful when jumping between English keyboards and Latin American layouts.

```bash
devilsec-keyboard
devilsec-keyboard us
devilsec-keyboard latam
devilsec-keyboard show
```

Alias:

```bash
kb
teclado
```

Shortcut:

```text
Super + Alt + K
```

Available layouts:

| Option | Layout |
|---|---|
| `us` | English US |
| `latam` | Latin America with dead tilde |
| `show` | Show current layout |

---

### Background-only opacity

DEVILSEC does not use the old “make the whole window transparent” trick.

Instead, kitty uses native background opacity, so:

- Terminal background becomes transparent.
- Text remains solid.
- Cursor remains solid.
- Selection remains readable.
- No more ghost text.

Commands:

```bash
devilsec-opacity show
devilsec-opacity 80
devilsec-opacity 100
devilsec-opacity reset
devilsec-opacity apply
```

Through `styx`:

```bash
styx -m opacity
```

Kitty live controls:

```text
Ctrl + Shift + O    Increase opacity
Ctrl + Shift + I    Decrease opacity
```

---

### Offensive arsenal

DEVILSEC installs and organizes several offensive security tools under:

```text
/opt/devilsec/bin
/opt/devilsec/tools
/opt/devilsec/share
```

Everything under `/opt/devilsec/bin` is added to `$PATH`.

View the arsenal:

```bash
devilsec-arsenal
devilsec-arsenal --list
devilsec-arsenal --raw
devilsec-arsenal --search ldap
devilsec-arsenal pivoting
devilsec-arsenal active-directory
devilsec-arsenal impacket
```

Aliases:

```bash
arsenal
pivoting
adtools
```

Categories:

| Category | Examples |
|---|---|
| Active Directory | `nxc`, `bloodyAD`, `certipy`, `kerbrute`, `evil-winrm` |
| Impacket | `psexec.py`, `secretsdump.py`, `GetUserSPNs.py`, `ntlmrelayx.py` |
| Pivoting | `ligolo`, `ligolo-proxy`, `chisel` |
| Relay / Coercion | `coercer`, `mitm6`, `pretender`, `donpapi` |
| Recon / Web | `ffuf`, `gowitness`, `enum4linux-ng` |
| PrivEsc / Post-Exploitation | `peas-serve`, `updog`, `shellpop` |

---

## Installation

### Recommended

Use this on a clean Kali Linux installation.

```bash
git clone https://github.com/<TU_USUARIO>/<TU_REPO>.git
cd <TU_REPO>
chmod +x install.sh
bash install.sh
```

After installation:

```bash
reboot
```

At the login screen, select:

```text
bspwm
```

Then log in normally.

---

## Installation notes

Do **not** run the installer as root.

Correct:

```bash
bash install.sh
```

Incorrect:

```bash
sudo bash install.sh
```

The installer will request `sudo` only when needed.

---

## Installer phases

The installer is split into phases:

```text
00-preflight     Preflight checks and system update
10-base          Base packages, build dependencies and fonts
20-wm            bspwm, sxhkd, picom, polybar, rofi, kitty
30-shell         zsh, starship and shell plugins
40-tools         Offensive toolchain
50-bloodhound    BloodHound CE, optional
60-wordlists     SecLists, PayloadsAllTheThings and rockyou
70-dotfiles      Dotfiles, themes and wallpapers
80-styx          styx control panel and helper commands
99-postflight    Final sanity report
```

Installer log:

```bash
cat .summon.log
```

---

## Repository layout

```text
devilsec/
├── install.sh
├── LICENSE
├── README.md
├── PATCHES-INTEGRATED.md
│
├── assets/
│   └── devilsec-logo.txt
│
├── config/
│   ├── bspwm/
│   ├── dunst/
│   ├── fastfetch/
│   ├── kitty/
│   ├── nvim/
│   ├── picom/
│   ├── polybar/
│   ├── rofi/
│   ├── sxhkd/
│   ├── zsh/
│   └── starship.toml
│
├── core/
│   ├── forge.sh
│   └── phases/
│
├── docs/
│   ├── CUSTOMIZATION.md
│   ├── KEYBINDINGS.md
│   └── TROUBLESHOOTING.md
│
├── scripts/
│   ├── commands/
│   ├── system/
│   └── visual/
│
├── themes/
│   ├── polybar-themes/
│   ├── rofi-themes/
│   └── wallpapers/
│
└── tools-installer/
```

---

## Main commands

### Control center

```bash
styx
styx -g
styx -m wallpaper
styx -m opacity
styx -m theme
styx -m polybar
styx -m compositor
styx -m brightness
styx -m gamma
styx -m font
styx -m tools
styx -m scope
styx -m help
styx -m about
```

---

### Wallpaper commands

```bash
set-wallpaper
set-wallpaper /path/to/image.png
set-wallpaper --any
styx -m wallpaper
```

Wallpaper state:

```text
~/.config/devilsec/wallpaper.state
~/.config/devilsec-wallpaper
```

Installed wallpapers:

```text
~/Pictures/devilsec-wallpapers/
```

---

### Opacity commands

```bash
devilsec-opacity show
devilsec-opacity 80
devilsec-opacity 100
devilsec-opacity reset
devilsec-opacity apply
devilsec-opacity daemon
styx -m opacity
```

Opacity state:

```text
~/.config/devilsec/opacity.state
```

---

### Keyboard commands

```bash
devilsec-keyboard
devilsec-keyboard us
devilsec-keyboard latam
devilsec-keyboard show
```

Aliases:

```bash
kb
teclado
```

Keyboard state:

```text
~/.config/devilsec/keyboard.state
```

---

### Scope manager

```bash
styx -m scope
```

Scope files:

```text
~/.config/devilsec/scope.list
~/.config/devilsec/target-ip
```

Copy target IP:

```bash
devilsec-copy-ip target
```

Shortcut:

```text
Super + Shift + F3
```

---

### IP helpers

```bash
devilsec-copy-ip local
devilsec-copy-ip vpn
devilsec-copy-ip target
```

Shortcuts:

```text
Super + Shift + F1    Copy local IP
Super + Shift + F2    Copy VPN IP
Super + Shift + F3    Copy target IP
```

---

### CTF workflow helpers

```bash
mkt lab-name
extract-ports scan.gnmap
xcopy file.txt
cat file.txt
catl file.txt
catn file.txt
```

`mkt` creates a CTF-style workspace:

```text
lab-name/
├── nmap/
├── content/
├── exploits/
├── scripts/
├── loot/
└── screenshots/
```

---

### Wordlists

```bash
wlfind directory
wlfind raft -l
```

Wordlist root:

```text
/opt/devilsec/wordlists/
```

Included:

```text
/opt/devilsec/wordlists/SecLists
/opt/devilsec/wordlists/PayloadsAllTheThings
/opt/devilsec/wordlists/rockyou.txt
```

---

### Pivoting

```bash
ligolo
ligolo proxy
ligolo proxy 11601
ligolo stage
ligolo serve
```

Staged agents:

```text
/opt/devilsec/share/pivoting/ligolo/
```

---

### BloodHound CE

BloodHound CE is optional during installation.

```bash
bloodhound-ce status
bloodhound-ce up
bloodhound-ce down
bloodhound-ce restart
bloodhound-ce logs
bloodhound-ce update
bloodhound-ce nuke
```

Default UI:

```text
http://localhost:8080/ui/login
```

---

### PEASS

```bash
peas-serve
peas-serve 8080
```

Serves PEASS-ng from:

```text
/opt/devilsec/share/peass
```

---

### Network helpers

```bash
nmcli-connect-device
nmcli-connect-device "SSID" "PASSWORD"

nmcli-disconnect-device
nmcli-list-active-connections
nmcli-list-all-connections
nmcli-list-devices
nmcli-scan-wifi
nmcli-wifi-info
nmcli-wifi-on
nmcli-wifi-off
nmcli-wwan-on
nmcli-wwan-off

nmcli-create-hotspot
nmcli-create-hotspot DEVILSEC-AP devilsec123

nmcli-delete-connection "connection-name"
nmcli-up-connection "connection-name"
nmcli-down-connection "connection-name"
nmcli-restart-networking
```

---

### History helpers

```bash
clearHistory
removeHistory
```

`clearHistory` clears the current zsh in-memory history.

`removeHistory` deletes the zsh history file after confirmation.

---

## Keyboard shortcuts

> `Super` means the Windows key.

---

### Core

| Shortcut | Action |
|---|---|
| `Super + Return` | Open kitty |
| `Super + Shift + Return` | Open floating kitty |
| `Super + D` | Rofi app launcher |
| `Super + Shift + D` | Rofi app launcher |
| `Super + Tab` | Rofi window switcher |
| `Super + R` | Rofi run prompt |
| `Super + Shift + P` | Power menu |
| `Super + Shift + S` | Scope manager |
| `Super + Escape` | Reload sxhkd |
| `Super + Shift + R` | Reload bspwm |
| `Super + Shift + Q` | Quit bspwm session |
| `Super + Ctrl + L` | Lock screen |

---

### DEVILSEC actions

| Shortcut | Action |
|---|---|
| `Super + Alt + S` | Open styx graphical control panel |
| `Super + Alt + K` | Open keyboard layout switcher |

---

### Kitty tabs through bspwm shortcuts

| Shortcut | Action |
|---|---|
| `Super + Alt + T` | New kitty tab |
| `Super + Alt + W` | Close kitty tab |
| `Super + Alt + L` | Next kitty tab |
| `Super + Alt + H` | Previous kitty tab |
| `Super + Alt + N` | Rename kitty tab |
| `Super + Alt + Shift + L` | Move kitty tab forward |
| `Super + Alt + Shift + H` | Move kitty tab backward |

---

### IP helpers

| Shortcut | Action |
|---|---|
| `Super + Shift + F1` | Copy local IP |
| `Super + Shift + F2` | Copy VPN IP |
| `Super + Shift + F3` | Copy target IP |

---

### Brightness, volume and temperature

| Shortcut | Action |
|---|---|
| `XF86MonBrightnessDown` | Brightness down |
| `XF86MonBrightnessUp` | Brightness up |
| `Super + F2` | Brightness down |
| `Super + F3` | Brightness up |
| `Super + F5` | Toggle mute |
| `Super + F6` | Volume down |
| `Super + F7` | Volume up |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `Super + F8` | Toggle color temperature |
| `Super + F9` | Temperature down |
| `Super + F10` | Temperature up |

---

### Window management

| Shortcut | Action |
|---|---|
| `Super + W` | Close focused window |
| `Super + Shift + W` | Kill focused window |
| `Super + S` | Toggle floating |
| `Super + M` | Cycle desktop layout |
| `Super + F` | Toggle fullscreen |
| `Super + T` | Set window back to tiled |
| `Super + Shift + B` | Balance bspwm tree |

---

### Focus

| Shortcut | Action |
|---|---|
| `Super + Left` | Focus window west |
| `Super + Down` | Focus window south |
| `Super + Up` | Focus window north |
| `Super + Right` | Focus window east |

---

### Preselectors

| Shortcut | Action |
|---|---|
| `Super + Shift + Left` | Preselect west |
| `Super + Shift + Down` | Preselect south |
| `Super + Shift + Up` | Preselect north |
| `Super + Shift + Right` | Preselect east |
| `Super + Shift + Space` | Cancel preselection |

---

### Resize

| Shortcut | Action |
|---|---|
| `Super + Alt + Left` | Expand window left |
| `Super + Alt + Right` | Expand window right |
| `Super + Alt + Up` | Expand window up |
| `Super + Alt + Down` | Expand window down |
| `Super + Alt + Shift + Left` | Contract window from left/right |
| `Super + Alt + Shift + Right` | Contract window from right/left |
| `Super + Alt + Shift + Up` | Contract window vertically |
| `Super + Alt + Shift + Down` | Contract window vertically |

---

### Move floating windows

| Shortcut | Action |
|---|---|
| `Super + Ctrl + Left` | Move floating window left |
| `Super + Ctrl + Down` | Move floating window down |
| `Super + Ctrl + Up` | Move floating window up |
| `Super + Ctrl + Right` | Move floating window right |

---

### Mouse bindings

| Shortcut | Action |
|---|---|
| `Super + Left Click` | Select / move window |
| `Super + Middle Click` | Move window |
| `Super + Right Click` | Resize window from corner |

---

### Workspaces

| Shortcut | Action |
|---|---|
| `Super + 1` to `Super + 9` | Switch to workspace 1-9 |
| `Super + 0` | Switch to workspace 10 |
| `Super + Shift + 1` to `Super + Shift + 9` | Send window to workspace 1-9 |
| `Super + Shift + 0` | Send window to workspace 10 |
| `Super + Ctrl + 1` to `Super + Ctrl + 9` | Send window to workspace and follow |
| `Super + Ctrl + 0` | Send window to workspace 10 and follow |

---

### Screenshots

| Shortcut | Action |
|---|---|
| `Print` | Flameshot region screenshot |
| `Super + Print` | Full screenshot to `~/Pictures` |
| `Shift + Print` | Current screen screenshot to `~/Pictures` |

---

### Applications

| Shortcut | Action |
|---|---|
| `Super + Shift + F` | Firefox |
| `Super + Shift + B` | Burp Suite |
| `Super + Shift + V` | VS Code |
| `Super + Shift + G` | Thunar |
| `Super + Shift + E` | Wireshark |
| `Super + Shift + A` | Postman |
| `Super + Shift + O` | Obsidian |

---

### Media

| Shortcut | Action |
|---|---|
| `XF86AudioPlay` | Play / pause |
| `XF86AudioStop` | Stop |
| `XF86AudioPrev` | Previous |
| `XF86AudioNext` | Next |

---

## Kitty shortcuts

These are native kitty shortcuts from `kitty.conf`.

| Shortcut | Action |
|---|---|
| `Ctrl + Shift + T` | New tab in current directory |
| `Ctrl + Shift + W` | Close tab |
| `Ctrl + Shift + Q` | Close tab |
| `Ctrl + Shift + Right` | Next tab |
| `Ctrl + Shift + Left` | Previous tab |
| `Ctrl + Shift + Alt + T` | Rename tab |
| `Ctrl + Shift + Enter` | New kitty window / split |
| `Ctrl + Shift + L` | Next kitty window |
| `Ctrl + Shift + H` | Previous kitty window |
| `Ctrl + Shift + +` | Increase font size |
| `Ctrl + Shift + -` | Decrease font size |
| `Ctrl + Shift + Backspace` | Reset font size |
| `Ctrl + Shift + O` | Increase background opacity |
| `Ctrl + Shift + I` | Decrease background opacity |
| `F1` | Copy to kitty buffer A |
| `F2` | Paste from kitty buffer A |
| `F3` | Copy to kitty buffer B |
| `F4` | Paste from kitty buffer B |

---

## Zsh aliases

### DEVILSEC aliases

```bash
arsenal='devilsec-arsenal'
pivoting='devilsec-arsenal pivoting'
adtools='devilsec-arsenal active-directory'
kb='devilsec-keyboard'
teclado='devilsec-keyboard'
```

### Better `cat`

```bash
cat     # bat without paging and without line numbers
catl    # bat with paging, no line numbers
catn    # bat with line numbers
```

### Useful aliases

```bash
myip
tunip
pyserve
urlencode
urldecode
b64
b64d
ports
```

### Git aliases

```bash
g
gst
gd
gl
gco
gp
```

---

## Customization

### Change wallpaper

```bash
styx -m wallpaper
set-wallpaper
set-wallpaper --any
set-wallpaper ~/Pictures/my-wallpaper.png
```

### Change theme

```bash
styx -m theme
```

Available themes:

```text
Limbo
Inferno
Purgatory
```

### Change polybar variant

```bash
styx -m polybar
```

Available variants:

```text
default
minimal
spectral
```

### Change font size

```bash
styx -m font
```

### Change brightness

```bash
styx -m brightness
```

### Change gamma / temperature

```bash
styx -m gamma
```

---

## Where configs are deployed

After installation:

```text
~/.config/bspwm/
~/.config/sxhkd/
~/.config/polybar/
~/.config/picom/
~/.config/kitty/
~/.config/rofi/
~/.config/dunst/
~/.config/fastfetch/
~/.config/starship.toml
~/.zshrc
```

DEVILSEC system files:

```text
/opt/devilsec/bin/
/opt/devilsec/tools/
/opt/devilsec/share/
/opt/devilsec/wordlists/
```

Wallpapers:

```text
~/Pictures/devilsec-wallpapers/
```

Runtime state:

```text
~/.config/devilsec/
```

---

## Recommended screenshots for the repo

To make the GitHub repo look clean, upload screenshots here:

```text
docs/images/
```

Suggested files:

| File | Purpose |
|---|---|
| `devilsec-preview.png` | Main banner / hero image |
| `desktop-main.png` | Full desktop screenshot |
| `styx-panel.png` | styx control panel |
| `kitty-tabs.png` | Kitty terminal tabs |
| `rofi-launcher.png` | Rofi launcher |
| `polybar.png` | Bar close-up |
| `wallpapers-grid.png` | Wallpaper collection preview |

Then reference them like this:

```md
<img src="docs/images/devilsec-preview.png" width="850">
```

---

## Troubleshooting

### I cannot see bspwm in the login screen

Make sure the session file exists:

```bash
ls /usr/share/xsessions/bspwm.desktop
```

If needed, rerun:

```bash
bash install.sh
```

---

### Shortcuts are not working

Reload sxhkd:

```text
Super + Escape
```

Or manually:

```bash
pkill -USR1 -x sxhkd
```

Check if sxhkd is running:

```bash
pgrep -a sxhkd
```

---

### Polybar is not showing

Restart it:

```bash
pkill -x polybar
~/.config/polybar/launch.sh
```

Or use:

```bash
styx -m polybar
```

---

### Transparency looks wrong

Reset opacity:

```bash
devilsec-opacity reset
devilsec-opacity 80
```

Then restart kitty.

---

### Keyboard is in the wrong layout

Open the switcher:

```bash
devilsec-keyboard
```

Or force Latin American layout:

```bash
devilsec-keyboard latam
```

Or force English US:

```bash
devilsec-keyboard us
```

---

### Wallpaper does not persist

Apply it again:

```bash
set-wallpaper
```

Check state:

```bash
cat ~/.config/devilsec/wallpaper.state
ls -la ~/.config/devilsec-wallpaper
```

---

### ZIP extraction lost executable permissions

Run:

```bash
chmod +x install.sh
chmod +x core/phases/*.sh
chmod +x scripts/system/*
chmod +x scripts/system/styx-modules/*.sh
chmod +x scripts/commands/*
chmod +x config/bspwm/bspwmrc
```

Then:

```bash
bash install.sh
```

---

## Ethical use

This environment is intended for:

- Authorized security testing.
- CTFs.
- Lab environments.
- Training.
- Research.
- Internal assessments with permission.

Do not use this toolkit against systems you do not own or do not have explicit permission to test.

---

## Roadmap ideas

- Add installer profile modes: minimal, full, CTF, enterprise.
- Add wallpaper preview grid inside `styx`.
- Add `styx` module for VPN profiles.
- Add backup/restore manager.
- Add one-command export of environment screenshots.
- Add Devil May Hack integration panel.
- Add automatic lab workspace generator.
- Add update manager for `/opt/devilsec`.

---

## Credits

Built for operators, CTF players, red team students and people who like their Kali environment to look as sharp as their methodology.

Made with:

```text
bspwm + sxhkd + kitty + polybar + rofi + picom + zsh
```

---

<div align="center">

## DEVILSEC

**Offensive workflow. Minimal friction. Maximum style.**

</div>

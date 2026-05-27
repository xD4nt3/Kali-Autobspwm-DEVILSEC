<div align="center">

# DEVILSEC

**An offensive desktop environment for Kali Linux**
*v1.1.0 · "Inferno"*

A custom bspwm-based environment with offensive tooling, Devil-May-Cry-inspired styling,
and a unified control panel (styx).

</div>

---

## Quick install (clean Kali)

```bash
git clone <your-repo>/devilsec.git
cd devilsec
bash install.sh
```

Reboot. At the login screen, pick "bspwm" as your session.

## What you get

- **bspwm + sxhkd** with a complete keybinding set
- **polybar** — compact bar with Firefox / Burp Suite launchers and styx button
- **picom** (xrender, VBox-stable) + `devilsec-opacity` daemon for live transparency
- **kitty** with tab management via `Super+Alt+T/W/L/H/N`
- **rofi** + **dunst** with the DEVILSEC theme
- **fastfetch** greeter (only first terminal of the session)
- **starship** prompt with status icons, vim mode, runtime detection
- **styx** — TUI/GUI control panel (`styx` or `Super+Alt+S`)
- **arsenal**: BloodHound CE, Impacket upstream, NetExec, bloodyAD, Ligolo-ng (with pre-staged Win/Linux agents), and dozens more on `/opt/devilsec/bin`
- **25 custom commands**: `show-help-panel`, `set-wallpaper`, `xcopy`, `mkt`, `extract-ports`, `devilsec-copy-ip`, `devilsec-temp`, `devilsec-keyboard`, full `nmcli-*` suite, etc.

## Key shortcuts

Run `show-help-panel` from any terminal for the full reference.

| Shortcut | Action |
|---|---|
| `Super + Enter` | Terminal |
| `Super + D` / `Super + Shift + D` | Rofi launcher |
| `Super + W` / `Super + Shift + W` | Close / kill window |
| `Super + 1..9 / 0` | Switch workspace |
| `Super + Shift + 1..9 / 0` | Send window to workspace |
| `Super + Shift + Arrow` | Preselector |
| `Super + Alt + Arrow` | Resize window |
| `Super + Alt + S` | Styx (control panel) |
| `Super + Alt + K` | Keyboard layout switcher |
| `Super + Alt + T/W/L/H/N` | Kitty tabs (new/close/next/prev/rename) |
| `Super + Shift + F` | Firefox |
| `Super + Shift + B` | Burp Suite |
| `Super + Shift + F1/F2/F3` | Copy local / VPN / target IP |
| `Print` | Flameshot |

## Transparency

DEVILSEC uses `_NET_WM_WINDOW_OPACITY` (xprop) instead of picom's `opacity-rule`.
This is the picom-recommended method (`man picom` → WINDOW RULES section) and is
the only stable way to get transparency on **VirtualBox / VMware** without GPU
acceleration. Adjust it any time:

```bash
styx -m opacity              # interactive menu (presets + custom)
devilsec-opacity 80 70       # focused / unfocused %
devilsec-opacity reset       # remove client opacity
```

The `devilsec-opacity daemon` is started automatically from `bspwmrc` and
re-applies opacity whenever windows or focus change.

## Repository layout

```
devilsec/
├── install.sh                  # orchestrator (10 phases)
├── core/
│   ├── forge.sh                # palette, logger, helpers
│   └── phases/                 # 00-preflight … 99-postflight
├── config/                     # dotfiles (bspwm, sxhkd, polybar, picom, ...)
├── scripts/
│   ├── system/                 # styx, devilsec-opacity/keyboard/kitty-do, modules
│   └── commands/               # 25 custom commands (set-wallpaper, mkt, nmcli-*, etc.)
├── themes/
│   └── wallpapers/             # 4 procedural PNGs (limbo/inferno/purgatory/ascend)
└── tools-installer/            # bootstrap of offensive tools
```

## Customisation

- **Theme/wallpaper**: `styx -m wallpaper` and `styx -m theme`
- **Polybar variants**: drop new `.ini` files in `~/.config/polybar/themes/` and select via `styx -m polybar`
- **Add your own commands**: drop executables in `/opt/devilsec/bin/`

---

*"Power, given by others, is never truly yours."*

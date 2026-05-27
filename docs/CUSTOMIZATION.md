# DEVILSEC · Customisation

Most of what you'd normally edit by hand is exposed through **`styx`**. This
document covers both: what you can change without touching files, and what
to edit when you want to go further.

---

## With `styx` (no file editing)

```bash
styx              # interactive TUI
styx -g           # graphical (rofi)   ·  also Super + Alt + S
styx -m <module>  # jump to a module
```

| What                              | How                                        |
|-----------------------------------|--------------------------------------------|
| Wallpaper                         | `styx -m wallpaper` (cycle, random, pick)  |
| Colour theme (Limbo/Inferno/…)    | `styx -m theme`                            |
| Polybar height (1-60 px)          | `styx -m polybar` → 1                      |
| Polybar opacity (50-100%)         | `styx -m polybar` → 2                      |
| Polybar variant (default/min/spectral) | `styx -m polybar` → 3                 |
| Compositor preset (blur/anim)     | `styx -m compositor`                       |
| Brightness (1-100)                | `styx -m brightness`                       |
| Colour temperature (3200-6500K)   | `styx -m gamma`                            |
| Font size (terminal & polybar)    | `styx -m font`                             |

Every change is applied live — no restart needed.

---

## By editing files

### Window manager (bspwm)

File: `~/.config/bspwm/bspwmrc`

The most useful knobs are near the top:

```bash
bspc config border_width    3         # window border thickness
bspc config window_gap      8         # space between tiled windows
bspc config top_padding     38        # leave room for polybar (= height + 8)
bspc config split_ratio     0.50      # default split ratio
```

If you change polybar height with styx, **also update `top_padding`** here so
you don't get a stripe of wallpaper under the bar. Reload with `Super+Alt+R`.

### Keybindings (sxhkd)

File: `~/.config/sxhkd/sxhkdrc`

After editing, reload with:

```bash
pkill -USR1 sxhkd
```

The modifier convention is enforced by convention only, not by the parser —
mix as you wish, but consider keeping it consistent.

### Polybar

File: `~/.config/polybar/config.ini`

Modules are clearly named; the most-edited values:

- `modules-left`, `modules-center`, `modules-right` — module order in the bar
- `font-0..3` — font stack (Nerd Font is `font-0`)
- `background`, `foreground`, the `[colors]` section — palette overrides

Alternative variants live in `~/.config/polybar/themes/`:

```bash
# switch theme:
cp ~/.config/polybar/themes/spectral.ini ~/.config/polybar/config.ini
~/.config/polybar/launch.sh
```

### Compositor (picom)

File: `~/.config/picom/picom.conf`

Three pre-built presets in `~/.config/picom/presets/`:

| Preset        | Best for                                       |
|---------------|------------------------------------------------|
| `smooth`      | daily use (default)                            |
| `performance` | VMs, low-spec hosts, no blur, no animations    |
| `ethereal`    | demos, screenshots — heavy blur, dim, slow fade|

Switch with `styx -m compositor` or:

```bash
cp ~/.config/picom/presets/ethereal.conf ~/.config/picom/picom.conf
pkill picom && picom --config ~/.config/picom/picom.conf &
```

### Terminal (kitty)

File: `~/.config/kitty/kitty.conf`

`font_size`, `background_opacity`, `window_padding_width`, `cursor_shape` —
all near the top. Live-reload with `Ctrl+Shift+F5` inside kitty.

### Rofi

Files: `~/.config/rofi/config.rasi`, `~/.config/rofi/themes/devilsec.rasi`

The theme file is structured by widget (`window`, `inputbar`, `listview`, …).
The palette block at the top is what you want for quick recolouring.

### Shell (zsh)

File: `~/.zshrc`

Aliases are clearly grouped. To add your own, drop them at the end. The
plugin loader picks up new plugins automatically if cloned under
`~/.zsh-plugins/<plugin-name>/`.

### Prompt (starship)

File: `~/.config/starship.toml`

Palette block is named `[palettes.devilsec]`. Module configuration follows
standard starship syntax — see <https://starship.rs/config/>.

### Notifications (dunst)

File: `~/.config/dunst/dunstrc`

`origin`, `offset`, `width`, `height`, the urgency blocks — straightforward.
Reload with `pkill dunst && dunst &`.

---

## Adding tools to the arsenal

To make a tool appear under a category in `devilsec-arsenal`, add a line to
the matching file in `/opt/devilsec/share/categories/`:

```bash
# /opt/devilsec/share/categories/pivoting.list
mytool       short description shown next to the name
```

If the binary is on `$PATH`, the viewer marks it present. If not, it shows it
in dim with `(missing)`.

To create a new category, just drop a new `<name>.list` file in that
directory and re-run `devilsec-arsenal`.

---

## Adding a new styx module

1. Drop a script at `/opt/devilsec/share/styx/<name>.sh`.
2. Make it executable (`chmod +x`).
3. Add it to the `MENU` array at the top of `/opt/devilsec/bin/styx`:
   ```bash
   "myid|󰒓  My label   |One-line description|module_mymodule"
   ```
   The action name (`mymodule`) must match the script filename.

That's all — `styx` discovers it on the next launch.

# DEVILSEC · Troubleshooting

## During install

### "DEVILSEC must not be summoned as root"

You ran `sudo ./install.sh` or `./install.sh` as root. Don't. Run it as your
normal user — the installer will request privileges itself when needed.

### A phase failed midway

Each phase is self-contained and idempotent. Inspect the log:

```bash
less .summon.log
```

Re-run the failing phase directly:

```bash
bash core/phases/40-tools.sh
```

If the failure is transient (a flaky GitHub release download, an apt mirror
hiccup), re-running usually resolves it.

### "package conflicts" during pipx installs

Some offensive tools share dependencies with very tight pins (impacket
versions, mostly). Phase 40 deals with this by installing each tool in its
own pipx venv, but if you've previously installed conflicting versions
globally, clean them up:

```bash
pip3 list 2>/dev/null | grep -iE "impacket|netexec|bloodyad|certipy"
sudo pip3 uninstall -y <package>   # for each found
```

Then re-run phase 40.

### Pipx-installed tools aren't on $PATH

```bash
pipx ensurepath
exec zsh   # restart shell
```

If that still doesn't work, the installer also adds `/opt/devilsec/bin` to
`$PATH` via `/etc/profile.d/devilsec.sh`, which only applies on **new login
shells**. Log out and back in, or run:

```bash
source /etc/profile.d/devilsec.sh
```

---

## At the login screen

### "bspwm" doesn't appear as a session option

Your display manager hasn't picked up the new `.desktop` file. Restart it:

```bash
sudo systemctl restart lightdm    # or gdm, sddm
```

If the file isn't there:

```bash
cat /usr/share/xsessions/bspwm.desktop   # should exist
# if missing, re-run phase 99:
bash core/phases/99-postflight.sh
```

---

## In the bspwm session

### Polybar is missing or wrongly positioned

```bash
~/.config/polybar/launch.sh         # re-launch
```

If the bar sits over your windows, `top_padding` in `~/.config/bspwm/bspwmrc`
doesn't match the bar height. Edit it to `bar_height + 8` and reload bspwm
with `Super+Alt+R`.

### Black screen / no wallpaper

```bash
feh --bg-fill ~/Pictures/devilsec-wallpapers/limbo.png
```

If the wallpapers directory is empty, re-run the dotfile phase:

```bash
bash core/phases/70-dotfiles.sh
```

### Picom won't start

```bash
picom --config ~/.config/picom/picom.conf --debug 2>&1 | head
```

The most common cause is the **`animations` block** in the config — those
features need picom **11.0 or newer**. If your distro shipped 10.x and the
source build during phase 20 failed:

```bash
picom --version
```

If it's < 11, switch to the **performance preset** (no animations) until you
build a newer picom:

```bash
cp ~/.config/picom/presets/performance.conf ~/.config/picom/picom.conf
pkill picom && picom --config ~/.config/picom/picom.conf &
```

### sxhkd doesn't pick up new keybindings

```bash
pkill -USR1 sxhkd
```

If a binding shows nothing in `xev` either, you probably have a typo in
`sxhkdrc` — check `journalctl --user -u sxhkd` or run `sxhkd -r /tmp/sxlog`
to see what it parsed.

---

## Tools

### `bloodhound-ce up` says "permission denied" on the docker socket

You haven't logged out since being added to the `docker` group during
phase 50. Log out and back in, or:

```bash
newgrp docker
bloodhound-ce up
```

### `ligolo` says "ligolo-proxy: command not found"

The release artefact may have moved or the `nicocha30/ligolo-ng` repository
structure may have changed. Re-run phase 40 to refetch:

```bash
bash core/phases/40-tools.sh
```

If the issue persists, check the upstream release page directly:
<https://github.com/nicocha30/ligolo-ng/releases/latest>

### `nxc` (NetExec) is broken after an OS upgrade

NetExec's dependencies move fast. Force a reinstall:

```bash
pipx reinstall netexec
# or, for absolute freshness:
pipx install --force "git+https://github.com/Pennyw0rth/NetExec"
```

### BloodHound CE: bloodhound container exits with code 137

That's OOM. BloodHound's initial graph analysis needs ~8 GB RAM. Give the VM
more memory or close other heavyweight processes.

---

## Reverting

Every dotfile DEVILSEC replaced was backed up:

```bash
ls ~/.config/*.devilsec-bak-*
ls ~/.zshrc.devilsec-bak-*
```

To roll back a single file:

```bash
mv ~/.zshrc.devilsec-bak-20260520-204500 ~/.zshrc
```

To fully remove DEVILSEC:

```bash
sudo rm -rf /opt/devilsec /etc/profile.d/devilsec.sh
sudo rm -f /usr/share/xsessions/bspwm.desktop
rm -rf ~/.config/{bspwm,sxhkd,polybar,picom,kitty,rofi,dunst,fastfetch,devilsec}
rm -f  ~/.zshrc ~/.config/starship.toml
chsh -s /bin/bash
```

(BloodHound CE data lives in Docker volumes; remove with `bloodhound-ce nuke`
or `docker volume prune`.)

---

## Reporting bugs

If you hit something not covered here, please open an issue with:

1. Kali version (`cat /etc/os-release`)
2. The relevant chunk of `.summon.log`
3. Output of:
   ```bash
   bspwm --version
   polybar --version
   picom --version
   ```
4. Steps to reproduce.

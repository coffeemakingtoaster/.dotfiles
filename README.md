# dotfiles

My fancy dotfiles...
Migrated from i3 -> sway -> hyprland.

```sh
curl dotfiles.ssh-coffee.dev/coffeemakingtoaster | sh
```

## Window manager

The active target is **Hyprland** (Wayland). The installer prompts for a
window manager and exports it as `WM=hyprland|i3|sway` to all per-directory
`apply.sh` scripts. New installs default to `hyprland`.

## Legacy configurations

`i3`, `i3status`, `rofi`, `sway`, and `wofi` are kept under `legacy/` for
historical reference. They are **not** auto-applied by `install.sh`. To use
one manually:

```sh
WM=i3    ./legacy/i3/apply.sh
WM=sway  ./legacy/sway/apply.sh
```

## Distro notes

The Hyprland and Waybar `apply.sh` scripts use `dnf` (Fedora) and enable the
`lionheartp/Hyprland` COPR. Migrating the older apt-based `apply.sh` scripts
to `dnf` is a future task.

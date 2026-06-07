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

## Headless / non-interactive installs

`hyprland/apply.sh` calls `systemctl --user start elephant.service` and
`elephant service enable` to register the Elephant service. That requires a
running systemd user instance, which you do not have in a container, an SSH
session without lingering enabled, or a headless server.

To skip the systemd touchpoint, set `DOTFILES_SKIP_SYSTEMD=1` before
running `install.sh`:

```sh
DOTFILES_SKIP_SYSTEMD=1 ./install.sh
```

The `hyprland/apply.sh` script logs that the elephant service was skipped;
everything else in the install runs as normal.

## Smoke test

`tests/smoke.sh` runs `./install.sh` inside a fresh Fedora container via
podman and reports PASS/FAIL based on the installer's exit code. It does not
validate the resulting desktop configuration — only that the installer runs
to completion on a clean Fedora box.

```sh
./tests/smoke.sh           # build (if needed) + run
./tests/smoke.sh --rebuild # force image rebuild
./tests/smoke.sh --no-cache # use a tmpfs $HOME (no state between runs)
```

See `tests/README.md` for details, known-flaky surface, and how to inspect
the resulting `$HOME` between runs.


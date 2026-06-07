# Smoke test

A podman-based smoke test for the installer. It runs the real
`./install.sh` end-to-end inside a fresh Fedora container and reports
PASS/FAIL based on the installer's exit code.

## What it does

1. Builds a `fedora:latest`-based image (`tests/Containerfile`) with a
   non-root user that has passwordless `sudo`.
2. Mounts the dotfiles repo read-only at `/home/tester/dotfiles` and a
   host cache dir at `/home/tester` (override with `--no-cache` for a
   tmpfs `$HOME`).
3. Runs `./install.sh` inside the container with:
   - `WM=hyprland`
   - `DISTRO=fedora`
   - `DOTFILES_SKIP_SYSTEMD=1` (containers have no systemd by default)
   - `DOTFILES_NO_COLOR=1` (clean logfile, no ANSI escapes)
4. Captures the full output to `tests/.smoke.log` and exits 0 only if
   the installer also exits 0.

## What it does NOT do

- It does not validate the resulting desktop configuration. We do not
  check that Hyprland starts, that ghostty opens a window, that tmux
  plugins load, etc. The bar is "the installer script runs to
  completion on a fresh Fedora box."
- It does not test the macOS path (`uname == Darwin` short-circuits).
- It does not test the legacy `i3`/`sway` configs unless you opt in
  via `DOTFILES_WM=sway ./tests/smoke.sh`.

## Usage

```sh
# Build (if needed) and run
./tests/smoke.sh

# Force a rebuild of the test image (e.g. after editing the Containerfile)
./tests/smoke.sh --rebuild

# Use a tmpfs $HOME so no state persists between runs
./tests/smoke.sh --no-cache

# Test a different WM
DOTFILES_WM=sway ./tests/smoke.sh
```

A successful run prints `[smoke] PASS — install.sh exited 0` and
exits 0. The full install log is at `tests/.smoke.log`.

## Requirements

- `podman` (rootless, no daemon). On Fedora: `sudo dnf install podman`.
- Outbound HTTPS for `dnf`, the GitHub API (for the wezterm step), and
  oh-my-zsh.

## Known-flaky surface

These are external dependencies, not script bugs. If a smoke run fails
on one of these, retry once and re-run before assuming the installer
is broken:

- **dnf mirrors**: transient 5xx during repo metadata refresh.
- **GitHub API rate limiting**: the wezterm step hits
  `api.github.com/repos/wez/wezterm/releases/latest` and may 429.
- **oh-my-zsh installer**: occasionally hangs on the chsh prompt in
  unattended contexts; the installer is invoked by `curl | sh`, which
  is fragile by design.

## Inspecting state between runs

The harness mounts a host cache dir at `/home/tester` by default:

```
tests/.smoke-home/   # the $HOME written by the last smoke run
tests/.smoke.log     # the installer's full output
```

Use `--no-cache` for an ephemeral run, or `rm -rf tests/.smoke-home`
to start fresh.

## Adding CI

This harness is shell-only and works on any GitHub Actions runner with
podman preinstalled. A minimal workflow would install podman, run
`./tests/smoke.sh`, and fail the job on non-zero exit. The base
`fedora:latest` image is cached between runs in the runner's podman
storage, so subsequent runs are fast.

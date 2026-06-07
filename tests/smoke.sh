#!/usr/bin/env bash
#
# Smoke test for the dotfiles installer.
#
# Boots a fresh Fedora container, runs ./install.sh inside it, and
# reports PASS/FAIL based on the installer's exit code. Does not
# validate the resulting desktop configuration — only that the
# installer script itself runs to completion on a clean Fedora box.
#
# Usage:
#   ./tests/smoke.sh                  # build (if needed) + run
#   ./tests/smoke.sh --rebuild        # force image rebuild
#   ./tests/smoke.sh --no-cache       # run with a fresh $HOME
#   DOTFILES_WM=sway ./tests/smoke.sh # test a different WM

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
IMAGE="dotfiles-smoke"
LOGFILE="$SCRIPT_DIR/.smoke.log"
CONTAINERFILE="$SCRIPT_DIR/Containerfile"

# Defaults for the installer inside the container
: "${DOTFILES_WM:=hyprland}"
: "${DOTFILES_DISTRO:=fedora}"

rebuild=0
fresh_home=0
for arg in "$@"; do
	case "$arg" in
		--rebuild) rebuild=1 ;;
		--no-cache) fresh_home=1 ;;
		-h|--help)
			sed -n '3,12p' "$0"
			exit 0
			;;
		*) echo "unknown arg: $arg" >&2; exit 2 ;;
	esac
done

log() { printf '\033[1;36m[smoke]\033[0m %s\n' "$*"; }
die() { printf '\033[1;31m[smoke]\033[0m %s\n' "$*" >&2; exit 1; }

# Sanity: podman
command -v podman >/dev/null 2>&1 \
	|| die "podman not found. Install with: sudo dnf install podman"

# Sanity: podman can talk to its storage
podman info >/dev/null 2>&1 \
	|| die "podman cannot reach its storage. Try: podman system migrate"

# Build (or rebuild) the test image
needs_build=$rebuild
if [ "$needs_build" -eq 0 ] && ! podman image exists "$IMAGE" >/dev/null 2>&1; then
	needs_build=1
fi

if [ "$needs_build" -eq 1 ]; then
	log "building test image '$IMAGE' ..."
	host_uid=$(id -u)
	host_gid=$(id -g)
	podman build \
		--build-arg "HOST_UID=$host_uid" \
		--build-arg "HOST_GID=$host_gid" \
		-t "$IMAGE" \
		-f "$CONTAINERFILE" \
		"$SCRIPT_DIR"
else
	log "test image '$IMAGE' cached"
fi

# Mount points. SELinux: append :z so podman relabels the source
# for shared container access.
#
# We do NOT use --userns=keep-id: with rootless podman, bind mounts
# owned by the host's UID 1000 are visible to the in-container
# `tester` user (also UID 1000) directly. With keep-id, in-container
# tmpfs mounts are created owned by root and the user can't write.
home_mount=()
tmp_home_cleanup=""
if [ "$fresh_home" -eq 1 ]; then
	# Fresh $HOME per run. Use a host dir under /tmp that we
	# clean up on exit. tmpfs via --mount doesn't work cleanly
	# with rootless podman, so we use a host dir as a disposable
	# backing store. chown under podman's userns so the in-container
	# tester user can write to it.
	tmp_home=$(mktemp -d /tmp/dotfiles-smoke.XXXXXX)
	podman unshare chown 1000:1000 "$tmp_home" 2>/dev/null || true
	tmp_home_cleanup="$tmp_home"
	trap 'podman unshare rm -rf "$tmp_home_cleanup" 2>/dev/null || rm -rf "$tmp_home_cleanup"' EXIT
	home_mount=(-v "$tmp_home:/home/tester:z")
else
	cache_home="$SCRIPT_DIR/.smoke-home"
	mkdir -p "$cache_home"
	podman unshare chown 1000:1000 "$cache_home" 2>/dev/null || true
	home_mount=(-v "$cache_home:/home/tester:z")
fi

log "running install.sh in container (WM=$DOTFILES_WM, DISTRO=$DOTFILES_DISTRO) ..."
set +e
# Forward any SMOKE_TEST_* env vars into the container so test
# injection hooks (e.g. SMOKE_TEST_INJECT_FAILURE) work without
# needing to edit the runner.
extra_env=()
while IFS= read -r var; do
	extra_env+=(-e "$var")
done < <(env | cut -d= -f1 | grep '^SMOKE_TEST_' || true)

podman run --rm \
	-v "$REPO_ROOT:/home/tester/dotfiles:ro,z" \
	"${home_mount[@]}" \
	-e "WM=$DOTFILES_WM" \
	-e "DISTRO=$DOTFILES_DISTRO" \
	-e "DOTFILES_SKIP_SYSTEMD=1" \
	-e "DOTFILES_NO_COLOR=1" \
	"${extra_env[@]}" \
	-w /home/tester/dotfiles \
	"$IMAGE" \
	bash /home/tester/dotfiles/install.sh 2>&1 | tee "$LOGFILE"
rc=${PIPESTATUS[0]}
set -e

if [ "$rc" -eq 0 ]; then
	log "PASS — install.sh exited 0"
	log "log: $LOGFILE"
	exit 0
else
	log "FAIL — install.sh exited $rc"
	log "log: $LOGFILE"
	exit 1
fi

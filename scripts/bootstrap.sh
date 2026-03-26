#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

log() {
  printf '\n==> %s\n' "$*"
}

warn() {
  printf '\n[warn] %s\n' "$*"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

if ! need_cmd sudo; then
  echo "This bootstrap requires sudo for apt installs."
  exit 1
fi

log "Running Ubuntu bootstrap for myConfig"

./scripts/install-dev.sh
./scripts/install-zsh.sh
./scripts/apply-config.sh

if need_cmd fc-cache; then
  log "Refreshing font cache"
  fc-cache -fv >/dev/null 2>&1 || warn "Font cache refresh failed; continuing"
fi

cat <<'EOF'

Bootstrap complete.

Next:
1. restart your shell: exec zsh
2. open Neovim once: nvim
3. inside Neovim run:
   :Lazy sync
   :Mason
   :checkhealth
4. log into i3 from the display manager if you want the full desktop setup

EOF

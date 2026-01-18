#!/usr/bin/env bash
set -e

echo "🚀 Bootstrap starting..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

chmod +x scripts/*.sh

./scripts/install.sh
./scripts/detect-missing.sh
./scripts/detect-wayland.sh
./scripts/detect-fonts.sh
./scripts/detect-nvim.sh
./scripts/resync.sh

echo "✅ Bootstrap finished"
echo "🔁 Reboot recommended"


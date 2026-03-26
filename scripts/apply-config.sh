#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

mkdir -p \
  "$HOME/.config/i3" \
  "$HOME/.config/i3status" \
  "$HOME/.config/rofi" \
  "$HOME/.config/dunst" \
  "$HOME/.config/alacritty" \
  "$HOME/.config/ghostty" \
  "$HOME/.config/nvim"

cp i3/config "$HOME/.config/i3/config"
cp i3status/config "$HOME/.config/i3status/config"
cp rofi/config.rasi "$HOME/.config/rofi/config.rasi"
cp dunst/dunstrc "$HOME/.config/dunst/dunstrc"
cp alacritty/alacritty.toml "$HOME/.config/alacritty/alacritty.toml"
cp ghostty/config "$HOME/.config/ghostty/config"
cp nvim/init.lua "$HOME/.config/nvim/init.lua"
cp zsh/.zshrc "$HOME/.zshrc"

echo "Configs applied."

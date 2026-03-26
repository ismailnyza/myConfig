#!/usr/bin/env bash
set -euo pipefail

mkdir -p \
  "$HOME/.config/i3" \
  "$HOME/.config/i3status" \
  "$HOME/.config/rofi" \
  "$HOME/.config/dunst" \
  "$HOME/.config/alacritty" \
  "$HOME/.config/nvim"

cp i3/config "$HOME/.config/i3/config"
cp i3status/config "$HOME/.config/i3status/config"
cp rofi/config.rasi "$HOME/.config/rofi/config.rasi"
cp dunst/dunstrc "$HOME/.config/dunst/dunstrc"
cp alacritty/alacritty.toml "$HOME/.config/alacritty/alacritty.toml"
cp nvim/init.lua "$HOME/.config/nvim/init.lua"
cp zsh/.zshrc "$HOME/.zshrc"

echo "Configs applied."

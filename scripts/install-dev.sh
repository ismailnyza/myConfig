#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y \
  i3 i3status rofi dunst alacritty neovim \
  feh xclip playerctl brightnessctl scrot thunar \
  network-manager-gnome pavucontrol i3lock \
  fonts-jetbrains-mono \
  ripgrep fd-find unzip curl git libnotify-bin xss-lock xdg-utils \
  zsh fzf lua5.4 luarocks shellcheck

if ! command -v go >/dev/null 2>&1; then
  sudo apt install -y golang-go
fi

if ! command -v node >/dev/null 2>&1; then
  sudo apt install -y nodejs npm
fi

echo "Base development packages installed."

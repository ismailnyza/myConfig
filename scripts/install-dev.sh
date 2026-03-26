#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

packages=(
  i3
  i3status
  rofi
  dunst
  neovim
  feh
  xclip
  playerctl
  brightnessctl
  scrot
  thunar
  network-manager-gnome
  pavucontrol
  i3lock
  fonts-jetbrains-mono
  ripgrep
  unzip
  curl
  git
  libnotify-bin
  xss-lock
  xdg-utils
  zsh
  fzf
  lua5.4
  luarocks
  shellcheck
)

optional_packages=(
  alacritty
  ghostty
  golang-go
  nodejs
  npm
)

install_if_available() {
  local pkg="$1"
  if apt-cache show "$pkg" >/dev/null 2>&1; then
    sudo apt install -y "$pkg"
  else
    echo "[skip] Package not available in current apt sources: $pkg"
  fi
}

sudo apt update
sudo apt install -y "${packages[@]}"

if ! command -v fd >/dev/null 2>&1; then
  install_if_available fd-find
fi

for pkg in "${optional_packages[@]}"; do
  case "$pkg" in
    golang-go)
      command -v go >/dev/null 2>&1 || install_if_available "$pkg"
      ;;
    nodejs)
      command -v node >/dev/null 2>&1 || install_if_available "$pkg"
      ;;
    npm)
      command -v npm >/dev/null 2>&1 || install_if_available "$pkg"
      ;;
    *)
      install_if_available "$pkg"
      ;;
  esac
done

echo "Base development packages installed."

#!/usr/bin/env bash
set -e

if ! command -v pacman &>/dev/null; then
  echo "❌ This script is for Arch Linux only"
  exit 1
fi

echo "📦 Installing base packages..."

sudo pacman -Syu --needed --noconfirm \
  git base-devel curl unzip \
  neovim alacritty ghostty \
  hyprland hyprpaper waybar \
  dunst wofi dolphin \
  grim slurp wl-clipboard \
  brightnessctl playerctl \
  blueman \
  zsh \
  jdk21-openjdk maven gradle \
  ttf-jetbrains-mono noto-fonts noto-fonts-emoji \
  xdg-desktop-portal xdg-desktop-portal-hyprland

sudo archlinux-java set java-21-openjdk

# ---------- yay ----------
if ! command -v yay &>/dev/null; then
  echo "📦 Installing yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
fi

yay -S --needed --noconfirm \
  brave-bin \
  jetbrains-toolbox \
  lazygit \
  zsh-autosuggestions \
  zsh-syntax-highlighting

# ---------- Java tooling ----------
echo "☕ Setting up Java tools..."

mkdir -p ~/tools
cd ~/tools

if [ ! -d jdtls ]; then
  git clone https://github.com/eclipse-jdtls/eclipse.jdt.ls.git jdtls
  cd jdtls
  ./mvnw clean verify -DskipTests
  cd ..
fi

mkdir -p lombok
[ ! -f lombok/lombok.jar ] && \
  curl -L https://projectlombok.org/downloads/lombok.jar -o lombok/lombok.jar

# ---------- Configs ----------
echo "🗂 Installing configs..."

mkdir -p ~/.config
cp -r nvim ~/.config/
cp -r hyprland ~/.config/hypr
cp -r waybar ~/.config/

# Wallpapers
mkdir -p ~/Pictures
ln -sf "$(pwd)/wallpapers" ~/Pictures/wallpaper

# Zsh
cp zsh/.zshrc ~/.zshrc
chsh -s /bin/zsh

# Neovim plugins
nvim --headless +PlugInstall +qall

echo "✅ Install complete"


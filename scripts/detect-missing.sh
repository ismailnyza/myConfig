#!/usr/bin/env bash

echo "🧪 Checking required commands..."

REQUIRED=(
  hyprland waybar hyprpaper dunst
  grim slurp wl-copy
  brightnessctl playerctl
  java javac mvn gradle
  nvim git
)

for cmd in "${REQUIRED[@]}"; do
  command -v "$cmd" &>/dev/null || echo "❌ Missing: $cmd"
done


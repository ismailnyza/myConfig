#!/usr/bin/env bash

echo "🪟 Checking Wayland portals..."

for pkg in xdg-desktop-portal xdg-desktop-portal-hyprland; do
  pacman -Qi "$pkg" &>/dev/null || echo "⚠️ Missing package: $pkg"
done


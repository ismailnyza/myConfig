# myConfig

A clean, distraction-minimal Ubuntu setup built around:

- i3
- i3status
- Neovim
- Alacritty
- Rofi
- Dunst

## Philosophy

Keep the machine calm, fast, and predictable.

- Fewer moving parts
- Fewer visual effects
- Fewer background widgets
- Keyboard-first workflow
- Minimal but practical development setup

## Repo structure

- `i3/config` — window manager config
- `i3status/config` — simple status bar
- `rofi/config.rasi` — launcher
- `dunst/dunstrc` — notifications
- `alacritty/alacritty.toml` — terminal
- `nvim/init.lua` — Neovim config
- `notes/setup.md` — package/install guidance for Ubuntu

## Recommended install targets on Ubuntu

- i3
- i3status
- rofi
- dunst
- alacritty
- feh
- neovim
- xclip
- playerctl
- brightnessctl

## Goal

A setup that helps you work, not admire the setup.

## Ready for daily use?

Yes — this repo is meant to be a practical personal-use baseline, not a screenshot-flex rice.

What is intentionally included:
- sane i3 keybinds
- rofi app launcher
- dunst notifications
- terminal + editor defaults
- screenshot shortcuts
- network tray
- simple status bar

What is intentionally excluded:
- flashy compositor stack by default
- bar/widget sprawl
- unnecessary background helpers

You should still expect tiny personal tweaks after a day or two of use — browser choice, wallpaper, font size, maybe one or two keybinds.


## Ubuntu-friendly defaults

This repo now defaults to plain **JetBrains Mono** instead of a Nerd Font so it works cleanly with stock Ubuntu package repositories.

If you want Nerd Font glyphs later, you can install one manually and swap the font names back.

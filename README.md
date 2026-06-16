# myConfig

A clean, distraction-minimal Ubuntu setup built around:

- i3
- i3status
- Neovim
- Ghostty or Alacritty
- Rofi
- Dunst
- Zsh + Oh My Zsh

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
- `ghostty/config` — terminal config
- `alacritty/alacritty.toml` — fallback terminal config
- `zsh/.zshrc` — shell config
- `nvim/init.lua` — Neovim config
- `scripts/install-dev.sh` — Ubuntu package install
- `scripts/install-zsh.sh` — Oh My Zsh + shell extras
- `scripts/apply-config.sh` — copy configs into `~/.config`
- `scripts/bootstrap.sh` — one-shot Ubuntu setup path
- `notes/setup.md` — package/install guidance for Ubuntu

## Included developer experience

### Shell
- Oh My Zsh
- autocomplete
- autosuggestions
- syntax highlighting
- history search
- sensible aliases

### Neovim
- Lazy.nvim plugin manager
- Telescope
- Oil
- Treesitter
- Mason
- LSP
- completion/snippets
- format on save

### Language support
- Go
- JavaScript
- TypeScript
- Lua
- Bash
- JSON
- HTML
- CSS

## Goal

A setup that helps you work, not admire the setup.

## Ubuntu-friendly defaults

This repo defaults to plain **JetBrains Mono** so it works cleanly with stock Ubuntu package repositories.

If you want Nerd Font glyphs later, install one manually and swap the font names back.

## Quick start

```bash
git clone git@github.com:ismailnyza/myConfig.git ~/myConfig
cd ~/myConfig
./scripts/bootstrap.sh
```

Then inside Neovim run:

```vim
:Lazy sync
:Mason
:checkhealth
```

## Notes

- `bootstrap.sh` runs the install, shell setup, and config apply flow in one shot.
- The package installer tolerates packages that are missing from your current Ubuntu apt sources.
- Terminal config is applied for both Ghostty and Alacritty so the laptop can use whichever is available.

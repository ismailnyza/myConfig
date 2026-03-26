# Ubuntu setup notes

## One-shot bootstrap

```bash
git clone https://github.com/ismailnyza/myConfig ~/myConfig
cd ~/myConfig
./scripts/bootstrap.sh
```

This will:
- install core Ubuntu packages
- install shell tooling
- apply the repo configs into `~/.config`
- refresh font cache when available

## Core packages

The installer always tries to install the main stack first:

```bash
sudo apt update
sudo apt install -y \
  i3 i3status rofi dunst neovim \
  feh xclip playerctl brightnessctl scrot thunar \
  network-manager-gnome pavucontrol i3lock \
  fonts-jetbrains-mono \
  ripgrep unzip curl git libnotify-bin xss-lock xdg-utils \
  zsh fzf lua5.4 luarocks shellcheck
```

Then it conditionally installs extras when available in your apt sources:
- `fd-find`
- `alacritty`
- `ghostty`
- `golang-go`
- `nodejs`
- `npm`

## Oh My Zsh + plugins

```bash
./scripts/install-zsh.sh
```

This sets up:
- Oh My Zsh
- autocompletion
- autosuggestions
- syntax highlighting
- history substring search
- Neovim as default editor

## Config placement

```bash
./scripts/apply-config.sh
```

This applies config for:
- i3
- i3status
- rofi
- dunst
- alacritty
- ghostty
- neovim
- zsh

## Neovim bootstrap

Open Neovim once:

```bash
nvim
```

Then let Lazy/Mason install plugins and language tools.

Useful first commands:

```vim
:Lazy sync
:Mason
:checkhealth
```

## Language support included

### Go
- `gopls`
- `goimports`
- `gofumpt`
- Treesitter
- formatting on save
- LSP navigation / hover / rename / code actions

### JavaScript / TypeScript
- `typescript-language-server`
- `prettier`
- `eslint-lsp`
- Treesitter for JS/TS/TSX
- formatting on save
- LSP suggestions and navigation

## Recommended flow on Ubuntu laptop

```bash
git clone https://github.com/ismailnyza/myConfig ~/myConfig
cd ~/myConfig
./scripts/bootstrap.sh
exec zsh
nvim
```

## Optional Telegram note

If you want Telegram integrations inside Neovim later, that is a separate layer from editor/LSP setup. This repo currently focuses on shell, terminal, and coding workflow.

## Icons in Neovim

If icons show as empty squares or boxes, install a Nerd Font and point your terminal at it. Example font name used historically by this repo:

```bash
JetBrainsMono Nerd Font Mono
```

Then refresh font cache and reopen the terminal:

```bash
fc-cache -fv
```

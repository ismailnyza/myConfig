# Ubuntu setup notes

## Core packages

Install these first:

```bash
sudo apt update
sudo apt install -y \
  i3 i3status rofi dunst ghostty neovim \
  feh xclip playerctl brightnessctl scrot thunar \
  network-manager-gnome pavucontrol i3lock \
  fonts-jetbrains-mono \
  ripgrep fd-find unzip curl git libnotify-bin xss-lock xdg-utils \
  zsh fzf lua5.4 luarocks shellcheck golang-go nodejs npm
```

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

## Recommended flow on Jarvis

```bash
git clone https://github.com/ismailnyza/myConfig ~/myConfig
cd ~/myConfig
./scripts/install-dev.sh
./scripts/install-zsh.sh
./scripts/apply-config.sh
exec zsh
nvim
```

## Optional Telegram note

If you want Telegram integrations inside Neovim later, that is a separate layer from editor/LSP setup. This repo currently focuses on shell, terminal, and coding workflow.


## Icons in Neovim

If icons show as empty squares or boxes, install a Nerd Font and point Ghostty at it. Example font name used by this repo:

```bash
JetBrainsMono Nerd Font Mono
```

Then refresh font cache and reopen Ghostty:

```bash
fc-cache -fv
```

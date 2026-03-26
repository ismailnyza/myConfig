# Ubuntu setup notes

## Core packages

Install these first:

```bash
sudo apt update
sudo apt install -y \
  i3 i3status rofi dunst alacritty neovim \
  feh xclip playerctl brightnessctl scrot thunar \
  network-manager-gnome pavucontrol \
  fonts-jetbrains-mono
```

## Optional but useful

```bash
sudo apt install -y ripgrep fd-find unzip curl git
```

## Config placement

```bash
mkdir -p ~/.config/i3 ~/.config/i3status ~/.config/rofi ~/.config/dunst ~/.config/alacritty ~/.config/nvim
cp i3/config ~/.config/i3/config
cp i3status/config ~/.config/i3status/config
cp rofi/config.rasi ~/.config/rofi/config.rasi
cp dunst/dunstrc ~/.config/dunst/dunstrc
cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp nvim/init.lua ~/.config/nvim/init.lua
```

## Wallpaper

Put your wallpaper at:

```bash
~/Pictures/wallpaper.png
```

## First login checks

- `i3-msg reload`
- `i3-msg restart`
- open `alacritty`
- run `nvim`
- run `:Lazy sync`
- verify `rofi -show drun`
- verify notifications with `notify-send test hello`

## Notes

- Start with `i3status`, not Polybar.
- Keep the bar minimal.
- Add extra tools only when they solve a real problem.

## Final choices in this setup

- No Hyprland
- No Waybar
- No picom by default
- Keep `nm-applet` for practical network control
- Skip `pasystray` to reduce tray clutter
- Use `i3status` first, not Polybar

# Ubuntu setup notes

## Core packages

Install these first:

```bash
sudo apt update
sudo apt install -y \
  i3 i3status rofi dunst alacritty neovim \
  feh xclip playerctl brightnessctl scrot thunar \
  network-manager-gnome pavucontrol i3lock \
  fonts-jetbrains-mono fonts-jetbrains-mono-nerd
```

## Optional but useful

```bash
sudo apt install -y ripgrep fd-find unzip curl git libnotify-bin xss-lock xdg-utils
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

## Recommended personal-use extras

These are not mandatory, but they make the setup feel complete for daily use:

```bash
sudo apt install -y brave-browser
```

If you use a different browser, update `$browser` in `i3/config`.

## Lock screen

This config binds lock to:

```bash
Super+Shift+L
```

Make sure `i3lock` is installed.

## Screenshots

Screenshots are saved to:

```bash
~/Pictures/screenshots
```

- `Print` → full screenshot
- `Super+Print` → selection screenshot

## First-login personal tweaks

After copying the config, check these quickly:

- browser command in `i3/config`
- wallpaper path (`~/Pictures/wallpaper.png`)
- audio keys work with PipeWire/PulseAudio
- brightness keys work on your laptop
- `Super+Shift+L` locks correctly

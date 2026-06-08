#!/bin/bash
# Quick Settings menu — single entry point for all custom scripts

SCRIPTS="$HOME/.config/waybar/script"
HYPR_SCRIPTS="$HOME/.config/hypr/script"

menu() {
  cat <<EOF
 Random Wallpaper
 Switch Waybar Style
 Switch Waybar Layout
 Lock Screen
 Reload Hyprland
EOF
}

main() {
  choice=$(menu | rofi -i -dmenu -p ">" -mesg "Quick Settings")

  case "$choice" in
    *"Random Wallpaper")   python "$SCRIPTS/random_wallpaper.py" ;;
    *"Switch Waybar Style") python "$SCRIPTS/change-color.py" ;;
    *"Switch Waybar Layout") bash "$SCRIPTS/switch-layout.sh" ;;
    *"Lock Screen")        hyprlock ;;
    *"Reload Hyprland")    hyprctl reload ;;
    *) exit 0 ;;
  esac
}

if pidof rofi >/dev/null; then
  pkill rofi
fi

main

#!/bin/bash
# Switch waybar layout via rofi

waybar_layouts="$HOME/.config/waybar/configs"
waybar_config="$HOME/.config/waybar/config"
rofi_config="$HOME/.config/rofi/config-waybar-layout.rasi"
msg='NOTE: Some layouts may not be compatible with all styles'

apply_config() {
    ln -sf "$waybar_layouts/$1" "$waybar_config"
    pkill waybar; sleep 0.5; waybar &
}

main() {
    current_target=$(readlink -f "$waybar_config")
    current_name=$(basename "$current_target")

    mapfile -t options < <(
        find -L "$waybar_layouts" -maxdepth 1 -type f -printf '%f\n' | sort
    )

    default_row=0
    MARKER="👉"
    for i in "${!options[@]}"; do
        if [[ "${options[i]}" == "$current_name" ]]; then
            options[i]="$MARKER ${options[i]}"
            default_row=$i
            break
        fi
    done

    choice=$(printf '%s\n' "${options[@]}" \
        | rofi -i -dmenu \
               -mesg "$msg" \
               -selected-row "$default_row"
    )

    [[ -z "$choice" ]] && exit 0
    choice=${choice# $MARKER}
    apply_config "$choice"
}

if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

main

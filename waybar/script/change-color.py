import os
import subprocess
from pathlib import Path

# ===== Config =====
DEBUG = False
config_file = '/home/tomato/.config/waybar/waybar_theme_config'
mocha_css = "/home/tomato/.config/waybar/mocha.css"

# Catppuccin Mocha (dark)
DARK_COLORS = {
    "rosewater": "#f5e0dc", "flamingo": "#f2cdcd", "pink": "#f5c2e7",
    "mauve": "#cba6f7",     "red": "#f38ba8",      "maroon": "#eba0ac",
    "peach": "#fab387",     "yellow": "#f9e2af",    "green": "#a6e3a1",
    "teal": "#94e2d5",      "sky": "#89dceb",       "sapphire": "#74c7ec",
    "blue": "#89b4fa",      "lavender": "#b4befe",  "text": "#cdd6f4",
    "subtext1": "#bac2de",  "subtext0": "#a6adc8",  "overlay2": "#9399b2",
    "overlay1": "#7f849c",  "overlay0": "#6c7086",  "surface2": "#585b70",
    "surface1": "#45475a",  "surface0": "#313244",  "base": "#1e1e2e",
    "mantle": "#181825",    "crust": "#11111b",
}

# Catppuccin Latte (light)
LIGHT_COLORS = {
    "rosewater": "#dc8a78", "flamingo": "#dd7878", "pink": "#ea76cb",
    "mauve": "#8839ef",     "red": "#d20f39",      "maroon": "#e64553",
    "peach": "#fe640b",     "yellow": "#df8e1d",    "green": "#40a02b",
    "teal": "#179299",      "sky": "#04a5e5",       "sapphire": "#209fb5",
    "blue": "#1e66f5",      "lavender": "#7287fd",  "text": "#4c4f69",
    "subtext1": "#5c5f77",  "subtext0": "#6c6f85",  "overlay2": "#7c7f93",
    "overlay1": "#8c8fa1",  "overlay0": "#9ca0b0",  "surface2": "#acb0be",
    "surface1": "#bcc0cc",  "surface0": "#ccd0da",  "base": "#eff1f5",
    "mantle": "#e6e9ef",    "crust": "#dce0e8",
}


def log(msg):
    if DEBUG:
        subprocess.run(["notify-send", "Theme Switcher", str(msg)], check=False)
        print(msg)


def run(cmd):
    subprocess.run(cmd, check=False)


def get_current_theme():
    if os.path.exists(config_file):
        with open(config_file, 'r') as f:
            theme = f.read().strip()
            if theme in ("dark", "light"):
                return theme
    Path(config_file).parent.mkdir(parents=True, exist_ok=True)
    with open(config_file, 'w') as f:
        f.write('dark')
    return 'dark'


def write_mocha_css(colors):
    lines = []
    for name, hex_val in colors.items():
        lines.append(f"@define-color {name} {hex_val};")
    content = "\n".join(lines) + "\n"

    Path(mocha_css).parent.mkdir(parents=True, exist_ok=True)
    with open(mocha_css, 'w') as f:
        f.write(content)


def update_gtk_theme(theme):
    if theme == "dark":
        gtk_theme, color_scheme = "Adwaita-dark", "prefer-dark"
    else:
        gtk_theme, color_scheme = "Adwaita", "prefer-light"

    run(["gsettings", "set", "org.gnome.desktop.interface", "gtk-theme", gtk_theme])
    run(["gsettings", "set", "org.gnome.desktop.interface", "color-scheme", color_scheme])


def main():
    try:
        current = get_current_theme()
        new_theme = "light" if current == "dark" else "dark"

        colors = DARK_COLORS if new_theme == "dark" else LIGHT_COLORS
        write_mocha_css(colors)
        update_gtk_theme(new_theme)

        with open(config_file, 'w') as f:
            f.write(new_theme)

        # Restart waybar
        run(["pkill", "waybar"])
        subprocess.Popen(["waybar"])

        log(f"{current} -> {new_theme}")
        subprocess.run(["notify-send", "Theme", f"Switched to {new_theme} mode"], check=False)

    except Exception as e:
        log(f"Error: {e}")
        exit(1)


if __name__ == "__main__":
    main()

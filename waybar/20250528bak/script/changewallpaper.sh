#!/bin/bash

# 壁纸目录
WALLPAPER_DIR="$HOME/Pictures/wallpaper"

# 检查目录是否存在
if [ ! -d "$WALLPAPER_DIR" ]; then
    mkdir -p "$WALLPAPER_DIR"
    echo "Created wallpaper directory at $WALLPAPER_DIR"
    exit 1
fi

# 获取当前壁纸
current_wallpaper=$(swww query | grep -oP 'image: \K.*')

# 获取所有壁纸文件
wallpapers=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \)))

# 如果没有找到壁纸文件
if [ ${#wallpapers[@]} -eq 0 ]; then
    notify-send "No wallpaper files found in $WALLPAPER_DIR"
    exit 1
fi

# 找到当前壁纸的索引
current_index=-1
for i in "${!wallpapers[@]}"; do
    if [ "${wallpapers[$i]}" = "$current_wallpaper" ]; then
        current_index=$i
        break
    fi
done

# 计算下一个壁纸的索引
if [ $current_index -eq -1 ] || [ $current_index -eq $((${#wallpapers[@]} - 1)) ]; then
    next_index=0
else
    next_index=$((current_index + 1))
fi

notify-send "Switching to next wallpaper" "Switching to next wallpaper"

# 切换到下一个壁纸
swww img "${wallpapers[$next_index]}" --transition-type wipe --transition-angle 30 --transition-step 90

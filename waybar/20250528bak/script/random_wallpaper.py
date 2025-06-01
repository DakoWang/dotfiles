#!/usr/bin/env python3

import os
import random
import subprocess
from pathlib import Path

# 壁纸目录
WALLPAPER_DIR = os.path.expanduser("~/Pictures/wallpaper")

def main():
    # 检查目录是否存在
    if not os.path.isdir(WALLPAPER_DIR):
        os.makedirs(WALLPAPER_DIR)
        subprocess.run(["notify-send", "创建壁纸目录", f"已在 {WALLPAPER_DIR} 创建壁纸目录"])
        return

    # 递归获取所有壁纸文件
    wallpapers = []
    for ext in ["*.jpg", "*.jpeg", "*.png", "*.gif"]:
        wallpapers.extend(list(Path(WALLPAPER_DIR).rglob(ext)))
    
    # 如果没有找到壁纸文件
    if len(wallpapers) == 0:
        subprocess.run(["notify-send", "没有找到壁纸", f"在 {WALLPAPER_DIR} 中没有找到壁纸文件"])
        return

    # 随机选择一张壁纸
    selected_wallpaper = random.choice(wallpapers)
    
    # 发送通知
    subprocess.run(["notify-send", "更换壁纸", f"正在切换到 {str(selected_wallpaper).split('/')[-1]}"])
    
    # 设置壁纸
    subprocess.run([
        "swww", "img", str(selected_wallpaper),
        "--transition-type", "wipe",
        "--transition-angle", "30",
        "--transition-step", "90"
    ])

if __name__ == "__main__":
    main() 
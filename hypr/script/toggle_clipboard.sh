#!/bin/bash

# 检查 wofi 是否正在运行
if pgrep -x "wofi" > /dev/null; then
    # 如果正在运行，关闭 clip
    pkill wofi
else
    # 如果未运行，启动 clip
    cliphist list | wofi -S dmenu | cliphist decode | wl-copy &
fi

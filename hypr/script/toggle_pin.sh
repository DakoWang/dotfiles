#!/bin/bash

# 获取当前活动窗口ID
ACTIVE_WINDOW=$(hyprctl activewindow | grep "address" | awk '{print $2}')

# 检查窗口是否已被pin
PINNED=$(hyprctl clients | grep "$ACTIVE_WINDOW" | grep -o "pinned:yes")

if [ -n "$PINNED" ]; then
    hyprctl dispatch unpin "$ACTIVE_WINDOW"
else
    hyprctl dispatch pin "$ACTIVE_WINDOW"
fi

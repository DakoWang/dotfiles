#!/bin/bash

# 检查 bwmenu 是否正在运行
if pgrep -x "rofi" > /dev/null; then
    # 如果正在运行，关闭 Rofi
    pkill rofi
else
    notify-send "Launching BitwardenMenu" -t 3000
    /usr/local/bin/bwmenu --rofi -p &
fi
    

#!/bin/bash
selected=$(cat ~/.ssh/hosts | wofi --show dmenu --prompt "SSH > ")

if [ -n "$selected" ]; then
    #kitty -e ssh $selected  # 使用 kitty 终端，可替换为 alacritty、foot 等
    kitty kitten ssh $selected  # 使用 kitty 终端，可替换为 alacritty、foot 等
fi

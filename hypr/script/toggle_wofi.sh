#!/bin/bash

# 检查 Rofi 是否正在运行
if pgrep -x "wofi" >/dev/null; then
  # 如果正在运行，关闭 Rofi
  pkill wofi
else
  # 如果未运行，启动 Rofi
  wofi --show=drun &
fi

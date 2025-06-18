#!/bin/bash

# 获取当前窗口标题并转义特殊字符
TITLE=$(hyprctl activewindow -j | jq '.title' -r | sed 's/[.[\*^$]/\\&/g')
echo $TITLE
# 创建并应用窗口规则
hyprctl dispatch windowrule "plugin:hyprbars:nobar, title:^$TITLE$"

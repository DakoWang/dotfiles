#!/bin/bash

# 获取当前窗口信息
win_info=$(hyprctl -j activewindow)
workspace_id=$(echo "$win_info" | jq -r '.workspace.id')
window_title=$(echo "$win_info" | jq -r '.initialTitle')
# window_class=$(echo "$win_info" | jq -r '.class')

if [[ "$win_info" == "{}" ]]; then
  notify-send -t 1500 "♿ 窗口不存在" \
    "要移动的窗口不存在，可能没有选中喵"
  exit 1
fi


if [[ "$workspace_id" == "-98" ]]; then
  old_spaces_cnt=$(hyprctl workspaces -j | jq -r '.[] | select(.name == "special:magic") | .windows')
  hyprctl dispatch movetoworkspacesilent +0

  # 重新获取 magic 工作区信息
  magic_windows=$(hyprctl -j clients | jq -r '.[] | select(.workspace.name == "special:magic") | .initialTitle')
  magic_window_count=$(echo "$magic_windows" | wc -l)

  # if ((magic_window_count == 0)); then
  if ((old_spaces_cnt-1 == 0)); then
    notify-send -t 3000 "♿ Magic 工作区已空" \
      "『$window_title』已移出\nMagic 工作区没东西了喵~"
  else
    magic_window_list=$(echo "$magic_windows" | sed 's/^/• /')
    notify-send -t 3000 "♿ 窗口移出 Magic 工作区" \
      "『$window_title』已移回当前工作区\n\n剩余窗口:$magic_window_count):\n$magic_window_list"
  fi
else
  hyprctl dispatch movetoworkspacesilent special:magic

  # 重新获取 magic 工作区信息
  magic_windows=$(hyprctl -j clients | jq -r '.[] | select(.workspace.name == "special:magic") | .initialTitle')
  magic_window_count=$(echo "$magic_windows" | wc -l)
  magic_window_list=$(echo "$magic_windows" | sed 's/^/• /')

  notify-send -t 5000 "♿ 窗口移至 Magic 工作区" \
    "『$window_title』已移动\n\nMagic窗口($magic_window_count):\n$magic_window_list"
fi

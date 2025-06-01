#!/bin/bash

# 检查参数数量
if [ $# -ne 2 ]; then
  echo "Usage: $0 <full|area> <true|false>"
  echo "  full: 截取全屏"
  echo "  area: 区域选择截图"
  echo "  true: 启用swappy编辑"
  echo "  false: 禁用swappy编辑"
  exit 1
fi

# 获取参数
MODE="$1"
EDIT="$2"

# 创建截图保存目录
SCREENSHOT_DIR="$HOME/Pictures/ScreenShots"
mkdir -p "$SCREENSHOT_DIR"

# 生成文件名（使用时间戳）
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SAVE_FILE="$SCREENSHOT_DIR/screenshot_$TIMESTAMP.png"

# 临时文件路径
TEMP_FILE=$(mktemp --suffix=.png)

# 截图功能
case $MODE in
full)
  if grim "$TEMP_FILE"; then
    notify-send -t 3000 "♿ 全屏快照" "全屏截图已保存到剪贴板\n原图保存在: $SAVE_FILE"
  else
    notify-send -t 3000 "♿ 截图失败" "哎呀，相机好像卡住了..."
    rm -f "$TEMP_FILE"
    exit 1
  fi
  ;;
area)
  SLURP_OUTPUT=$(slurp 2>&1)
  # 处理用户取消选择的情况（包括双击ESC或右键取消）
  if [[ "$SLURP_OUTPUT" =~ "selection cancelled" ]] || [ -z "$SLURP_OUTPUT" ]; then
    notify-send -t 2000 "♿ 截图取消" "好吧，当我没问~"
    rm -f "$TEMP_FILE"
    exit 0
  fi
  
  if grim -g "$SLURP_OUTPUT" "$TEMP_FILE"; then
    # 图片尺寸
    image_size=$(identify "$TEMP_FILE" | awk '{print $3}')
    notify-send -t 3000 "♿ 区域捕获" "框选了$image_size的区域\n已保存到剪贴板\n原图保存在: $SAVE_FILE"
  else
    notify-send -t 3000 "♿ 截图失败" "手抖了？框框不见了..."
    rm -f "$TEMP_FILE"
    exit 1
  fi
  ;;
*)
  notify-send -t 3000 "♿ 参数错误" "喂，你要全屏(full)还是区域(area)啊？"
  rm -f "$TEMP_FILE"
  exit 1
  ;;
esac

# 检查截图是否成功
if [ ! -s "$TEMP_FILE" ]; then
  notify-send -t 3000 "♿ 文件异常" "截图神秘消失了..."
  rm -f "$TEMP_FILE"
  exit 1
fi

# 保存原图到指定目录
cp "$TEMP_FILE" "$SAVE_FILE"

# 复制到剪贴板
if wl-copy < "$TEMP_FILE"; then
  echo "截图已保存到剪贴板"
else
  notify-send -t 3000 "♿ 剪贴板错误" "剪贴板拒绝接收我的礼物😭"
  rm -f "$TEMP_FILE"
  exit 1
fi

# 二次编辑处理
if [ "$EDIT" = "true" ]; then
  if swappy -f "$TEMP_FILE" -o "$TEMP_FILE" 2>/dev/null; then
    wl-copy < "$TEMP_FILE"
  else
    notify-send -t 3000 "♿ 编辑失败" "画板罢工了..."
  fi
elif [ "$EDIT" != "false" ]; then
  notify-send -t 2000 "♿ 参数警告" "编辑参数只能是true/false"
fi

# 清理临时文件
rm -f "$TEMP_FILE"
exit 0
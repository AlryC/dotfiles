#!/bin/sh

SHADER="$HOME/.config/picom/shaders/grayscale.glsl"

# 1. Kill picom properly
pkill picom
while pgrep -u $USER -x picom >/dev/null; do sleep 0.1; done

# 2. Check a flag file to decide which way to start
FLAG="/tmp/picom_mono_on"

if [ ! -f "$FLAG" ]; then
  # START MONOCHROME
  # We use --config /dev/null to ensure your main config doesn't override the shader
  picom --config /dev/null --backend glx --window-shader-fg "$SHADER" -b
  touch "$FLAG"
  echo "Monochrome Enabled"
else
  # START NORMAL
  # This restarts picom with your regular config (~/.config/picom/picom.conf)
  picom -b
  rm "$FLAG"
  echo "Monochrome Disabled"
fi

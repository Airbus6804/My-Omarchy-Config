#!/bin/bash
# Battery level + icon for hyprlock

bat=/sys/class/power_supply/BAT1
[ -d "$bat" ] || exit 0

cap=$(cat "$bat/capacity")
status=$(cat "$bat/status")

if [ "$status" = "Charging" ]; then
  icon="󰂄"
elif [ "$cap" -ge 80 ]; then
  icon="󰁹"
elif [ "$cap" -ge 55 ]; then
  icon="󰁿"
elif [ "$cap" -ge 25 ]; then
  icon="󰁽"
else
  icon="󰁻"
fi

echo "$icon  $cap%"

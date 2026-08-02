#!/bin/bash
# Time-of-day greeting for hyprlock

hour=$(date +%-H)

if [ "$hour" -lt 5 ]; then
  greet="Still up"
elif [ "$hour" -lt 12 ]; then
  greet="Good morning"
elif [ "$hour" -lt 18 ]; then
  greet="Good afternoon"
else
  greet="Good evening"
fi

echo "$greet, $(whoami)"

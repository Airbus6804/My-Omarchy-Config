#!/bin/bash

LOCK_FILE="~/.config/waybar/cp-lock"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


if [[ ! -f "$LOCK_FILE" ]]; then
    # File doesn't exist, do something here
    cp -r ~/.config/waybar ~/.config/waybar.backup
fi

rm -rf ~/.config/waybar

cp -r $SCRIPT_DIR/config ~/.config/waybar/


#!/bin/bash

# Script to install the custom hyprlock (lock screen) config and inject a
# matching color palette into every omarchy theme.
#
# 1. Copies .config/hypr/hyprlock.conf + .config/hypr/lock/*.sh into ~/.config/hypr/
# 2. For each theme in ~/.config/omarchy/themes/[theme-name]/hyprlock.conf, appends
#    a marked block of extra color variables derived from that theme's own colors,
#    so the lock screen matches whatever theme is active.
#
# The injected block is delimited by markers and is re-generated on every run,
# so running this script repeatedly is safe.

SETUP_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SOURCE_HYPR_DIR="$SETUP_DIR/../.config/hypr"
HYPR_DIR="$HOME/.config/hypr"
OMARCHY_THEMES_DIR="$HOME/.config/omarchy/themes"

BEGIN_MARKER="# >>> custom-config lock screen >>>"
END_MARKER="# <<< custom-config lock screen <<<"

# ── Install the lock screen config ───────────────────────────

if [ ! -f "$SOURCE_HYPR_DIR/hyprlock.conf" ]; then
    echo "Error: $SOURCE_HYPR_DIR/hyprlock.conf does not exist"
    exit 1
fi

mkdir -p "$HYPR_DIR/lock"

# Back up the current lock screen config the first time we replace it
if [ -f "$HYPR_DIR/hyprlock.conf" ] && [ ! -f "$HYPR_DIR/hyprlock.conf.orig" ]; then
    if ! cmp -s "$HYPR_DIR/hyprlock.conf" "$SOURCE_HYPR_DIR/hyprlock.conf"; then
        cp "$HYPR_DIR/hyprlock.conf" "$HYPR_DIR/hyprlock.conf.orig"
        echo "Backed up existing hyprlock.conf to $HYPR_DIR/hyprlock.conf.orig"
    fi
fi

cp "$SOURCE_HYPR_DIR/hyprlock.conf" "$HYPR_DIR/hyprlock.conf"
cp "$SOURCE_HYPR_DIR/lock/"*.sh "$HYPR_DIR/lock/"
chmod +x "$HYPR_DIR/lock/"*.sh
echo "Installed hyprlock.conf and lock scripts into $HYPR_DIR"

# ── Color helpers ────────────────────────────────────────────

# Read a hyprland color value and echo it as "R, G, B" decimal.
# Accepts rgba(35, 37, 41, 1), rgb(1a1b1e), rgba(1a1b1eff) and rgb(35, 37, 41).
# Echoes nothing if the value is missing, not parseable, or fully transparent
# (some themes use rgba(0, 0, 0, 0) as a placeholder for "unset").
parse_rgb() {
    local value="$1"
    local inner red green blue alpha

    # Strip everything outside the parentheses, and all whitespace
    inner="${value#*\(}"
    inner="${inner%\)*}"
    inner="${inner// /}"

    if [[ "$inner" == *,* ]]; then
        # Comma separated: take the first three components
        IFS=',' read -r red green blue alpha _ <<< "$inner"
        # Only accept plain decimal components in 0-255
        for component in "$red" "$green" "$blue"; do
            if ! [[ "$component" =~ ^[0-9]+$ ]] || [ "$component" -gt 255 ]; then
                return
            fi
        done
        # A fully transparent color carries no usable hue
        if [[ "$alpha" =~ ^0(\.0+)?$ ]]; then
            return
        fi
    elif [[ "$inner" =~ ^[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$ ]]; then
        # Hex: rrggbb or rrggbbaa
        red=$((16#${inner:0:2}))
        green=$((16#${inner:2:2}))
        blue=$((16#${inner:4:2}))
        if [ ${#inner} -eq 8 ] && [ $((16#${inner:6:2})) -eq 0 ]; then
            return
        fi
    else
        return
    fi

    echo "$red, $green, $blue"
}

# Echo "R, G, B" for a $variable defined in a hyprland style config file
rgb_of_var() {
    local var="$1" file="$2" line
    line=$(grep -m1 -E "^\\\$$var[[:space:]]*=" "$file" 2>/dev/null)
    [ -n "$line" ] || return
    parse_rgb "${line#*=}"
}

# Echo "R, G, B" for the theme's active window border color
rgb_of_border() {
    local file="$1" line
    [ -f "$file" ] || return
    line=$(grep -m1 -E "^[[:space:]]*col\.active_border[[:space:]]*=" "$file" 2>/dev/null)
    [ -n "$line" ] || return
    # Gradients list several colors, the first one is enough
    parse_rgb "${line#*=}"
}

# ── Inject the palette into every theme ──────────────────────

if [ ! -d "$OMARCHY_THEMES_DIR" ]; then
    echo "Error: $OMARCHY_THEMES_DIR does not exist"
    exit 1
fi

for theme_dir in "$OMARCHY_THEMES_DIR"/*; do
    [ -d "$theme_dir" ] || continue

    theme_name=$(basename "$theme_dir")
    theme_file="$theme_dir/hyprlock.conf"

    if [ ! -f "$theme_file" ]; then
        echo "Warning: theme '$theme_name' has no hyprlock.conf, skipping..."
        continue
    fi

    # Drop any previously injected block so we always regenerate it
    sed -i "\%^$BEGIN_MARKER\$%,\%^$END_MARKER\$%d" "$theme_file"

    background=$(rgb_of_var color "$theme_file")
    foreground=$(rgb_of_var font_color "$theme_file")
    accent=$(rgb_of_var outer_color "$theme_file")
    check=$(rgb_of_var check_color "$theme_file")
    border=$(rgb_of_border "$theme_dir/hyprland.conf")

    # Some themes leave the base colors unset or fully transparent. Give those
    # neutral values, otherwise the lock screen renders invisible text.
    patched=""
    if [ -z "$background" ]; then background="28, 31, 37"; patched="$patched color"; fi
    if [ -z "$foreground" ]; then foreground="230, 232, 235"; patched="$patched font_color"; fi
    if [ -z "$accent" ]; then accent="150, 160, 175"; patched="$patched outer_color"; fi
    if [ -z "$check" ]; then check="126, 173, 172"; patched="$patched check_color"; fi

    # Fall back to the accent color when the theme sets no window border
    [ -n "$border" ] || border="$accent"

    {
        echo ""
        echo "$BEGIN_MARKER"
        echo "# Generated by utils/inject-hyprlock.sh - edits here are overwritten"
        for base in $patched; do
            case "$base" in
                color) echo "\$color = rgba($background, 1)" ;;
                font_color) echo "\$font_color = rgba($foreground, 1)" ;;
                outer_color) echo "\$outer_color = rgba($accent, 1)" ;;
                check_color) echo "\$check_color = rgba($check, 1)" ;;
            esac
        done
        echo "\$inner_color = rgba($background, 0.55)"
        echo "\$panel_color = rgba($background, 0.40)"
        echo "\$panel_border = rgba($border, 0.45)"
        echo "\$muted_color = rgba($foreground, 0.55)"
        echo "\$accent_soft = rgba($accent, 0.80)"
        echo "\$fail_color = rgba(164, 132, 132, 1)"
        echo "$END_MARKER"
    } >> "$theme_file"

    echo "Injected lock screen palette into theme '$theme_name'"
done

echo "Done!"

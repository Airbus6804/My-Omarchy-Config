#!/bin/bash

# Script to copy background images from this repo to omarchy user backgrounds
# Checks each folder in themes/backgrounds/[theme-name]
# and copies images to $HOME/.config/omarchy/backgrounds/[theme-name]/
# (Omarchy 4 reads this folder live; theme folders are snapshotted on theme-set)

SETUP_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CUSTOM_BACKGROUNDS_DIR="$SETUP_DIR/../themes/backgrounds"
OMARCHY_BACKGROUNDS_DIR="$HOME/.config/omarchy/backgrounds"

# Check if custom backgrounds directory exists
if [ ! -d "$CUSTOM_BACKGROUNDS_DIR" ]; then
    echo "Error: $CUSTOM_BACKGROUNDS_DIR does not exist"
    exit 1
fi


# Iterate through each theme folder in custom-config/themes/backgrounds
for theme_dir in "$CUSTOM_BACKGROUNDS_DIR"/*; do
    # Check if it's a directory
    if [ ! -d "$theme_dir" ]; then
        continue
    fi
    
    # Get the theme name (last folder name)
    theme_name=$(basename "$theme_dir")
    
    # Create user backgrounds directory for this theme if it doesn't exist
    dest_dir="$OMARCHY_BACKGROUNDS_DIR/$theme_name"
    mkdir -p "$dest_dir"
    
    # Copy all images from custom-config backgrounds directory
    echo "Copying backgrounds from $theme_name to omarchy..."
    # Omarchy's image picker ignores HEIC/HEIF, so those get converted to JPG
    for src in "$theme_dir"/*; do
        [ -f "$src" ] || continue
        name=$(basename "$src")
        case "${name,,}" in
            *.heic|*.heif)
                dest="$dest_dir/${name%.*}.jpg"
                rm -f "$dest_dir/$name"  # drop raw HEIC copies from older runs
                if [ ! -e "$dest" ]; then
                    magick "$src" -quality 100 "$dest" \
                        || echo "  Warning: failed to convert $name"
                fi
                ;;
            *)
                cp -n "$src" "$dest_dir/" 2>/dev/null || true
                ;;
        esac
    done
    
    # Count copied files
    copied_count=$(find "$dest_dir" -type f | wc -l)
    echo "  Copied images to $dest_dir (total: $copied_count file(s))"
done

echo "Done!"

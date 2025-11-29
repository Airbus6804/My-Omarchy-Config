#!/bin/bash

# Script to copy background images from custom-config to omarchy themes
# Checks each folder in $HOME/.config/custom-config/themes/backgrounds/[theme-name]
# and copies images to $HOME/.config/omarchy/themes/[theme-name]/backgrounds/

CUSTOM_BACKGROUNDS_DIR="$HOME/.config/custom-config/themes/backgrounds"
OMARCHY_THEMES_DIR="$HOME/.config/omarchy/themes"

# Check if custom backgrounds directory exists
if [ ! -d "$CUSTOM_BACKGROUNDS_DIR" ]; then
    echo "Error: $CUSTOM_BACKGROUNDS_DIR does not exist"
    exit 1
fi

# Check if omarchy themes directory exists
if [ ! -d "$OMARCHY_THEMES_DIR" ]; then
    echo "Error: $OMARCHY_THEMES_DIR does not exist"
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
    
    # Check if corresponding theme exists in omarchy
    omarchy_theme_dir="$OMARCHY_THEMES_DIR/$theme_name"
    if [ ! -d "$omarchy_theme_dir" ]; then
        echo "Warning: Theme '$theme_name' not found in omarchy/themes, skipping..."
        continue
    fi
    
    # Create backgrounds directory in omarchy theme if it doesn't exist
    dest_dir="$omarchy_theme_dir/backgrounds"
    mkdir -p "$dest_dir"
    
    # Copy all images from custom-config backgrounds directory
    echo "Copying backgrounds from $theme_name to omarchy..."
    cp -n "$theme_dir"/* "$dest_dir/" 2>/dev/null || true
    
    # Count copied files
    copied_count=$(find "$dest_dir" -type f | wc -l)
    echo "  Copied images to $dest_dir (total: $copied_count file(s))"
done

echo "Done!"

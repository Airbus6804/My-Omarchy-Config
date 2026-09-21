SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

chmod +x "$SCRIPT_DIR/../.config/hypr/"*.sh 2>/dev/null || true
chmod +x "$SCRIPT_DIR/../.config/hypr/latest-cursor-projects-menu.sh/"*.sh 2>/dev/null || true
chmod +x "$SCRIPT_DIR/../.config/hypr/lock/"*.sh 2>/dev/null || true

cp -r "$SCRIPT_DIR/../.config/hypr/"* ~/.config/hypr/

# Omarchy 4 uses hyprland.lua; copy hyprlock.conf separately if missing
if [[ -f "$SCRIPT_DIR/../.config/hypr/hyprlock.conf" ]]; then
  cp "$SCRIPT_DIR/../.config/hypr/hyprlock.conf" ~/.config/hypr/hyprlock.conf
fi

echo "Hyprland config synced to ~/.config/hypr/ (Omarchy 4 Lua files)"

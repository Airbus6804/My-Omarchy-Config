SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

chmod +x $SCRIPT_DIR/../.config/hypr/*.sh

cp -r $SCRIPT_DIR/../.config/hypr/* ~/.config/hypr/


hyprland_config_inject="source = ~/.config/hypr/custom-config.conf"
hyprland_config_file="$HOME/.config/hypr/hyprland.conf"

if [[ "$(cat $hyprland_config_file)" == *"$hyprland_config_inject"* ]]; then
    echo "hyprland config already injected into $hyprland_config_file"
else
    echo "injecting hyprland config into $hyprland_config_file"
    echo "$hyprland_config_inject" >> $hyprland_config_file
fi

# setup waybar
chmod +x $SCRIPT_DIR/../.config/waybar/setup-waybar.sh
$SCRIPT_DIR/../.config/waybar/setup-waybar.sh
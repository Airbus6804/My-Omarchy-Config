chmod +x extended-bashrc.sh
chmod +x aliases.sh
chmod +x utils/*.sh

# install nvm
utils/install-nvm.sh

# inject backgrounds
utils/inject-backgrounds.sh

# config hyprland
utils/config-hyprland.sh

# setup vesktop
utils/setup-vesktop.sh

# install cursor
yay -S cursor-bin


# inject extended-bashrc.sh into ~/.bashrc
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


extended_bashrc_inject="source $SCRIPT_DIR/extended-bashrc.sh"

if [[ "$(cat ~/.bashrc)" == *"$extended_bashrc_inject"* ]]; then
    echo "extended-bashrc.sh already injected into ~/.bashrc"·
else
    echo "injecting extended-bashrc.sh into ~/.bashrc"
    echo "$extended_bashrc_inject" >> ~/.bashrc
fi



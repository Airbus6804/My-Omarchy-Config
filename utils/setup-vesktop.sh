SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

yay -S vesktop

cp $SCRIPT_DIR/../themes/vesktop/* $HOME/.config/vesktop/themes/

node $SCRIPT_DIR/vesktop/settings.js
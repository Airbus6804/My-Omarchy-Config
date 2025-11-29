SETUP_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Add scripts directory to PATH
source "$SETUP_DIR/utils/add-to-path.sh" "$SETUP_DIR/scripts"

# add nvm to PATH
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# add aliases
source "$SETUP_DIR/aliases.sh"

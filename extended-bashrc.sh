SETUP_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Add scripts directory to PATH
source "$SETUP_DIR/utils/add-to-path.sh" "$SETUP_DIR/scripts"

# add nvm to PATH
# Omarchy disables hashing (set +h) and nvm runs `hash -r`, which prints
# "bash: hash: hashing disabled": re-enable it only while nvm loads
export NVM_DIR="$HOME/.config/nvm"
set -h
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Loading nvm doesn't activate a version: activate the default one
command -v nvm >/dev/null && nvm use default --silent >/dev/null 2>&1
set +h

# add aliases
source "$SETUP_DIR/aliases.sh"

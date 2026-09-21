#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p "$HOME/.config/omarchy/plugins" "$HOME/.config/omarchy/bar/scripts"

cp "$SCRIPT_DIR/../.config/omarchy/shell.json" "$HOME/.config/omarchy/shell.json"
chmod +x "$SCRIPT_DIR/../.config/omarchy/bar/scripts/"*.sh 2>/dev/null || true
cp "$SCRIPT_DIR/../.config/omarchy/bar/scripts/"* "$HOME/.config/omarchy/bar/scripts/" 2>/dev/null || true

if [[ -d "$SCRIPT_DIR/../.config/omarchy/plugins" ]]; then
  cp -r "$SCRIPT_DIR/../.config/omarchy/plugins/"* "$HOME/.config/omarchy/plugins/" 2>/dev/null || true
fi

if command -v omarchy >/dev/null 2>&1; then
  # Keep the built-in menu plugin: cloning it breaks the Apps submenu.
  omarchy plugin disable alessio.menu 2>/dev/null || true
  omarchy plugin enable omarchy.menu 2>/dev/null || true
  omarchy plugin enable alessio.workspaces 2>/dev/null || true
  omarchy plugin enable omarchy.media 2>/dev/null || true
  omarchy plugin disable omarchy.workspaces 2>/dev/null || true

  python3 "$SCRIPT_DIR/patch-bar-tooltips.py"

  for plugin in audio network bluetooth power monitor agents clock weather; do
    omarchy plugin enable "alessio.${plugin}" 2>/dev/null || true
    omarchy plugin disable "omarchy.${plugin}" 2>/dev/null || true
  done
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
fi

echo "Omarchy shell config synced to ~/.config/omarchy/shell.json"

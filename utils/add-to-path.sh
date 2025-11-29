#!/bin/bash

# Utility script to add a path to the PATH environment variable
# Usage: add-to-path.sh <path>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path>"
    exit 1
fi

NEW_PATH="$1"

# Check if path already exists in PATH
if [[ ":$PATH:" == *":$NEW_PATH:"* ]]; then
    exit 0
fi

# Export PATH with the new path appended
export PATH="$NEW_PATH:$PATH"
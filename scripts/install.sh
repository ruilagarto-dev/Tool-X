#!/bin/bash

SCRIPT_NAMES=("del" "size")
TARGET_DIR="/usr/local/bin"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing Tool-X utilities..."

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed. Please install it first." >&2
    exit 1
fi

for script in "${SCRIPT_NAMES[@]}"; do

    script_path="$SOURCE_DIR/src/$script.py"

    if [ ! -f "$script_path" ]; then
        echo "Error: File '$script_path' not found." >&2
        exit 1
    fi

    chmod +x "$script_path"

    echo "Linking $script to $TARGET_DIR/"
    sudo ln -sf "$script_path" "$TARGET_DIR/$script"

    if [ -f "$TARGET_DIR/$script" ]; then
        echo "$script installed successfully!"
    else
        echo "Error: $script installation failed." >&2
        exit 1
    fi
done

echo "Installation completed successfully!"
echo "You can now use the commands: ${SCRIPT_NAMES[*]}"

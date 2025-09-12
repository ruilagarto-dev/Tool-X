#!/bin/bash

SCRIPT_NAMES=(
    "tool-x" "del" 
    "size" "tree" 
    "open"
)
TARGET_DIR="/usr/local/bin"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REQUIREMENTS_FILE="$SOURCE_DIR/requirements.txt"

echo "Installing Tool-X utilities..."

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed. Please install it first." >&2
    exit 1
fi

if [ "$EUID" -eq 0 ]; then
    echo "Error: Please do not run this script as root. It will use sudo when needed." >&2
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "$SOURCE_DIR/venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$SOURCE_DIR/venv"
fi

# Activate virtual environment
source "$SOURCE_DIR/venv/bin/activate"

echo "Installing Python dependencies..."
if [ -f "$REQUIREMENTS_FILE" ]; then
    pip install -r "$REQUIREMENTS_FILE"
else
    # Install minimal requirements
    pip install Pillow
fi

# Update Python scripts to use venv python
for script in "${SCRIPT_NAMES[@]}"; do
    script_path="$SOURCE_DIR/src/$script"
    
    if [ ! -f "$script_path" ]; then
        echo "Error: File '$script_path' not found." >&2
        exit 1
    fi
    
    # Update shebang to use venv python for Python scripts
    if head -n 1 "$script_path" | grep -q "^#!/usr/bin/env python3"; then
        echo "Updating shebang for $script to use venv Python..."
        sed -i "1s|.*|#!$SOURCE_DIR/venv/bin/python3|" "$script_path"
    fi
    
    chmod +x "$script_path"
    echo "Made $script_path executable"

    echo "Linking $script to $TARGET_DIR/"
    sudo ln -sf "$script_path" "$TARGET_DIR/$script"

    if [ -L "$TARGET_DIR/$script" ] && [ -e "$TARGET_DIR/$script" ]; then
        echo "$script installed successfully!"
    else
        echo "Error: $script installation failed." >&2
        exit 1
    fi
done

deactivate

echo ""
echo "Installation completed successfully!"
echo "You can now use the commands: ${SCRIPT_NAMES[*]}"
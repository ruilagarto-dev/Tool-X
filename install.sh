#!/bin/bash

SCRIPT_NAMES=("del" "size")
TARGET_DIR="/usr/local/bin"

echo "Installing Tool-X utilities..."

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed. Please install it first."
    exit 1
fi

for script in "${SCRIPT_NAMES[@]}"; do
    # Check if the script exists in the current directory
    if [ ! -f "$script" ]; then
        echo "Error: File '$script' not found in the current directory."
        exit 1
    fi
done

# Copy scripts to /usr/local/bin
for script in "${SCRIPT_NAMES[@]}"; do
    echo "Copying $script to $TARGET_DIR..."
    sudo cp "$script" "$TARGET_DIR/"
    
    # Give executable permission
    sudo chmod +x "$TARGET_DIR/$script"
done

# Check if the copy was successful
for script in "${SCRIPT_NAMES[@]}"; do
    if [ -f "$TARGET_DIR/$script" ]; then
        echo "$script installed successfully!"
    else
        echo "Error: $script installation failed."
        exit 1
    fi
done

echo "Installation completed successfully!"
echo "You can now use the commands: ${SCRIPT_NAMES[*]}"

#!/bin/bash

SCRIPT_NAMES=(
    "tool-x" "del" 
    "size" "tree" 
    "open"
)

TARGET_DIR="/usr/local/bin"

echo "Uninstalling Tool-X utilities..."

# Remove each script
for script in "${SCRIPT_NAMES[@]}"; do
    script_path="$TARGET_DIR/$script"
    
    if [ -L "$script_path" ] || [ -f "$script_path" ]; then
        echo "Removing $script..."
        sudo rm -f "$script_path"
        
        if [ ! -f "$script_path" ]; then
            echo "$script successfully uninstalled."
        else
            echo "Error: Failed to remove $script." >&2
            exit 1
        fi
    else
        echo "$script is not installed."
    fi
done

echo "Uninstallation completed successfully!"
echo "The commands: [${SCRIPT_NAMES[*]}] have been removed from your system."

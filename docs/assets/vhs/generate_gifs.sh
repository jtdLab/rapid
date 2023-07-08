#!/bin/bash

############################################################################################
# Run from docs/assets/vhs
# sh generate_gifs.sh
############################################################################################
# Generates fresh GIFS for documentation
############################################################################################

current_directory=$(pwd)
dot_generated_directory=".generated"

tapes=("create.tape")

for tape in "${tapes[@]}"; do
    echo "Generating GIF for $tape..."
    # Check if the dot_generated_directory exists
    if [ -d "$dot_generated_directory" ]; then
        rm -rf "$dot_generated_directory"
    fi
    mkdir "$dot_generated_directory"
    cd "$dot_generated_directory"
    # Create GIF
    vhs $tape
    # Move GIF to /vhs
    find "$dot_generated_directory" -type f -name "*.gif" -exec cp {} "$current_directory" \;
    cd ..
done

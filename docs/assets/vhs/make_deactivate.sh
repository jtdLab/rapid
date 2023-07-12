#!/bin/bash

############################################################################################
# Run from docs/assets/vhs
# sh make_deactivate.sh
############################################################################################
# Generates fresh deactivate.gif
############################################################################################

current_directory=$(pwd)
dot_generated_directory=".generated"

echo "Generating GIF for deactivate.tape..."
# Check if the dot_generated_directory exists
if [ -d "$dot_generated_directory" ]; then
    rm -rf "$dot_generated_directory"
fi
mkdir "$dot_generated_directory"
cd "$dot_generated_directory"
rapid create demo_app --web
# Create GIF
vhs "../deactivate.tape"
# Move GIF to /vhs
find . -type f -name "*.gif" -exec cp {} "$current_directory" \;
cd ..

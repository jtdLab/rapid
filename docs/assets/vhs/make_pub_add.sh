#!/bin/bash

############################################################################################
# Run from docs/assets/vhs
# sh make_pub_add.sh
############################################################################################
# Generates fresh pub_add.gif
############################################################################################

current_directory=$(pwd)
dot_generated_directory=".generated"

echo "Generating GIF for pub_add.tape..."
# Check if the dot_generated_directory exists
if [ -d "$dot_generated_directory" ]; then
    rm -rf "$dot_generated_directory"
fi
mkdir "$dot_generated_directory"
cd "$dot_generated_directory"
rapid create demo_app
# Create GIF
vhs "../pub_add.tape"
# Move GIF to /vhs
find . -type f -name "*.gif" -exec cp {} "$current_directory" \;
cd ..

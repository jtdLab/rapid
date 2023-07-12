#!/bin/bash

############################################################################################
# Run from docs/assets/vhs
# sh make_pub_get.sh
############################################################################################
# Generates fresh pub_get.gif
############################################################################################

current_directory=$(pwd)
dot_generated_directory=".generated"

echo "Generating GIF for pub_get.tape..."
# Check if the dot_generated_directory exists
if [ -d "$dot_generated_directory" ]; then
    rm -rf "$dot_generated_directory"
fi
mkdir "$dot_generated_directory"
cd "$dot_generated_directory"
rapid create demo_app
# Create GIF
vhs "../pub_get.tape"
# Move GIF to /vhs
find . -type f -name "*.gif" -exec cp {} "$current_directory" \;
cd ..

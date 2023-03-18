#!/bin/bash

# Run from packages/rapid_cli
# sh tool/rebundle_templates.sh

# Rebundles all mason templates and updates them in rapid_cli package.

# # arb_file
# echo "Rebundling arb_file template ..."
# mason bundle templates/arb_file -t dart
# mv arb_file_bundle.dart lib/src/project/platform_directory/platform_features_directory/platform_feature_package

#!/bin/bash

# Define the input templates and destination directories as a list of triplets
templates=(
    "arb_file templates/arb_file lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "bloc templates/bloc lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "cubit templates/cubit lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "data_transfer_object templates/data_transfer_object lib/src/project/infrastructure_package"
)

# Loop through the list of triplets and bundle and move each template
for template in "${templates[@]}"; do
    # Split the triplet into its three parts
    template_name=$(echo "$template" | cut -d ' ' -f 1)
    template_location=$(echo "$template" | cut -d ' ' -f 2)
    destination_dir=$(echo "$template" | cut -d ' ' -f 3)

    echo "Rebundling template $template_name..."
    mason bundle "$template_location" -t dart
    mv "${template_name}_bundle.dart" "$destination_dir"
done

dart format lib --fix

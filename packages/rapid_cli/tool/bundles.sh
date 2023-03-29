#!/bin/bash

# Run from packages/rapid_cli
# sh tool/bundles.sh

# Rebundles all mason templates and ships the fresh bundles to rapid_cli package.
# (name, location, destination) 
templates=(
    "arb_file templates/arb_file lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "bloc templates/bloc lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "cubit templates/cubit lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "data_transfer_object templates/data_transfer_object lib/src/project/infrastructure_package"
    "di_package templates/di_package lib/src/project/di_package"
    "domain_package templates/domain_package lib/src/project/domain_package"
    "entity templates/entity lib/src/project/domain_package"
    "infrastructure_package templates/infrastructure_package lib/src/project/infrastructure_package"
    "logging_package templates/logging_package lib/src/project/logging_package"
    "platform_app_feature_package templates/platform_app_feature_package lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "platform_feature_package templates/platform_feature_package lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "platform_navigation_package templates/platform_navigation_package lib/src/project/platform_directory/platform_navigation_package"
    "platform_root_package templates/platform_root_package lib/src/project/platform_directory/platform_root_package"
    "android_native_directory templates/platform_root_package/android_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
    "ios_native_directory templates/platform_root_package/ios_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
    "linux_native_directory templates/platform_root_package/linux_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
    "macos_native_directory templates/platform_root_package/macos_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
    "web_native_directory templates/platform_root_package/web_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
    "windows_native_directory templates/platform_root_package/windows_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
    "platform_ui_package templates/platform_ui_package lib/src/project/platform_ui_package"
    "project templates/project lib/src/project"
    "service_implementation templates/service_implementation lib/src/project/infrastructure_package"
    "service_interface templates/service_interface lib/src/project/domain_package"
    "ui_package templates/ui_package lib/src/project/ui_package"
    "value_object templates/value_object lib/src/project/domain_package"
    "widget templates/widget lib/src/project/platform_ui_package"
)

for template in "${templates[@]}"; do
    template_name=$(echo "$template" | cut -d ' ' -f 1)
    template_location=$(echo "$template" | cut -d ' ' -f 2)
    destination_dir=$(echo "$template" | cut -d ' ' -f 3)

    echo "Rebundling template $template_name..."
    mason bundle "$template_location" -t dart
    mv "${template_name}_bundle.dart" "$destination_dir"
done

dart format lib --fix

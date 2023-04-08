#!/bin/bash

# Run from packages/rapid_cli
# sh tool/bundles.sh

# Updates dart + flutter sdks and the version of dependencies of all package mason templates

#!/bin/bash

# SDK versions
declare -a sdks=(
    "sdk=>=2.19.6 <3.0.0"
    "flutter=>=3.7.10"
)

# Other package versions
declare -a packages=(
    "auto_route=^6.0.5"
    "auto_route_generator=^6.0.3"
    "bloc_concurrency=^0.2.1"
    "bloc_test=^9.1.1"
    "bloc=^8.1.1"
    "build_runner=^2.3.2"
    "cupertino_icons=^1.0.5"
    "dartz=^0.10.1"
    "faker=^2.1.0"
    "fluent_ui=^4.4.2"
    "flutter_lints=^2.0.1"
    "freezed_annotation=^2.2.0"
    "freezed=^2.3.2"
    "get_it=^7.2.0"
    "injectable_generator=^2.1.5"
    "injectable=^2.1.1"
    "intl=any"
    "json_annotation=^4.8.0"
    "json_serializable=^6.6.1"
    "lints=^2.0.1"
    "macos_ui=^1.12.2"
    "meta=^1.8.0"
    "mocktail=^0.3.0"
    "test=^1.24.1"
    "theme_tailor_annotation=^1.1.1"
    "theme_tailor=^1.1.2"
    "yaru_icons=^1.0.4"
    "yaru=^0.6.2"
)

declare -a packageTemplatePaths=(
    "templates/di_package"
    "templates/domain_package"
    "templates/infrastructure_package"
    "templates/logging_package"
    "templates/platform_app_feature_package"
    "templates/platform_feature_package"
    "templates/platform_navigation_package"
    "templates/platform_root_package"
    "templates/platform_ui_package"
    "templates/ui_package"
)

for path in "${packageTemplatePaths[@]}"; do
    pubspec_path="$path/__brick__/pubspec.yaml"
    for sdk in "${sdks[@]}"; do
        name="${sdk%%=*}"
        version="${sdk#*=}"
        sed -i '' -E "s/^([[:blank:]]+)$name:[[:blank:]]*\".+\"([[:blank:]]*)$/\1$name: \"$version\"\2/" "$pubspec_path"
    done

    for package in "${packages[@]}"; do
        name="${package%=*}"
        version="${package#*=}"
        echo $name
        echo $version
        sed -i '' -E "s/^(.+)$name:[[:blank:]]*\^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+(.*)$/\1$name: $version\2/" "$pubspec_path"
    done
done

# # Rebundles all mason templates and ships the fresh bundles to rapid_cli package.
# # (name, location, destination)
# templates=(
#     "arb_file templates/arb_file lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
#     "bloc templates/bloc lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
#     "cubit templates/cubit lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
#     "data_transfer_object templates/data_transfer_object lib/src/project/infrastructure_dir/infrastructure_package"
#     "di_package templates/di_package lib/src/project/di_package"
#     "domain_package templates/domain_package lib/src/project/domain_dir/domain_package"
#     "entity templates/entity lib/src/project/domain_dir/domain_package"
#     "infrastructure_package templates/infrastructure_package lib/src/project/infrastructure_dir/infrastructure_package"
#     "logging_package templates/logging_package lib/src/project/logging_package"
#     "platform_app_feature_package templates/platform_app_feature_package lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
#     "platform_feature_package templates/platform_feature_package lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
#     "platform_navigation_package templates/platform_navigation_package lib/src/project/platform_directory/platform_navigation_package"
#     "platform_root_package templates/platform_root_package lib/src/project/platform_directory/platform_root_package"
#     "android_native_directory templates/platform_root_package/android_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
#     "ios_native_directory templates/platform_root_package/ios_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
#     "linux_native_directory templates/platform_root_package/linux_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
#     "macos_native_directory templates/platform_root_package/macos_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
#     "web_native_directory templates/platform_root_package/web_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
#     "windows_native_directory templates/platform_root_package/windows_native_directory lib/src/project/platform_directory/platform_root_package/platform_native_directory"
#     "platform_ui_package templates/platform_ui_package lib/src/project/platform_ui_package"
#     "project templates/project lib/src/project"
#     "service_implementation templates/service_implementation lib/src/project/infrastructure_dir/infrastructure_package"
#     "service_interface templates/service_interface lib/src/project/domain_dir/domain_package"
#     "ui_package templates/ui_package lib/src/project/ui_package"
#     "value_object templates/value_object lib/src/project/domain_dir/domain_package"
#     "widget templates/widget lib/src/project/platform_ui_package"
# )

# for template in "${templates[@]}"; do
#     template_name=$(echo "$template" | cut -d ' ' -f 1)
#     template_location=$(echo "$template" | cut -d ' ' -f 2)
#     destination_dir=$(echo "$template" | cut -d ' ' -f 3)

#     echo "Rebundling template $template_name..."
#     mason bundle "$template_location" -t dart
#     mv "${template_name}_bundle.dart" "$destination_dir"
# done

# dart format lib --fix

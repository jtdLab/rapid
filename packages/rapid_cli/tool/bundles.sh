#!/bin/bash

# Run from packages/rapid_cli
# sh tool/bundles.sh
# sh tool/bundles.sh --dry-run to see which templates dependencies can be updated.

function create_dart_project() {
    local project_name="${1:?Please provide the project name as the first argument}"
    local project_path="${2:?Please provide the project path as the second argument}"

    # Save the current directory
    local oldpwd="$(pwd)"

    # Create project directory and cd into it
    mkdir -p "${project_path}/${project_name}"
    cd "${project_path}/${project_name}" || return 1

    # Create pubspec.yaml file
    cat <<EOF >pubspec.yaml
name: ${project_name}
description: A minimal Dart project
version: 0.1.0
EOF

    # Success message
    echo "Created '${project_name}' at ${project_path}/${project_name}"

    # Return to the original directory
    cd "$oldpwd" || return 1
}

platforms=("android" "ios" "linux" "macos" "web" "windows")
project_name="xxxxx_project_xxxxx"

for platform in "${platforms[@]}"; do
    create_dart_project "${project_name}_ui_${platform}" "tmp/packages/${project_name}_ui"
    create_dart_project "${project_name}_${platform}" "tmp/packages/${project_name}/${project_name}_${platform}"
    create_dart_project "${project_name}_${platform}_navigation" "tmp/packages/${project_name}/${project_name}_${platform}"
    create_dart_project "${project_name}_${platform}_app" "tmp/packages/${project_name}/${project_name}_${platform}/${project_name}_${platform}_features"
    create_dart_project "${project_name}_${platform}_home_page" "tmp/packages/${project_name}/${project_name}_${platform}/${project_name}_${platform}_features"
done

create_dart_project "${project_name}_di" "tmp/packages/${project_name}"
create_dart_project "${project_name}_domain" "tmp/packages/${project_name}/${project_name}_domain"
create_dart_project "${project_name}_infrastructure" "tmp/packages/${project_name}/${project_name}_infrastructure"
create_dart_project "${project_name}_logging" "tmp/packages/${project_name}"
create_dart_project "${project_name}_ui" "tmp/packages/${project_name}_ui"

cat <<EOF >tmp/melos.yaml
name: ${project_name}_workspace

packages:
  - packages/*
EOF

echo "Created melos.yaml file."

exit 0

# Updates templates dependencies to specified versions and rebundles them.

# SDK versions
declare -a sdks=(
    "sdk=>=2.19.6 <3.0.0"
    "flutter=>=3.7.10"
)

# Other package versions
declare -a packages=(
    "auto_route=^6.1.0"
    "auto_route_generator=^6.1.0"
    "bloc_concurrency=^0.2.1"
    "bloc_test=^9.1.1"
    "bloc=^8.1.1"
    "build_runner=^2.3.3"
    "cupertino_icons=^1.0.5"
    "dartz=^0.10.1"
    "faker=^2.1.0"
    "fluent_ui=^4.4.2"
    "flutter_bloc=^8.1.2"
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
    "melos=^3.0.1"
    "meta=^1.8.0"
    "mocktail=^0.3.0"
    "test=^1.24.1"
    "theme_tailor_annotation=^1.1.1"
    "theme_tailor=^1.1.2"
    "url_strategy=^0.2.0"
    "yaru_icons=^1.0.4"
    "yaru=^0.6.2"
)

echo "Packages with available updates:"
for package in "${packages[@]}"; do
    PACKAGE_NAME="${package%=*}"
    CURRENT_VERSION="${package#*=}"
    LATEST_VERSION=$(curl -s "https://pub.dev/api/packages/$PACKAGE_NAME" | grep -oE '"latest":{"version":"[^"]+' | sed 's/.*:"//')

    if [[ "^$LATEST_VERSION" != "$CURRENT_VERSION" ]]; then
        echo "$PACKAGE_NAME: $CURRENT_VERSION -> $LATEST_VERSION"
    fi
done

if [[ "$1" == "--dry-run" ]]; then
    exit 0
fi

declare -a packageTemplatePaths=(
    "templates/project"
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
        sed -i '' -E "s/^([[:blank:]]*{[[:blank:]]*{[[:blank:]]*#[[:blank:]]*[a-z_]+[[:blank:]]*}[[:blank:]]*}|[[:blank:]]*)$name:[[:blank:]]*\^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+(.*)$/\1$name: $version\2/" "$pubspec_path"
    done
done

# TODO Regenerate pubspec.lock and dependency_overrides.yaml in every package

function create_dart_project() {
    local project_name="${1:?Please provide the project name as the first argument}"
    local project_path="${2:?Please provide the project path as the second argument}"

    # Create project directory and cd into it
    mkdir -p "${project_path}/${project_name}"
    cd "${project_path}/${project_name}" || return 1

    # Create pubspec.yaml file
    cat <<EOF >pubspec.yaml
name: ${project_name}
description: A minimal Dart project
version: 0.1.0
EOF

    # Success message
    echo "Created minimal Dart project '${project_name}' at ${project_path}/${project_name}"
}

create_dart_project mimi tmp/mimi
create_dart_project fofo tmp/fofo

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

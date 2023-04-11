#!/bin/bash

# Run from packages/rapid_cli
# sh tool/bundles.sh
# sh tool/bundles.sh --dry-run to see which templates dependencies can be updated.

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

# bis hier NICE

# TODO Regenerate pubspec.lock and dependency_overrides.yaml in every package

# function create_dart_project() {
#     local project_name="${1:?Please provide the project name as the first argument}"
#     local project_path="${2:?Please provide the project path as the second argument}"

#     # Save the current directory
#     local oldpwd="$(pwd)"

#     # Create project directory and cd into it
#     mkdir -p "${project_path}/${project_name}"
#     cd "${project_path}/${project_name}" || return 1

#     # Create pubspec.yaml file
#     cat <<EOF >pubspec.yaml
# name: ${project_name}
# description: A minimal Dart project
# version: 0.1.0

# environment:
#   sdk: ">=2.19.6 <3.0.0"
# EOF

#     # Success message
#     echo "Created '${project_name}' at ${project_path}/${project_name}"

#     # Return to the original directory
#     cd "$oldpwd" || return 1
# }

# platforms=("android" "ios" "linux" "macos" "web" "windows")

# project_name="xxxxx_project_xxxxx"

# for platform in "${platforms[@]}"; do
#     mason make "templates/platform_ui_package" -c {project_name: $project_name}
#     create_dart_project "${project_name}_ui_${platform}" "tmp/packages/${project_name}_ui"
#     create_dart_project "${project_name}_${platform}" "tmp/packages/${project_name}/${project_name}_${platform}"
#     create_dart_project "${project_name}_${platform}_navigation" "tmp/packages/${project_name}/${project_name}_${platform}"
#     create_dart_project "${project_name}_${platform}_app" "tmp/packages/${project_name}/${project_name}_${platform}/${project_name}_${platform}_features"
#     create_dart_project "${project_name}_${platform}_home_page" "tmp/packages/${project_name}/${project_name}_${platform}/${project_name}_${platform}_features"
# done

# create_dart_project "${project_name}_di" "tmp/packages/${project_name}"
# create_dart_project "${project_name}_domain" "tmp/packages/${project_name}/${project_name}_domain"
# create_dart_project "${project_name}_infrastructure" "tmp/packages/${project_name}/${project_name}_infrastructure"
# create_dart_project "${project_name}_logging" "tmp/packages/${project_name}"
# create_dart_project "${project_name}_ui" "tmp/packages/${project_name}_ui"

# melos bs

# (name, location, destination)
templates=(
    "arb_file templates/arb_file lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "bloc templates/bloc lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "cubit templates/cubit lib/src/project/platform_directory/platform_features_directory/platform_feature_package"
    "data_transfer_object templates/data_transfer_object lib/src/project/infrastructure_dir/infrastructure_package"
    "di_package templates/di_package lib/src/project/di_package"
    "domain_package templates/domain_package lib/src/project/domain_dir/domain_package"
    "entity templates/entity lib/src/project/domain_dir/domain_package"
    "infrastructure_package templates/infrastructure_package lib/src/project/infrastructure_dir/infrastructure_package"
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
    "service_implementation templates/service_implementation lib/src/project/infrastructure_dir/infrastructure_package"
    "service_interface templates/service_interface lib/src/project/domain_dir/domain_package"
    "ui_package templates/ui_package lib/src/project/ui_package"
    "value_object templates/value_object lib/src/project/domain_dir/domain_package"
    "widget templates/widget lib/src/project/platform_ui_package"
)

# Generate dummy project to regenerat pubspec.lock and pubspec_overrides.yaml

# # TODO: Is this required all time?
# cd templates
# for template in "${templates[@]}"; do
#     template_name=$(echo "$template" | cut -d ' ' -f 1)
#     template_location=$(echo "$template" | cut -d ' ' -f 2 | sed 's#templates/##')

#     echo "Adding template $template_name..."
#     mason add $template_name --path $template_location
# done
# cd ..

project_name="xxxxx_project_xxxxx"

platform_ui_package_android_path="tmp/packages/${project_name}_ui/${project_name}_ui_android"
platform_ui_package_ios_path="tmp/packages/${project_name}_ui/${project_name}_ui_ios"
platform_ui_package_linux_path="tmp/packages/${project_name}_ui/${project_name}_ui_linux"
platform_ui_package_macos_path="tmp/packages/${project_name}_ui/${project_name}_ui_macos"
platform_ui_package_web_path="tmp/packages/${project_name}_ui/${project_name}_ui_web"
platform_ui_package_windows_path="tmp/packages/${project_name}_ui/${project_name}_ui_windows"

platform_root_package_android_path="tmp/packages/${project_name}/${project_name}_android/${project_name}_android"
platform_root_package_ios_path="tmp/packages/${project_name}/${project_name}_ios/${project_name}_ios"
platform_root_package_linux_path="tmp/packages/${project_name}/${project_name}_linux/${project_name}_linux"
platform_root_package_macos_path="tmp/packages/${project_name}/${project_name}_macos/${project_name}_macos"
platform_root_package_web_path="tmp/packages/${project_name}/${project_name}_web/${project_name}_web"
platform_root_package_windows_path="tmp/packages/${project_name}/${project_name}_windows/${project_name}_windows"

platform_navigation_package_android_path="tmp/packages/${project_name}/${project_name}_android/${project_name}_navigation"
platform_navigation_package_ios_path="tmp/packages/${project_name}/${project_name}_ios/${project_name}_navigation"
platform_navigation_package_linux_path="tmp/packages/${project_name}/${project_name}_linux/${project_name}_navigation"
platform_navigation_package_macos_path="tmp/packages/${project_name}/${project_name}_macos/${project_name}_navigation"
platform_navigation_package_web_path="tmp/packages/${project_name}/${project_name}_web/${project_name}_navigation"
platform_navigation_package_windows_path="tmp/packages/${project_name}/${project_name}_windows/${project_name}_navigation"

platform_app_feature_package_android_path="tmp/packages/${project_name}/${project_name}_android/${project_name}_android_features/${project_name}_android_app"
platform_app_feature_package_ios_path="tmp/packages/${project_name}/${project_name}_ios/${project_name}_ios_features/${project_name}_ios_app"
platform_app_feature_package_linux_path="tmp/packages/${project_name}/${project_name}_linux/${project_name}_linux_features/${project_name}_linux_app"
platform_app_feature_package_macos_path="tmp/packages/${project_name}/${project_name}_macos/${project_name}_macos_features/${project_name}_macos_app"
platform_app_feature_package_web_path="tmp/packages/${project_name}/${project_name}_web/${project_name}_web_features/${project_name}_web_app"
platform_app_feature_package_windows_path="tmp/packages/${project_name}/${project_name}_windows/${project_name}_windows_features/${project_name}_windows_app"

platform_home_page_feature_package_android_path="tmp/packages/${project_name}/${project_name}_android/${project_name}_android_features/${project_name}_android_home_page"
platform_home_page_feature_package_ios_path="tmp/packages/${project_name}/${project_name}_ios/${project_name}_ios_features/${project_name}_ios_home_page"
platform_home_page_feature_package_linux_path="tmp/packages/${project_name}/${project_name}_linux/${project_name}_linux_features/${project_name}_linux_home_page"
platform_home_page_feature_package_macos_path="tmp/packages/${project_name}/${project_name}_macos/${project_name}_macos_features/${project_name}_macos_home_page"
platform_home_page_feature_package_web_path="tmp/packages/${project_name}/${project_name}_web/${project_name}_web_features/${project_name}_web_home_page"
platform_home_page_feature_package_windows_path="tmp/packages/${project_name}/${project_name}_windows/${project_name}_windows_features/${project_name}_windows_home_page"

ui_package_path="tmp/packages/${project_name}_ui/${project_name}_ui"

di_package_path="tmp/packages/${project_name}/${project_name}_di"

logging_package_path="tmp/packages/${project_name}/${project_name}_logging"

domain_package_path="tmp/packages/${project_name}/${project_name}_domain/${project_name}_domain"

infrastructure_package_path="tmp/packages/${project_name}/${project_name}_infrastructure/${project_name}_infrastructure"

outputPaths=(
    "platform_ui_package $platform_ui_package_android_path"
    "platform_ui_package $platform_ui_package_ios_path"
    "platform_ui_package $platform_ui_package_linux_path"
    "platform_ui_package $platform_ui_package_macos_path"
    "platform_ui_package $platform_ui_package_web_path"
    "platform_ui_package $platform_ui_package_windows_path"

    "platform_root_package $platform_root_package_android_path"
    "platform_root_package $platform_root_package_ios_path"
    "platform_root_package $platform_root_package_linux_path"
    "platform_root_package $platform_root_package_macos_path"
    "platform_root_package $platform_root_package_web_path"
    "platform_root_package $platform_root_package_windows_path"

    "platform_navigation_package $platform_navigation_package_android_path"
    "platform_navigation_package $platform_navigation_package_ios_path"
    "platform_navigation_package $platform_navigation_package_linux_path"
    "platform_navigation_package $platform_navigation_package_macos_path"
    "platform_navigation_package $platform_navigation_package_web_path"
    "platform_navigation_package $platform_navigation_package_windows_path"

    "platform_app_feature_package $platform_app_feature_package_android_path"
    "platform_app_feature_package $platform_app_feature_package_ios_path"
    "platform_app_feature_package $platform_app_feature_package_linux_path"
    "platform_app_feature_package $platform_app_feature_package_macos_path"
    "platform_app_feature_package $platform_app_feature_package_web_path"
    "platform_app_feature_package $platform_app_feature_package_windows_path"

    "platform_home_page_feature_package $platform_home_page_feature_package_android_path"
    "platform_home_page_feature_package $platform_home_page_feature_package_ios_path"
    "platform_home_page_feature_package $platform_home_page_feature_package_linux_path"
    "platform_home_page_feature_package $platform_home_page_feature_package_macos_path"
    "platform_home_page_feature_package $platform_home_page_feature_package_web_path"
    "platform_home_page_feature_package $platform_home_page_feature_package_windows_path"

    "ui_package $ui_package_path"

    "di_package $di_package_path"

    "logging_package $logging_package_path"

    "domain_package $domain_package_path"

    "infrastructure_package $infrastructure_package_path"
)

cd templates

rm -r tmp

# Platform UI Package
mason make "platform_ui_package" --on-conflict append -o $platform_ui_package_android_path --project_name $project_name --example false --android true --ios false --linux false --macos false --web false --windows false
mason make "platform_ui_package" --on-conflict append -o $platform_ui_package_ios_path --project_name $project_name --example false --android false --ios true --linux false --macos false --web false --windows false
mason make "platform_ui_package" --on-conflict append -o $platform_ui_package_linux_path --project_name $project_name --example false --android false --ios false --linux true --macos false --web false --windows false
mason make "platform_ui_package" --on-conflict append -o $platform_ui_package_macos_path --project_name $project_name --example false --android false --ios false --linux false --macos true --web false --windows false
mason make "platform_ui_package" --on-conflict append -o $platform_ui_package_web_path --project_name $project_name --example false --android false --ios false --linux false --macos false --web true --windows false
mason make "platform_ui_package" --on-conflict append -o $platform_ui_package_windows_path --project_name $project_name --example false --android false --ios false --linux false --macos false --web false --windows true

# Platform Root Package
mason make "platform_root_package" --on-conflict append -o $platform_root_package_android_path --project_name $project_name --description swag --android true --ios false --linux false --macos false --web false --windows false
mason make "platform_root_package" --on-conflict append -o $platform_root_package_ios_path --project_name $project_name --description swag --android false --ios true --linux false --macos false --web false --windows false
mason make "platform_root_package" --on-conflict append -o $platform_root_package_linux_path --project_name $project_name --description swag --android false --ios false --linux true --macos false --web false --windows false
mason make "platform_root_package" --on-conflict append -o $platform_root_package_macos_path --project_name $project_name --description swag --android false --ios false --linux false --macos true --web false --windows false
mason make "platform_root_package" --on-conflict append -o $platform_root_package_web_path --project_name $project_name --description swag --android false --ios false --linux false --macos false --web true --windows false
mason make "platform_root_package" --on-conflict append -o $platform_root_package_windows_path --project_name $project_name --description swag --android false --ios false --linux false --macos false --web false --windows true

# Platform Navigation Package
mason make "platform_navigation_package" --on-conflict append -o $platform_navigation_package_android_path --project_name $project_name --android true --ios false --linux false --macos false --web false --windows false
mason make "platform_navigation_package" --on-conflict append -o $platform_navigation_package_ios_path --project_name $project_name --android false --ios true --linux false --macos false --web false --windows false
mason make "platform_navigation_package" --on-conflict append -o $platform_navigation_package_linux_path --project_name $project_name --android false --ios false --linux true --macos false --web false --windows false
mason make "platform_navigation_package" --on-conflict append -o $platform_navigation_package_macos_path --project_name $project_name --android false --ios false --linux false --macos true --web false --windows false
mason make "platform_navigation_package" --on-conflict append -o $platform_navigation_package_web_path --project_name $project_name --android false --ios false --linux false --macos false --web true --windows false
mason make "platform_navigation_package" --on-conflict append -o $platform_navigation_package_windows_path --project_name $project_name --android false --ios false --linux false --macos false --web false --windows true

# Platform App Feature Package
mason make "platform_app_feature_package" --on-conflict append -o $platform_app_feature_package_android_path --project_name $project_name --example false --android true --ios false --linux false --macos false --web false --windows false --default_language de
mason make "platform_app_feature_package" --on-conflict append -o $platform_app_feature_package_ios_path --project_name $project_name --example false --android false --ios true --linux false --macos false --web false --windows false --default_language de
mason make "platform_app_feature_package" --on-conflict append -o $platform_app_feature_package_linux_path --project_name $project_name --example false --android false --ios false --linux true --macos false --web false --windows false --default_language de
mason make "platform_app_feature_package" --on-conflict append -o $platform_app_feature_package_macos_path --project_name $project_name --example false --android false --ios false --linux false --macos true --web false --windows false --default_language de
mason make "platform_app_feature_package" --on-conflict append -o $platform_app_feature_package_web_path --project_name $project_name --example false --android false --ios false --linux false --macos false --web true --windows false --default_language de
mason make "platform_app_feature_package" --on-conflict append -o $platform_app_feature_package_windows_path --project_name $project_name --example false --android false --ios false --linux false --macos false --web false --windows true --default_language de

# Platform Home Page Feature Package
mason make "platform_feature_package" --on-conflict append -o $platform_home_page_feature_package_android_path --name home_page --description swag --project_name $project_name --example false --android true --ios false --linux false --macos false --web false --windows false --default_language de --routable false --route_name none
mason make "platform_feature_package" --on-conflict append -o $platform_home_page_feature_package_ios_path --name home_page --description swag --project_name $project_name --example false --android false --ios true --linux false --macos false --web false --windows false --default_language de --routable false --route_name none
mason make "platform_feature_package" --on-conflict append -o $platform_home_page_feature_package_linux_path --name home_page --description swag --project_name $project_name --example false --android false --ios false --linux true --macos false --web false --windows false --default_language de --routable false --route_name none
mason make "platform_feature_package" --on-conflict append -o $platform_home_page_feature_package_macos_path --name home_page --description swag --project_name $project_name --example false --android false --ios false --linux false --macos true --web false --windows false --default_language de --routable false --route_name none
mason make "platform_feature_package" --on-conflict append -o $platform_home_page_feature_package_web_path --name home_page --description swag --project_name $project_name --example false --android false --ios false --linux false --macos false --web true --windows false --default_language de --routable false --route_name none
mason make "platform_feature_package" --on-conflict append -o $platform_home_page_feature_package_windows_path --name home_page --description swag --project_name $project_name --example false --android false --ios false --linux false --macos false --web false --windows true --default_language de --routable false --route_name none

# UI Package
mason make "ui_package" --on-conflict append -o $ui_package_path --project_name $project_name

# DI Package
mason make "di_package" --on-conflict append -o $di_package_path --project_name $project_name

# Logging Package
mason make "logging_package" --on-conflict append -o $logging_package_path --project_name $project_name

# Domain Package
mason make "domain_package" --on-conflict append -o $domain_package_path --project_name $project_name --has_name false --name ""

# Infrastructure Package
mason make "infrastructure_package" --on-conflict append -o $infrastructure_package_path --project_name $project_name --has_name false --name ""

melos bs

# Templatify pubspec.locks and pubspec_overrides.yamls
for path in "${outputPaths[@]}"; do
    template_name=$(echo "$path" | cut -d ' ' -f 1)
    template_path=$(echo "$path" | cut -d ' ' -f 2)
    brick_path="$template_name/__brick__"
    pubspecPath="$template_path/pubspec.lock"
    dependency_overrides_path="$template_path/pubspec_overrides.yaml"

    # Replace project_name in pubspec.lock
    sed -i "s/${project_name}/{{project_name}}/g" "$pubspecPath"

    # Replace project_name in pubspec_overrides.yaml
    sed -i "s/${project_name}/{{project_name}}/g" "$dependency_overrides_path"

    cp $pubspecPath $brick_path/pubspec.lock
    cp $dependency_overrides_path $brick_path/pubspec_overrides.yaml
done

cd ..

# Rebundles all mason templates and ships the fresh bundles to rapid_cli package.

for template in "${templates[@]}"; do
    template_name=$(echo "$template" | cut -d ' ' -f 1)
    template_location=$(echo "$template" | cut -d ' ' -f 2)
    destination_dir=$(echo "$template" | cut -d ' ' -f 3)

    echo "Rebundling template $template_name..."
    mason bundle "$template_location" -t dart
    mv "${template_name}_bundle.dart" "$destination_dir"
done

dart format lib --fix

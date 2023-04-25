#!/bin/bash

############################################################################################
# Run from packages/rapid_cli
# sh tool/fixtures.sh
############################################################################################
# Generates fresh fixtures projects used for e2e testing.
############################################################################################

cd templates

mason list
mason make "entity" --on-conflict overwrite -o ../test/e2e/fixtures/entity --project_name project_none --name FooBar --output_dir "." --output_dir_is_cwd true --has_subdomain_name false --subdomain_name "" 
mason make "service_interface" --on-conflict overwrite -o ../test/e2e/fixtures/service_interface --project_name $project_name project_none --name FooBar --output_dir "."

cd ..

cd test/e2e/fixtures

echo "Generating fixture project without a platform activated..."
rapid create project_none -o project_none

platforms=(android ios linux macos web windows)

for platform in "${platforms[@]}"; do
    echo "Generating fixture projects with $platform activated..."
    rapid create project_$platform -o project_$platform --$platform
done

flutter analyze .
dart format . --set-exit-if-changed

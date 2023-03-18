#!/bin/bash

# Run from packages/rapid_cli
# sh tool/regenerate_fixtures.sh 

# Rebundles all mason templates and updates them in rapid_cli package.
cd test/templates

echo "Rebundling arb_file template ..."
cd arb_file
mason bundle . -t dart
mv arb_file_bundle.dart packages/rapid_cli/lib/src/project/platform_directory/platform_features_directory/platform_feature_package/arb_file_bundle.dart


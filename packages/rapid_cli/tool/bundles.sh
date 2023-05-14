#!/bin/bash

# TODO format pubspec.lock and pubspec_overrides.yaml do not contain unnecessary empty lines

############################################################################################
# Run from packages/rapid_cli
# sh tool/bundles.sh
# sh tool/bundles.sh --dry-run (to see which template dependencies have updates available)
############################################################################################
# Upates templates, bundles and them to rapid_cli
############################################################################################

if [[ "$1" == "--dry-run" ]]; then
    dart run tool/bundles/bin/bundles.dart --dry-run
else
    dart run tool/bundles/bin/bundles.dart
fi

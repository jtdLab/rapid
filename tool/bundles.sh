#!/bin/bash

############################################################################################
# Run from root
# bash tool/bundles.sh
# bash tool/bundles.sh --dry-run (to see which template dependencies have updates available)
############################################################################################
# Upates pubspec files and native directories of templates, then bundles the templates
# and adds them to rapid_cli
############################################################################################

if [[ "$1" == "--dry-run" ]]; then
    dart run tool/bundles/bin/bundles.dart --dry-run
else
    dart run tool/bundles/bin/bundles.dart
fi

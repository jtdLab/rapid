#!/bin/bash

############################################################################################
# Run from packages/rapid_cli
# sh tool/fixtures.sh
############################################################################################
# Generates fresh fixtures projects used for e2e testing.
############################################################################################

cd test/e2e/fixtures

echo "Generating fixture project without a platform activated..."
rapid create project_none -o project_none

platforms=(android ios linux macos web windows)

for platform in "${platforms[@]}"; do
    echo "Generating fixture projects with $platform activated..."
    rapid create project_$platform -o project_$platform --$platform
done

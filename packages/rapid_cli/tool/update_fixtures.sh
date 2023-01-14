#!/bin/bash

# Run from packages/rapid_cli

# Generates fresh fixtures projects used for e2e testing.
cd fixtures

echo "Generating fixture project without a platform activated ..."
rm -r project_none
mkdir project_none
cd project_none
rapid create project_none
cd ..

platforms=(android ios linux macos web windows)

for platform in "${platforms[@]}"
do
    echo "Generating fixture projects with $platform activated ..."
    rm -r project_$platform
    mkdir project_$platform
    cd project_$platform
    rapid create project_$platform --$platform
    cd ..
done

flutter format . --fix
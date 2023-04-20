#!/bin/bash

############################################################################################
# Run from packages/rapid_cli
# sh tool/e2e_infra.sh
############################################################################################
# Runs fast infrastructure e2e tests
############################################################################################

testFiles=(
    "test/e2e/infrastructure_add_data_transfer_object_test.dart"
    "test/e2e/infrastructure_add_service_implementation_test.dart"
    "test/e2e/infrastructure_remove_data_transfer_object_test.dart"
    "test/e2e/infrastructure_remove_service_implementation_test.dart"
)

for testFile in "${testFiles[@]}"; do
    flutter test $testFile --run-skipped -t e2e
done

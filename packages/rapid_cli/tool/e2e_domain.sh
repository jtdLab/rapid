#!/bin/bash

############################################################################################
# Run from packages/rapid_cli
# sh tool/e2e_domain.sh
############################################################################################
# Runs fast domain e2e tests
############################################################################################

testFiles=(
    "test/e2e/domain_add_entity_test.dart"
    "test/e2e/domain_add_service_interface_test.dart"
    "test/e2e/domain_add_value_object_test.dart"
    "test/e2e/domain_remove_entity_test.dart"
    "test/e2e/domain_remove_service_interface_test.dart"
    "test/e2e/domain_remove_value_object_test.dart"
)

for testFile in "${testFiles[@]}"; do
    flutter test $testFile --run-skipped -t e2e
done

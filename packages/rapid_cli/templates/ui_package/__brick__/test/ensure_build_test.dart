import 'package:build_verify/build_verify.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'ensure_build',
    () async => expectBuildClean(
      packageRelativeDirectory:
          'packages/{{project_name}}_ui/{{project_name}}_ui',
    ),
    timeout: const Timeout.factor(4),
    tags: ['build_verify'],
  );
}

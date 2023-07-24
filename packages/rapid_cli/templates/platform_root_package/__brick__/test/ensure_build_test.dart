import 'package:build_verify/build_verify.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'ensure_build',
    () async => expectBuildClean(
      packageRelativeDirectory:
          'packages/{{project_name}}/{{project_name}}_{{platform}}/{{project_name}}_{{platform}}',
    ),
    timeout: const Timeout.factor(4),
    tags: ['build_verify'],
  );
}

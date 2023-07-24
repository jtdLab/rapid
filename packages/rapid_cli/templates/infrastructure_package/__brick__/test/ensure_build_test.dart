import 'package:build_verify/build_verify.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ensure_build',
    () async => expectBuildClean(
      packageRelativeDirectory:
          'packages/{{project_name}}/{{project_name}}_infrastructure/{{project_name}}_infrastructure',
    ),
    timeout: const Timeout.factor(4),
    tags: ['build_verify'],
  );
}

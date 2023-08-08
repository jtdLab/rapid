import 'package:mason/mason.dart';
import 'package:meta/meta.dart';

import 'io/io.dart';

export 'package:mason/mason.dart' hide Logger, Progress;

@visibleForTesting
// ignore: public_member_api_docs
Future<MasonGenerator> Function(MasonBundle)? generatorOverrides;

/// Generates files specified in [bundle] based on the provided
/// [target] and [vars].
///
/// Returns the generated files.
Future<List<GeneratedFile>> generate({
  required MasonBundle bundle,
  required Directory target,
  Map<String, dynamic> vars = const <String, dynamic>{},
}) async {
  final generator =
      await (generatorOverrides ?? MasonGenerator.fromBundle)(bundle);
  return generator.generate(
    DirectoryGeneratorTarget(target),
    vars: vars,
  );
}

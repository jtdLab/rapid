import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/io.dart';

export 'package:mason/mason.dart' hide Logger, Progress;

@visibleForTesting
Future<MasonGenerator> Function(MasonBundle)? generatorOverrides;

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

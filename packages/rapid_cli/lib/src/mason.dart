import 'dart:io';

import 'package:mason/mason.dart';
import 'package:meta/meta.dart';

export 'package:mason/mason.dart';

@visibleForTesting
Future<MasonGenerator> Function(MasonBundle)? generatorOverrides;

Future<List<GeneratedFile>> generate({
  required MasonBundle bundle,
  required Directory target,
  Map<String, dynamic> vars = const <String, dynamic>{},
}) async {
  final generator =
      await (generatorOverrides ?? MasonGenerator.fromBundle)(bundle);
  await generator.hooks.preGen(
    vars: vars,
    onVarsChanged: (newVars) => vars = newVars,
  );
  final files = await generator.generate(
    DirectoryGeneratorTarget(target),
    vars: vars,
  );
  await generator.hooks.postGen(
    workingDirectory: target.path,
    vars: vars,
  );

  return files;
}

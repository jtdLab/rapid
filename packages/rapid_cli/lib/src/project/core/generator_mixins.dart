import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';

mixin OverridableGenerator {
  @visibleForTesting
  GeneratorBuilder? generatorOverrides;

  @protected
  GeneratorBuilder get generator =>
      generatorOverrides ?? MasonGenerator.fromBundle;
}

mixin Generatable on Directory, OverridableGenerator {
  @protected
  Future<void> generate({
    required MasonBundle bundle,
    required Map<String, dynamic> vars,
    required String name,
    required Logger logger,
  }) async {
    final progress = logger.progress('Generating $name files ...');
    final generator = await this.generator(bundle);
    final files = await generator.generate(
      DirectoryGeneratorTarget(io.Directory(path)),
      vars: vars,
      logger: logger,
    );
    for (final file in files) {
      logger.detail(file.path);
    }
    progress.complete('Generated $name files.');
  }
}

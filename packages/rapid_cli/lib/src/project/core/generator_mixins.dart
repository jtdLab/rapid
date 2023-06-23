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
  }) async {
    final generator = await this.generator(bundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(path)),
      vars: vars,
    );
  }
}

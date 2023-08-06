import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import '../base.dart';
import 'validate_dart_package_name.dart';

/// Adds `dartPackageName` getter.
mixin DartPackageNameGetter on RapidLeafCommand {
  /// Returns the dart package name specified as the first positional argument.
  @protected
  String get dartPackageName => _validateDartPackageNameArg(argResults.rest);

  String _validateDartPackageNameArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the name.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple names specified.', usage);
    }

    final name = args.first;
    final isValid = isValidPackageName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid dart package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }

    return name;
  }
}

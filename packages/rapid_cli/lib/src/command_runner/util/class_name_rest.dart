import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import '../base.dart';
import 'validate_class_name.dart';

/// Adds `className` getter.
mixin ClassNameGetter on RapidLeafCommand {
  /// Returns the class name specified as the first positional argument.
  @protected
  String get className => _validateClassNameArg(argResults.rest);

  String _validateClassNameArg(List<String> args) {
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
    final isValid = isValidClassName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid dart class name.',
        usage,
      );
    }

    return name;
  }
}

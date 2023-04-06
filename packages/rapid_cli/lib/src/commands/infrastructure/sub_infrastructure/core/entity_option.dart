import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/validate_class_name.dart';

/// Adds entity option.
extension EntityOption on ArgParser {
  /// Adds `--entity`, `--e` option.
  void addEntityOption() {
    addOption(
      'entity',
      help: 'The name of the entity the data transfer object is related to.',
      abbr: 'e',
    );
  }
}

/// Adds `entity` getter.
mixin EntityGetter on OverridableArgResults {
  /// Gets `entity` from [ArgResults].
  ///
  /// Throws [UsageException] when invalid entity name.
  @protected
  String get entity => _validateEntity(argResults['entity']);

  /// Validates whether `entity` is a valid entity name.
  ///
  /// Returns `entity` when valid.
  String _validateEntity(String? entity) {
    if (entity == null) {
      throw UsageException(
        'No option specified for the entity.',
        usage,
      );
    }

    final isValid = isValidClassName(entity);
    if (!isValid) {
      throw UsageException(
        '"$entity" is not a valid dart class name.',
        usage,
      );
    }

    return entity;
  }
}

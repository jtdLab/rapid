import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import '../base.dart';
import 'validate_class_name.dart';

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
mixin EntityGetter on RapidLeafCommand {
  /// Returns the entity specified by the user.
  @protected
  String get entity => _validateEntity(argResults['entity'] as String?);

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

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/validate_class_name.dart';

/// Adds service option.
extension ServiceOption on ArgParser {
  /// Adds `--service`, `--s` option.
  void addServiceOption() {
    addOption(
      'service',
      help:
          'The name of the service interface the service implementation is related to.',
      abbr: 's',
    );
  }
}

/// Adds `service` getter.
mixin ServiceGetter on OverridableArgResults {
  /// Gets `service` from [ArgResults].
  ///
  /// Throws [UsageException] when invalid service interface name.
  @protected
  String get service => _validateService(argResults['service']);

  /// Validates whether `service` is a valid service interface name.
  ///
  /// Returns `service` when valid.
  String _validateService(String? service) {
    if (service == null) {
      throw UsageException(
        'No option specified for the service.',
        usage,
      );
    }

    final isValid = isValidClassName(service);
    if (!isValid) {
      throw UsageException(
        '"$service" is not a valid dart class name.',
        usage,
      );
    }

    return service;
  }
}

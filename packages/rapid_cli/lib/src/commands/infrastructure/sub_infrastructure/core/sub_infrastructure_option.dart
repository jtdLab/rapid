import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';

/// Adds subInfrastructure option.
extension SubInfrastructureOption on ArgParser {
  /// Adds `--sub-infrastructure` option.
  void addSubInfrastructureOption({required String help}) {
    addOption(
      'sub-infrastructure',
      help: help,
    );
  }
}

/// Adds `subInfrastructure` getter.
mixin SubInfrastructureGetter on OverridableArgResults {
  /// Gets `subInfrastructure` from [ArgResults].
  ///
  /// Throws [UsageException] when invalid subinfrastructure name.
  @protected
  String? get subInfrastructure =>
      _validateSubInfrastructure(argResults['sub-infrastructure']);

  /// Validates whether `subInfrastructure` is a valid subinfrastructure name.
  ///
  /// Returns `subInfrastructure` when valid.
  String? _validateSubInfrastructure(String? subInfrastructure) {
    if (subInfrastructure == null) {
      // TODO can be null?
      return null;
/*       throw UsageException(
        'No option specified for the subinfrastructure.',
        usage,
      ); */
    }

    final isValid = isValidPackageName(subInfrastructure);
    if (!isValid) {
      throw UsageException(
        '"$subInfrastructure" is not a valid dart package name.',
        usage,
      );
    }

    return subInfrastructure;
  }
}

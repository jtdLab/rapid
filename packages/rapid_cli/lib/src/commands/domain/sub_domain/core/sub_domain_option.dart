import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';

/// Adds subDomain option.
extension SubDomainOption on ArgParser {
  /// Adds `--sub-domain`, `--s` option.
  void addSubDomainOption({required String help}) {
    addOption(
      'sub-domain',
      help: help,
      abbr: 's',
    );
  }
}

/// Adds `subDomain` getter.
mixin SubDomainGetter on OverridableArgResults {
  /// Gets `subDomain` from [ArgResults].
  ///
  /// Throws [UsageException] when invalid subdomain name.
  @protected
  String? get subDomain => _validateSubDomain(argResults['sub-domain']);

  /// Validates whether `subDomain` is a valid subdomain name.
  ///
  /// Returns `subDomain` when valid.
  String? _validateSubDomain(String? subDomain) {
    if (subDomain == null) {
      // TODO can be null?
      return null;
/*       throw UsageException(
        'No option specified for the subdomain.',
        usage,
      ); */
    }

    final isValid = isValidPackageName(subDomain);
    if (!isValid) {
      throw UsageException(
        '"$subDomain" is not a valid dart package name.',
        usage,
      );
    }

    return subDomain;
  }
}

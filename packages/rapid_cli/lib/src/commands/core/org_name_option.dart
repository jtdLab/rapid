import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import 'overridable_arg_results.dart';

/// The default organization name.
const _defaultOrgName = 'com.example';

/// The regex for the organization name.
final _orgNameRegExp = RegExp(r'^[a-zA-Z][\w-]*(\.[a-zA-Z][\w-]*)+$');

/// Adds organization name option.
extension OrgNameOption on ArgParser {
  /// Adds `--org-name`, `--org` option.
  void addOrgNameOption({required String help}) {
    addOption(
      'org-name',
      aliases: ['org'],
      help: help,
      defaultsTo: _defaultOrgName,
    );
  }
}

/// Adds `orgName` getter.
mixin OrgNameGetter on OverridableArgResults {
  /// Gets the organization name specified by the user.
  ///
  /// Returns [_defaultOrgName] when no organization name specified.
  @protected
  String get orgName =>
      _validateOrgName(argResults['org-name'] ?? _defaultOrgName);

  /// Validates whether [name] is valid organization name.
  ///
  /// Returns [name] when valid.
  String _validateOrgName(String name) {
    final isValid = _isValidOrgName(name);

    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid org name.\n\n'
        'A valid org name has at least 2 parts separated by "."\n'
        'Each part must start with a letter and only include '
        'alphanumeric characters (A-Z, a-z, 0-9), underscores (_), '
        'and hyphens (-)\n'
        '(ex. com.example)',
        usage,
      );
    }

    return name;
  }

  /// Whether [name] is valid organization name.
  bool _isValidOrgName(String name) => _orgNameRegExp.hasMatch(name);
}

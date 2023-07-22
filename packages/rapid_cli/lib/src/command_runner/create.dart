import 'package:args/command_runner.dart';

import '../project/platform.dart';
import 'base.dart';
import 'util/language_option.dart';
import 'util/org_name_option.dart';
import 'util/output_dir_option.dart';
import 'util/validate_dart_package_name.dart';

/// The default description.
const _defaultDescription = 'A Rapid app.';

/// {@template create_command}
/// `rapid create` command creates a new Rapid project in the specified directory.
/// {@endtemplate}
class CreateCommand extends RapidLeafCommand
    with OutputDirGetter, OrgNameGetter, LanguageGetter {
  /// {@macro create_command}
  CreateCommand() {
    argParser
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The directory where to generate the new project',
      )
      ..addOption(
        'desc',
        help: 'The description of the new project.',
        defaultsTo: _defaultDescription,
      )
      ..addOrgNameOption(
        help: 'The organization of the new project.',
      )
      ..addLanguageOption(
        help: 'The language of the new project',
      )
      ..addSeparator('')
      ..addFlag(
        'android',
        help: 'Wheter the new project supports the Android platform.',
        negatable: false,
      )
      ..addFlag(
        'ios',
        help: 'Wheter the new project supports the iOS platform.',
        negatable: false,
      )
      ..addFlag(
        'linux',
        help: 'Wheter the new project supports the Linux platform.',
        negatable: false,
      )
      ..addFlag(
        'macos',
        help: 'Wheter the new project supports the macOS platform.',
        negatable: false,
      )
      ..addFlag(
        'web',
        help: 'Wheter the new project supports the Web platform.',
        negatable: false,
      )
      ..addFlag(
        'windows',
        help: 'Wheter the new project supports the Windows platform.',
        negatable: false,
      )
      ..addFlag(
        'mobile',
        help: 'Wheter the new project supports the Mobile platform.',
        negatable: false,
      );
  }

  @override
  String get name => 'create';

  @override
  List<String> get aliases => ['c'];

  @override
  String get invocation => 'rapid create <project name> [arguments]';

  @override
  String get description => 'Create a new Rapid project.';

  @override
  Future<void> run() {
    final projectName = _validateProjectNameArg(argResults.rest);
    final outputDir = super.outputDir;
    final description = argResults['desc'] ?? _defaultDescription;
    final orgName = super.orgName;
    final language = super.language;
    final android = argResults['android'] ?? false;
    final ios = argResults['ios'] ?? false;
    final linux = argResults['linux'] ?? false;
    final macos = argResults['macos'] ?? false;
    final web = argResults['web'] ?? false;
    final windows = argResults['windows'] ?? false;
    final mobile = argResults['mobile'] ?? false;

    return rapid.create(
        projectName: projectName,
        outputDir: outputDir,
        description: description,
        orgName: orgName,
        language: language,
        platforms: {
          if (android) Platform.android,
          if (ios) Platform.ios,
          if (linux) Platform.linux,
          if (macos) Platform.macos,
          if (web) Platform.web,
          if (windows) Platform.windows,
          if (mobile) Platform.mobile,
        });
  }

  /// Validates whether [args] contains ONLY a valid project name.
  ///
  /// Returns the first element when valid.
  String _validateProjectNameArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the project name.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple project names specified.', usage);
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

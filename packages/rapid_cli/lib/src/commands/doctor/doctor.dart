import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO better word than healthiness pls

/// {@template rapid_doctor}
/// `rapid doctor language` command shows information about the healthiness of an existing Rapid project.
/// {@endtemplate}
class DoctorCommand extends Command<int> with OverridableArgResults {
  /// {@macro rapid_doctor}
  DoctorCommand({
    Logger? logger,
    Project? project,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project() {
    argParser
      ..addSeparator('')
      ..addFlag(
        'language',
        help:
            'Wheter to show information about the projects language healthiness',
        negatable: false,
      );
  }

  final Logger _logger;
  final Project _project;

  @override
  String get name => 'doctor';

  @override
  String get description =>
      'Shows information about the healthiness of an existing Rapid project';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final language = _language;
        if (language) {
          // TODO impl
          // read supported languages from all platfroms and features
          // then check if each platforms feature support the same language
          // if yes feedback to the user there is no problem
          // else give an descriptive overview which featurs on what platform
          // are missing a language
        }

        return ExitCode.success.code;
      });

  bool get _language => argResults['language'] ?? false;
}

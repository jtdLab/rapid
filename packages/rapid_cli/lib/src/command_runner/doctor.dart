import 'base.dart';

/// {@template rapid_doctor}
/// `rapid doctor` command shows information about an existing Rapid project.
/// {@endtemplate}
class DoctorCommand extends RapidLeafCommand {
  /// {@macro rapid_doctor}
  DoctorCommand(super.project);

  @override
  String get name => 'doctor';

  @override
  String get invocation => 'rapid doctor';

  @override
  String get description => 'Show information about an existing Rapid project.';

  @override
  Future<void> run() {
    return rapid.doctor();
  }
}

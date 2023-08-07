import '../../../utils.dart';
import '../../base.dart';
import 'add/widget.dart';

/// {@template ui_platform_add_command}
/// `rapid ui <platform> add` add a component to the platform UI part of a Rapid project.
/// {@endtemplate}
class UiPlatformAddCommand extends RapidPlatformBranchCommand {
  /// {@macro ui_platform_add_command}
  UiPlatformAddCommand(super.project, {required super.platform}) {
    addSubcommand(UiPlatformAddWidgetCommand(project, platform: platform));
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid ui ${platform.name} add <component>';

  @override
  String get description =>
      'Add a component to the ${platform.prettyName} UI part of a Rapid project.';
}

import '../../../project/platform.dart';
import '../../../utils.dart';
import '../../base.dart';
import 'add/widget.dart';

/// {@template ui_platform_add_command}
/// `rapid ui <platform> add` add a component to the platform UI part of a Rapid project.
/// {@endtemplate}
class UiPlatformAddCommand extends RapidBranchCommand {
  /// {@macro ui_platform_add_command}
  UiPlatformAddCommand(this.platform, super.project) {
    addSubcommand(UiPlatformAddWidgetCommand(platform, super.project));
  }

  final Platform platform;

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid ui ${platform.name} add <component>';

  @override
  String get description =>
      'Add a component to the ${platform.prettyName} UI part of a Rapid project.';
}

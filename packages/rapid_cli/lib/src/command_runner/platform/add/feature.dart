import '../../../project/platform.dart';
import '../../../utils.dart';
import '../../base.dart';
import 'feature/flow.dart';
import 'feature/page.dart';
import 'feature/tab_flow.dart';
import 'feature/widget.dart';

/// {@template platform_add_feature_command}
/// `rapid <platform> add feature` add a feature to the platform part of a Rapid project.
/// {@endtemplate}
class PlatformAddFeatureCommand extends RapidBranchCommand {
  /// {@macro platform_add_feature_command}
  PlatformAddFeatureCommand(this.platform, super.project) {
    addSubcommand(PlatformAddFeatureFlowCommand(platform, project));
    addSubcommand(PlatformAddFeaturePageCommand(platform, project));
    addSubcommand(PlatformAddFeatureTabFlowCommand(platform, project));
    addSubcommand(PlatformAddFeatureWidgetCommand(platform, project));
  }

  final Platform platform;

  @override
  String get name => 'feature';

  @override
  String get invocation => 'rapid ${platform.name} add feature <type>';

  @override
  String get description =>
      'Add a feature to the ${platform.prettyName} part of a Rapid project.';
}

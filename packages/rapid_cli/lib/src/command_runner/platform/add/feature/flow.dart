import 'package:mason/mason.dart';

import '../../../../utils.dart';
import '../../../base.dart';
import '../../../util/dart_package_name_rest.dart';
import '../../../util/description_option.dart';
import '../../../util/navigator_flag.dart';

String _defaultDescription(String name) =>
    'The ${name.pascalCase} tab flow feature.';

/// {@template platform_add_feature_flow_command}
/// `rapid <platform> add feature flow` add a flow feature to the platform part
/// of a Rapid project.
/// {@endtemplate}
class PlatformAddFeatureFlowCommand extends RapidPlatformLeafCommand
    with DartPackageNameGetter, DescriptionGetter, NavigatorGetter {
  /// {@macro platform_add_feature_flow_command}
  PlatformAddFeatureFlowCommand(super.project, {required super.platform}) {
    argParser
      ..addSeparator('')
      ..addDescriptionOption(
        help: 'The description of the new feature.',
      )
      ..addNavigatorFlag();
  }

  @override
  String get name => 'flow';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature flow <name> [arguments]';

  @override
  String get description =>
      'Add a flow feature to the ${platform.prettyName} part of a Rapid '
      'project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;
    final description = super.desc ?? _defaultDescription(name);
    final navigator = super.navigator;

    return rapid.platformAddFeatureFlow(
      platform,
      name: name,
      description: description,
      navigator: navigator,
    );
  }
}

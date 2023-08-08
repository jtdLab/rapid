import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import '../../../../utils.dart';
import '../../../base.dart';
import '../../../util/dart_package_name_rest.dart';
import '../../../util/description_option.dart';
import '../../../util/navigator_flag.dart';

String _defaultDescription(String name) =>
    'The ${name.pascalCase} flow feature.';

/// {@template platform_add_feature_tab_flow_command}
/// `rapid <platform> add feature tab_flow` add a tab flow feature to the
/// platform part of a Rapid project.
/// {@endtemplate}
class PlatformAddFeatureTabFlowCommand extends RapidPlatformLeafCommand
    with DartPackageNameGetter, DescriptionGetter, NavigatorGetter {
  /// {@macro platform_add_feature_tab_flow_command}
  PlatformAddFeatureTabFlowCommand(super.project, {required super.platform}) {
    argParser
      ..addSeparator('')
      ..addOption(
        'sub-features',
        help: 'The features that have this tab flow as a parent.',
      )
      ..addDescriptionOption(
        help: 'The description of the new feature.',
      )
      ..addNavigatorFlag();
  }

  @override
  String get name => 'tab_flow';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature tab_flow <name> [arguments]';

  @override
  String get description =>
      'Add a tab flow feature to the ${platform.prettyName} part of a Rapid '
      'project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;
    final description = super.desc ?? _defaultDescription(name);
    final navigator = super.navigator;

    final subFeatures =
        _validateSubFeatures(argResults['sub-features'] as String?);

    return rapid.platformAddFeatureTabFlow(
      platform,
      name: name,
      description: description,
      navigator: navigator,
      subFeatures: subFeatures,
    );
  }

  Set<String> _validateSubFeatures(String? subFeatures) {
    if (subFeatures == null) {
      throw UsageException(
        'No option specified for the sub-features.',
        usage,
      );
    }

    return subFeatures.split(',').map((e) => e.trim()).toSet();
  }
}

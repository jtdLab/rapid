import 'package:mason/mason.dart';
import 'package:rapid_cli/src/command_runner/util/dart_package_name_rest.dart';
import 'package:rapid_cli/src/command_runner/util/description_option.dart';
import 'package:rapid_cli/src/command_runner/util/navigator_flag.dart';
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../../../base.dart';

String _defaultDescription(String name) =>
    'The ${name.pascalCase} tab flow feature.';

class PlatformAddFeatureFlowCommand extends RapidLeafCommand
    with DartPackageNameGetter, DescriptionGetter, NavigatorGetter {
  PlatformAddFeatureFlowCommand(this.platform, super.project) {
    argParser
      ..addSeparator('')
      ..addDescriptionOption(
        help: 'The description of the new feature.',
      )
      ..addNavigatorFlag();
  }

  final Platform platform;

  @override
  String get name => 'flow';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature flow <name> [arguments]';

  @override
  String get description =>
      'Add a flow feature to the ${platform.prettyName} part of an existing Rapid project.';

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

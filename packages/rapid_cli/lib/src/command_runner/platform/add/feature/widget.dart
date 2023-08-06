import 'package:mason/mason.dart';

import '../../../../project/platform.dart';
import '../../../base.dart';
import '../../../util/dart_package_name_rest.dart';
import '../../../util/description_option.dart';
import '../../../util/platform_x.dart';

// TODO: maybe add a option to specify features that want a dependency before melos bs runs

String _defaultDescription(String name) =>
    'The ${name.pascalCase} widget feature.';

class PlatformAddFeatureWidgetCommand extends RapidLeafCommand
    with DartPackageNameGetter, DescriptionGetter {
  PlatformAddFeatureWidgetCommand(this.platform, super.project) {
    argParser
      ..addSeparator('')
      ..addDescriptionOption(
        help: 'The description of the new feature.',
      );
  }

  final Platform platform;

  @override
  String get name => 'widget';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature widget <name> [arguments]';

  @override
  String get description =>
      'Add a widget feature to the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;
    final description = super.desc ?? _defaultDescription(name);

    return rapid.platformAddFeatureWidget(
      platform,
      name: name,
      description: description,
    );
  }
}

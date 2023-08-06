import 'package:mason/mason.dart';

import '../../../../project/platform.dart';
import '../../../base.dart';
import '../../../util/dart_package_name_rest.dart';
import '../../../util/description_option.dart';
import '../../../util/navigator_flag.dart';
import '../../../util/platform_x.dart';

String _defaultDescription(String name) =>
    'The ${name.pascalCase} page feature.';

class PlatformAddFeaturePageCommand extends RapidLeafCommand
    with DartPackageNameGetter, DescriptionGetter, NavigatorGetter {
  PlatformAddFeaturePageCommand(this.platform, super.project) {
    argParser
      ..addSeparator('')
      ..addDescriptionOption(
        help: 'The description of the new feature.',
      )
      ..addNavigatorFlag();
  }

  final Platform platform;

  @override
  String get name => 'page';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature page <name> [arguments]';

  @override
  String get description =>
      'Add a page feature to the ${platform.prettyName} part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;
    final description = super.desc ?? _defaultDescription(name);
    final navigator = super.navigator;

    return rapid.platformAddFeaturePage(
      platform,
      name: name,
      description: description,
      navigator: navigator,
    );
  }
}

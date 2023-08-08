import 'package:mason/mason.dart';

import '../../../../utils.dart';
import '../../../base.dart';
import '../../../util/dart_package_name_rest.dart';
import '../../../util/description_option.dart';
import '../../../util/navigator_flag.dart';

String _defaultDescription(String name) =>
    'The ${name.pascalCase} page feature.';

/// {@template platform_add_feature_page_command}
/// `rapid <platform> add feature page` add a page feature to the platform part
/// of a Rapid project.
/// {@endtemplate}
class PlatformAddFeaturePageCommand extends RapidPlatformLeafCommand
    with DartPackageNameGetter, DescriptionGetter, NavigatorGetter {
  /// {@macro platform_add_feature_page_command}
  PlatformAddFeaturePageCommand(super.project, {required super.platform}) {
    argParser
      ..addSeparator('')
      ..addDescriptionOption(
        help: 'The description of the new feature.',
      )
      ..addNavigatorFlag();
  }

  @override
  String get name => 'page';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature page <name> [arguments]';

  @override
  String get description =>
      'Add a page feature to the ${platform.prettyName} part of a Rapid '
      'project.';

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

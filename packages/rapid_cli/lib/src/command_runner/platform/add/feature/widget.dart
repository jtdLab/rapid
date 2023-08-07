import 'package:mason/mason.dart';

import '../../../../utils.dart';
import '../../../base.dart';
import '../../../util/dart_package_name_rest.dart';
import '../../../util/description_option.dart';

// TODO(jtdLab): maybe add a option to specify features that want a dependency before melos bs runs

String _defaultDescription(String name) =>
    'The ${name.pascalCase} widget feature.';

/// {@template platform_add_feature_widget_command}
/// `rapid <platform> add feature widget` add a widget feature to the platform part of a Rapid project.
/// {@endtemplate}
class PlatformAddFeatureWidgetCommand extends RapidPlatformLeafCommand
    with DartPackageNameGetter, DescriptionGetter {
  /// {@macro platform_add_feature_widget_command}
  PlatformAddFeatureWidgetCommand(super.project, {required super.platform}) {
    argParser
      ..addSeparator('')
      ..addDescriptionOption(
        help: 'The description of the new feature.',
      );
  }

  @override
  String get name => 'widget';

  @override
  String get invocation =>
      'rapid ${platform.name} add feature widget <name> [arguments]';

  @override
  String get description =>
      'Add a widget feature to the ${platform.prettyName} part of a Rapid project.';

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

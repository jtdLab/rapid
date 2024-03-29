import '../../../utils.dart';
import '../../base.dart';
import '../../util/feature_option.dart';

// TODO(jtdLab): refactor this

/// {@template platform_remove_navigator_command}
/// `rapid <platform> remove navigator` remove a navigator from the platform
/// part of a Rapid project.
/// {@endtemplate}
class PlatformRemoveNavigatorCommand extends RapidPlatformLeafCommand
    with FeatureGetter {
  /// {@macro platform_remove_navigator_command}
  PlatformRemoveNavigatorCommand(super.project, {required super.platform}) {
    argParser
      ..addSeparator('')
      // TODO(jtdLab): add hint that its a dart package nameish string
      // but not the full name of the related package.
      ..addFeatureOption(
        help: 'The name of the feature the navigator is related to.\n'
            'This must be the name of an existing ${platform.prettyName} '
            'feature.',
      );
  }

  @override
  String get name => 'navigator';

  @override
  List<String> get aliases => ['nav'];

  @override
  String get invocation =>
      'rapid ${platform.name} remove navigator [arguments]';

  @override
  String get description =>
      'Remove a navigator from the ${platform.prettyName} part of a Rapid '
      'project.';

  @override
  Future<void> run() {
    final featureName = super.feature;

    return rapid.platformRemoveNavigator(
      platform,
      featureName: featureName,
    );
  }
}

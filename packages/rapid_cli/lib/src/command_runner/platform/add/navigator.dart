import '../../../utils.dart';
import '../../base.dart';
import '../../util/feature_option.dart';

// TODO(jtdLab): refactor this

/// {@template platform_add_navigator_command}
/// `rapid <platform> add navigator` add a navigator to the platform part of a Rapid project.
/// {@endtemplate}
class PlatformAddNavigatorCommand extends RapidPlatformLeafCommand
    with FeatureGetter {
  /// {@macro platform_add_navigator_command}
  PlatformAddNavigatorCommand(super.project, {required super.platform}) {
    argParser
      ..addSeparator('')
      // TODO(jtdLab): add hint that its a dart package nameish string but not the full name of the related package
      ..addFeatureOption(
        help: 'The name of the feature this new navigator is related to.\n'
            'This must be the name of an existing ${platform.prettyName} feature.',
      );
  }

  @override
  String get name => 'navigator';

  @override
  List<String> get aliases => ['nav'];

  @override
  String get invocation => 'rapid ${platform.name} add navigator [arguments]';

  @override
  String get description =>
      'Add a navigator to the ${platform.prettyName} part of a Rapid project.';

  @override
  Future<void> run() {
    final featureName = super.feature;

    return rapid.platformAddNavigator(
      platform,
      featureName: featureName,
    );
  }
}

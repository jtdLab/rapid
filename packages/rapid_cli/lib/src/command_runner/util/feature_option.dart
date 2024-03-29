import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import '../base.dart';
import 'validate_dart_package_name.dart';

/// Adds feature option.
extension FeatureOption on ArgParser {
  /// Adds `--feature`, `--f` option.
  void addFeatureOption({required String help}) {
    addOption(
      'feature',
      help: help,
      abbr: 'f',
    );
  }
}

/// Adds `feature` getter.
mixin FeatureGetter on RapidLeafCommand {
  /// Returns the feature specified by the user.
  @protected
  String get feature => _validateFeature(argResults['feature'] as String?);

  String _validateFeature(String? feature) {
    if (feature == null) {
      throw UsageException(
        'No option specified for the feature.',
        usage,
      );
    }

    final isValid = isValidPackageName(feature);
    if (!isValid) {
      throw UsageException(
        '"$feature" is not a valid dart package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }

    return feature;
  }
}

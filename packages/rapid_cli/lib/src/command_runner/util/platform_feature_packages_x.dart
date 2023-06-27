import 'package:collection/collection.dart';
import 'package:rapid_cli/src/core/language.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';

extension PlatformFeaturePackagesX on Iterable<PlatformFeaturePackage> {
  /// Wheter all [PlatformFeaturePackage]s support the same languages.
  bool supportSameLanguages() =>
      EqualitySet.from(
        DeepCollectionEquality.unordered(),
        map((e) => e.supportedLanguages()),
      ).length ==
      1;

  /// Wheter all [PlatformFeaturePackage]s have the same default language.
  bool haveSameDefaultLanguage() =>
      map((e) => e.defaultLanguage()).toSet().length == 1;

  /// Wheter all [PlatformFeaturePackage]s support [language].
  bool supportLanguage(Language language) =>
      every((e) => e.supportedLanguages().contains(language));
}

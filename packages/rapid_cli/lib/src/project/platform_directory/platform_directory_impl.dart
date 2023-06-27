import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';

import '../project.dart';
import 'platform_directory.dart';
import 'platform_features_directory/platform_features_directory.dart';
import 'platform_navigation_package/platform_navigation_package.dart';
import 'platform_root_package/platform_root_package.dart';

abstract class PlatformDirectoryImpl extends DirectoryImpl
    implements PlatformDirectory {
  PlatformDirectoryImpl(
    this.platform, {
    required this.project,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            project.name,
            '${project.name}_${platform.name}',
          ),
        );

  @override
  PlatformNavigationPackageBuilder? navigationPackageOverrides;

  @override
  PlatformFeaturesDirectoryBuilder? featuresDirectoryOverrides;

  @override
  final Platform platform;

  @override
  final RapidProject project;

  @override
  PlatformNavigationPackage get navigationPackage =>
      (navigationPackageOverrides ?? PlatformNavigationPackage.new)(
        platform,
        project: project,
      );

  @override
  PlatformFeaturesDirectory get featuresDirectory =>
      (featuresDirectoryOverrides ?? PlatformFeaturesDirectory.new)(
        platform,
        project: project,
      );
}

class NoneIosDirectoryImpl extends PlatformDirectoryImpl
    implements NoneIosDirectory {
  NoneIosDirectoryImpl(
    super.platform, {
    required super.project,
  }) : assert(platform != Platform.ios);

  @override
  NoneIosRootPackageBuilder? rootPackageOverrides;

  @override
  NoneIosRootPackage get rootPackage =>
      (rootPackageOverrides ?? NoneIosRootPackage.new)(
        platform,
        project: project,
      );

  // TODO maybe pass languages into this method not just lang
  @override
  Future<void> create({
    String? description,
    String? orgName,
    required Language language,
  }) async {
    await rootPackage.create(
      description: description,
      orgName: orgName,
      languages: {
        language,
        if (language.hasCountryCode || language.hasScriptCode)
          Language(languageCode: language.languageCode),
      },
    );

    await navigationPackage.create();

    final appFeaturePackage = featuresDirectory
        .featurePackage<PlatformAppFeaturePackage>(name: 'app');
    await appFeaturePackage.create(
      description: 'The App feature.', // TODO platform info
      localization: false,
      defaultLanguage: language,
      languages: {
        language,
        if (language.hasCountryCode || language.hasScriptCode)
          Language(languageCode: language.languageCode),
      },
    );

    final homePageFeaturePackage = featuresDirectory
        .featurePackage<PlatformPageFeaturePackage>(name: 'home_page');
    await homePageFeaturePackage.create(
      description: 'The Home Page feature.', // TODO platform info
      localization: true,
      exampleTranslation: true,
      defaultLanguage: language,
      languages: {
        language,
        if (language.hasCountryCode || language.hasScriptCode)
          Language(languageCode: language.languageCode),
      },
    );
  }
}

class IosDirectoryImpl extends PlatformDirectoryImpl implements IosDirectory {
  IosDirectoryImpl({
    required super.project,
  }) : super(Platform.ios);

  @override
  IosRootPackageBuilder? rootPackageOverrides;

  @override
  IosRootPackage get rootPackage =>
      (rootPackageOverrides ?? IosRootPackage.new)(
        project: project,
      );

  // TODO maybe pass languages into this method not just lang
  @override
  Future<void> create({
    required String orgName,
    required Language language,
  }) async {
    await rootPackage.create(
      orgName: orgName,
      languages: {
        language,
        if (language.hasCountryCode || language.hasScriptCode)
          Language(languageCode: language.languageCode),
      },
    );

    await navigationPackage.create();

    final appFeaturePackage = featuresDirectory
        .featurePackage<PlatformAppFeaturePackage>(name: 'app');
    await appFeaturePackage.create(
      description: 'The App feature.', // TODO platform info
      localization: false,
      defaultLanguage: language,
      languages: {
        language,
        if (language.hasCountryCode || language.hasScriptCode)
          Language(languageCode: language.languageCode),
      },
    );

    final homePageFeaturePackage = featuresDirectory
        .featurePackage<PlatformPageFeaturePackage>(name: 'home_page');
    await homePageFeaturePackage.create(
      description: 'The Home Page feature.', // TODO platform info
      localization: true, // TODO good?
      defaultLanguage: language,
      languages: {
        language,
        if (language.hasCountryCode || language.hasScriptCode)
          Language(languageCode: language.languageCode),
      },
    );
  }
}

class MobileDirectoryImpl extends PlatformDirectoryImpl
    implements MobileDirectory {
  MobileDirectoryImpl({
    required super.project,
  }) : super(Platform.mobile);

  @override
  MobileRootPackageBuilder? rootPackageOverrides;

  @override
  MobileRootPackage get rootPackage =>
      (rootPackageOverrides ?? MobileRootPackage.new)(
        project: project,
      );

  // TODO maybe pass languages into this method not just lang
  @override
  Future<void> create({
    required String orgName,
    required Language language,
    String? description,
  }) async {
    await rootPackage.create(
      orgName: orgName,
      languages: {
        language,
        if (language.hasCountryCode || language.hasScriptCode)
          Language(languageCode: language.languageCode),
      },
      description: description,
    );

    await navigationPackage.create();

    final appFeaturePackage = featuresDirectory
        .featurePackage<PlatformAppFeaturePackage>(name: 'app');
    await appFeaturePackage.create(
      description: 'The App feature.', // TODO platform info
      localization: false,
      defaultLanguage: language,
      languages: {
        language,
        if (language.hasCountryCode || language.hasScriptCode)
          Language(languageCode: language.languageCode),
      },
    );

    final homePageFeaturePackage = featuresDirectory
        .featurePackage<PlatformPageFeaturePackage>(name: 'home_page');
    await homePageFeaturePackage.create(
      description: 'The Home Page feature.', // TODO platform info
      localization: true, // TODO good
      defaultLanguage: language,
      languages: {
        language,
        if (language.hasCountryCode || language.hasScriptCode)
          Language(languageCode: language.languageCode),
      },
    );
  }
}

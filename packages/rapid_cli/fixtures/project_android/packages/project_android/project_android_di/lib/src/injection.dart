import 'package:project_android_android_home_page/project_android_android_home_page.dart';
import 'package:project_android_infrastructure/project_android_infrastructure.dart';

import 'package:project_android_logging/project_android_logging.dart';

import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    // platform independent
    ProjectAndroidLoggingPackageModule,
    ProjectAndroidInfrastructurePackageModule,
    // android
    ProjectAndroidAndroidHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );
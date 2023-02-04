import 'package:project_ios_infrastructure/project_ios_infrastructure.dart';
import 'package:project_ios_ios_home_page/project_ios_ios_home_page.dart';

import 'package:project_ios_logging/project_ios_logging.dart';

import 'package:injectable/injectable.dart';
import 'package:rapid_di/rapid_di.dart';

import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    // platform independent
    ProjectIosLoggingPackageModule,
    ProjectIosInfrastructurePackageModule,

    // ios
    ProjectIosIosHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

import 'package:project_ios_di/project_ios_di.dart';
import 'package:project_ios_infrastructure/project_ios_infrastructure.dart';
import 'package:project_ios_ios_app/project_ios_ios_app.dart';
import 'package:project_ios_ios_home_page/project_ios_ios_home_page.dart';
import 'package:project_ios_logging/project_ios_logging.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    ProjectIosLoggingPackageModule,
    ProjectIosInfrastructurePackageModule,
    ProjectIosIosAppPackageModule,
    ProjectIosIosHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

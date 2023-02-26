import 'package:project_web_infrastructure/project_web_infrastructure.dart';
import 'package:project_web_logging/project_web_logging.dart';
import 'package:project_web_web_app/project_web_web_app.dart';
import 'package:project_web_web_home_page/project_web_web_home_page.dart';
import 'package:injectable/injectable.dart';
import 'package:rapid_di/rapid_di.dart';

import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    ProjectWebLoggingPackageModule,
    ProjectWebInfrastructurePackageModule,
    ProjectWebWebAppPackageModule,
    ProjectWebWebHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

import 'package:project_web_infrastructure/project_web_infrastructure.dart';

import 'package:project_web_logging/project_web_logging.dart';

import 'package:project_web_web_home_page/project_web_web_home_page.dart';

import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    // platform independent
    ProjectWebLoggingPackageModule,
    ProjectWebInfrastructurePackageModule,

    // web
    ProjectWebWebHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );
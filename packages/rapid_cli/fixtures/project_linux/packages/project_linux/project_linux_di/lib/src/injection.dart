import 'package:project_linux_infrastructure/project_linux_infrastructure.dart';

import 'package:project_linux_linux_home_page/project_linux_linux_home_page.dart';
import 'package:project_linux_logging/project_linux_logging.dart';

import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    // platform independent
    ProjectLinuxLoggingPackageModule,
    ProjectLinuxInfrastructurePackageModule,

    // linux
    ProjectLinuxLinuxHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

import 'package:project_linux_infrastructure/project_linux_infrastructure.dart';
import 'package:project_linux_linux_app/project_linux_linux_app.dart';
import 'package:project_linux_linux_home_page/project_linux_linux_home_page.dart';
import 'package:project_linux_logging/project_linux_logging.dart';
import 'package:injectable/injectable.dart';
import 'package:rapid_di/rapid_di.dart';

import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    ProjectLinuxLoggingPackageModule,
    ProjectLinuxInfrastructurePackageModule,
    ProjectLinuxLinuxAppPackageModule,
    ProjectLinuxLinuxHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

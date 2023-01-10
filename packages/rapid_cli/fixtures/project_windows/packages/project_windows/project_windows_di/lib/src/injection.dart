import 'package:project_windows_infrastructure/project_windows_infrastructure.dart';

import 'package:project_windows_logging/project_windows_logging.dart';

import 'package:project_windows_windows_home_page/project_windows_windows_home_page.dart';
import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    // platform independent
    ProjectWindowsLoggingPackageModule,
    ProjectWindowsInfrastructurePackageModule,

    // windows
    ProjectWindowsWindowsHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

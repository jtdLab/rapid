import 'package:project_macos_di/project_macos_di.dart';
import 'package:project_macos_infrastructure/project_macos_infrastructure.dart';
import 'package:project_macos_logging/project_macos_logging.dart';
import 'package:project_macos_macos_app/project_macos_macos_app.dart';
import 'package:project_macos_macos_home_page/project_macos_macos_home_page.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    ProjectMacosLoggingPackageModule,
    ProjectMacosInfrastructurePackageModule,
    ProjectMacosMacosAppPackageModule,
    ProjectMacosMacosHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

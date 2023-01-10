import 'package:project_all_android_home_page/project_all_android_home_page.dart';
import 'package:project_all_infrastructure/project_all_infrastructure.dart';
import 'package:project_all_ios_home_page/project_all_ios_home_page.dart';
import 'package:project_all_linux_home_page/project_all_linux_home_page.dart';
import 'package:project_all_logging/project_all_logging.dart';
import 'package:project_all_macos_home_page/project_all_macos_home_page.dart';
import 'package:project_all_web_home_page/project_all_web_home_page.dart';
import 'package:project_all_windows_home_page/project_all_windows_home_page.dart';
import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    // platform independent
    ProjectAllLoggingPackageModule,
    ProjectAllInfrastructurePackageModule,
    // android
    ProjectAllAndroidHomePagePackageModule,
    // ios
    ProjectAllIosHomePagePackageModule,
    // web
    ProjectAllWebHomePagePackageModule,
    // linux
    ProjectAllLinuxHomePagePackageModule,
    // macos
    ProjectAllMacosHomePagePackageModule,
    // windows
    ProjectAllWindowsHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

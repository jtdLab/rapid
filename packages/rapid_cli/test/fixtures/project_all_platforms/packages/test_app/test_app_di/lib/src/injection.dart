import 'package:test_app_android_home_page/test_app_android_home_page.dart';
import 'package:test_app_infrastructure/test_app_infrastructure.dart';
import 'package:test_app_ios_home_page/test_app_ios_home_page.dart';
import 'package:test_app_linux_home_page/test_app_linux_home_page.dart';
import 'package:test_app_logging/test_app_logging.dart';
import 'package:test_app_macos_home_page/test_app_macos_home_page.dart';
import 'package:test_app_web_home_page/test_app_web_home_page.dart';
import 'package:test_app_windows_home_page/test_app_windows_home_page.dart';
import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    // platform independent
    TestAppLoggingPackageModule,
    TestAppInfrastructurePackageModule,
    // android
    TestAppAndroidHomePagePackageModule,
    // ios
    TestAppIosHomePagePackageModule,
    // web
    TestAppWebHomePagePackageModule,
    // linux
    TestAppLinuxHomePagePackageModule,
    // macos
    TestAppMacosHomePagePackageModule,
    // windows
    TestAppWindowsHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

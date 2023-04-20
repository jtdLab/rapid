import 'package:example_di/example_di.dart';
import 'package:example_infrastructure/example_infrastructure.dart';
import 'package:example_ios_app/example_ios_app.dart';
import 'package:example_ios_home_page/example_ios_home_page.dart';
import 'package:example_ios_login_page/example_ios_login_page.dart';
import 'package:example_ios_protected_router/example_ios_protected_router.dart';
import 'package:example_ios_public_router/example_ios_public_router.dart';
import 'package:example_ios_sign_up_page/example_ios_sign_up_page.dart';
import 'package:example_logging/example_logging.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    ExampleLoggingPackageModule,
    ExampleInfrastructurePackageModule,
    ExampleIosAppPackageModule,
    ExampleIosHomePagePackageModule,
    ExampleIosLoginPagePackageModule,
    ExampleIosSignUpPagePackageModule,
    ExampleIosProtectedRouterPackageModule,
    ExampleIosPublicRouterPackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

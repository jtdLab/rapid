import 'package:test_app_infrastructure/test_app_infrastructure.dart';

import 'package:test_app_logging/test_app_logging.dart';

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
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

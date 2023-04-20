import 'package:example_di/example_di.dart';
import 'package:example_infrastructure/example_infrastructure.dart';
import 'package:example_logging/example_logging.dart';
import 'package:example_windows_app/example_windows_app.dart';
import 'package:example_windows_home_page/example_windows_home_page.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    ExampleLoggingPackageModule,
    ExampleInfrastructurePackageModule,
    ExampleWindowsAppPackageModule,
    ExampleWindowsHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

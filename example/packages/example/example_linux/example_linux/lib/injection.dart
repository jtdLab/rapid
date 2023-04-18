import 'package:example_di/example_di.dart';
import 'package:example_infrastructure/example_infrastructure.dart';
import 'package:example_linux_app/example_linux_app.dart';
import 'package:example_linux_home_page/example_linux_home_page.dart';
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
    ExampleLinuxAppPackageModule,
    ExampleLinuxHomePagePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

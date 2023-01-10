import 'package:project_none_infrastructure/project_none_infrastructure.dart';

import 'package:project_none_logging/project_none_logging.dart';

import 'package:injectable/injectable.dart';

import 'di_container.dart';
import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    // platform independent
    ProjectNoneLoggingPackageModule,
    ProjectNoneInfrastructurePackageModule,
  ],
)
void configureDependencies(String environment, String platform) => getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

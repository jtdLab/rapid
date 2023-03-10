import 'package:project_macos_di/project_macos_di.dart';
import 'package:project_macos_logging/project_macos_logging.dart';
import 'package:project_macos_macos_app/project_macos_macos_app.dart' as macos;
import 'package:flutter/widgets.dart';

import 'bootstrap.dart';
import 'router_observer.dart';
import 'run_on_platform.dart';

void main() => runOnPlatform(
      macos: runMacosApp,
    );

Future<void> runMacosApp() async {
  configureDependencies(Environment.test, Platform.macos);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more macos development setup here

  final logger = getIt<ProjectMacosLogger>();
  final app = macos.App(
    routerObserverBuilder: () => [
      ProjectMacosRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

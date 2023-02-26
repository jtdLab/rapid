import 'package:project_windows_di/project_windows_di.dart';
import 'package:project_windows_logging/project_windows_logging.dart';
import 'package:project_windows_windows_app/project_windows_windows_app.dart'
    as windows;
import 'package:flutter/widgets.dart';

import 'bootstrap.dart';
import 'router_observer.dart';
import 'run_on_platform.dart';

void main() => runOnPlatform(
      windows: runWindowsApp,
    );

Future<void> runWindowsApp() async {
  configureDependencies(Environment.test, Platform.windows);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more windows development setup here

  final logger = getIt<ProjectWindowsLogger>();
  final app = windows.App(
    routerObserverBuilder: () => [
      ProjectWindowsRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

import 'package:project_linux_di/project_linux_di.dart';
import 'package:project_linux_linux_app/project_linux_linux_app.dart' as linux;
import 'package:project_linux_logging/project_linux_logging.dart';
import 'package:flutter/widgets.dart';

import 'bootstrap.dart';
import 'router_observer.dart';
import 'run_on_platform.dart';

void main() => runOnPlatform(
      linux: runLinuxApp,
    );

Future<void> runLinuxApp() async {
  configureDependencies(Environment.prod, Platform.linux);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more linux development setup here

  final logger = getIt<ProjectLinuxLogger>();
  final app = linux.App(
    routerObserverBuilder: () => [
      ProjectLinuxRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

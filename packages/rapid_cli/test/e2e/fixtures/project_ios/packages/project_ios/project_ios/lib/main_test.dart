import 'package:project_ios_di/project_ios_di.dart';
import 'package:project_ios_ios_app/project_ios_ios_app.dart' as ios;
import 'package:project_ios_logging/project_ios_logging.dart';
import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';

import 'bootstrap.dart';
import 'router_observer.dart';

void main() => runOnPlatform(
      ios: runIosApp,
    );

Future<void> runIosApp() async {
  configureDependencies(Environment.test, Platform.ios);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more ios development setup here

  final logger = getIt<ProjectIosLogger>();
  final app = ios.App(
    routerObserverBuilder: () => [
      ProjectIosRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

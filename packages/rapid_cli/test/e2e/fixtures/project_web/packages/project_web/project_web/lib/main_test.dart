import 'package:project_web_di/project_web_di.dart';
import 'package:project_web_logging/project_web_logging.dart';
import 'package:project_web_web_app/project_web_web_app.dart' as web;
import 'package:flutter/widgets.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';
import 'router_observer.dart';
import 'run_on_platform.dart';

void main() => runOnPlatform(
      web: runWebApp,
    );

Future<void> runWebApp() async {
  configureDependencies(Environment.test, Platform.web);
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more web development setup here

  final logger = getIt<ProjectWebLogger>();
  final app = web.App(
    routerObserverBuilder: () => [
      ProjectWebRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

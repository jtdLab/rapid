import 'package:project_all_android_app/project_all_android_app.dart'
    as android;
import 'package:project_all_di/project_all_di.dart';
import 'package:project_all_ios_app/project_all_ios_app.dart' as ios;
import 'package:project_all_linux_app/project_all_linux_app.dart' as linux;
import 'package:project_all_logging/project_all_logging.dart';
import 'package:project_all_macos_app/project_all_macos_app.dart' as macos;
import 'package:project_all_web_app/project_all_web_app.dart' as web;
import 'package:project_all_windows_app/project_all_windows_app.dart'
    as windows;
import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';
import 'router_observer.dart';

void main() => runOnPlatform(
      android: runAndroidApp,
      ios: runIosApp,
      web: runWebApp,
      linux: runLinuxApp,
      macos: runMacosApp,
      windows: runWindowsApp,
    );

Future<void> runAndroidApp() async {
  configureDependencies(Environment.test, Platform.android);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more android development setup here

  final logger = getIt<ProjectAllLogger>();
  final app = android.App(
    navigatorObserverBuilder: () => [
      ProjectAllRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runIosApp() async {
  configureDependencies(Environment.test, Platform.ios);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more ios development setup here

  final logger = getIt<ProjectAllLogger>();
  final app = ios.App(
    navigatorObserverBuilder: () => [
      ProjectAllRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runWebApp() async {
  configureDependencies(Environment.test, Platform.web);
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more web development setup here

  final logger = getIt<ProjectAllLogger>();
  final app = web.App(
    navigatorObserverBuilder: () => [
      ProjectAllRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runLinuxApp() async {
  configureDependencies(Environment.test, Platform.linux);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more linux development setup here

  final logger = getIt<ProjectAllLogger>();
  final app = linux.App(
    navigatorObserverBuilder: () => [
      ProjectAllRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runMacosApp() async {
  configureDependencies(Environment.test, Platform.macos);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more macos development setup here

  final logger = getIt<ProjectAllLogger>();
  final app = macos.App(
    navigatorObserverBuilder: () => [
      ProjectAllRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runWindowsApp() async {
  configureDependencies(Environment.test, Platform.windows);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more windows development setup here

  final logger = getIt<ProjectAllLogger>();
  final app = windows.App(
    navigatorObserverBuilder: () => [
      ProjectAllRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

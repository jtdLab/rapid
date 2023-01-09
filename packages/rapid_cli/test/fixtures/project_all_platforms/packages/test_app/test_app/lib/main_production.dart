import 'package:test_app_android_app/test_app_android_app.dart' as android;
import 'package:test_app_di/test_app_di.dart';
import 'package:test_app_ios_app/test_app_ios_app.dart' as ios;
import 'package:test_app_linux_app/test_app_linux_app.dart' as linux;
import 'package:test_app_logging/test_app_logging.dart';
import 'package:test_app_macos_app/test_app_macos_app.dart' as macos;
import 'package:test_app_web_app/test_app_web_app.dart' as web;
import 'package:test_app_windows_app/test_app_windows_app.dart' as windows;
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
  configureDependencies(Environment.prod, Platform.android);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more android development setup here

  final logger = getIt<TestAppLogger>();
  final app = android.App(
    navigatorObserverBuilder: () => [
      TestAppRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runIosApp() async {
  configureDependencies(Environment.prod, Platform.ios);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more ios development setup here

  final logger = getIt<TestAppLogger>();
  final app = ios.App(
    navigatorObserverBuilder: () => [
      TestAppRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runWebApp() async {
  configureDependencies(Environment.prod, Platform.web);
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more web development setup here

  final logger = getIt<TestAppLogger>();
  final app = web.App(
    navigatorObserverBuilder: () => [
      TestAppRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runLinuxApp() async {
  configureDependencies(Environment.prod, Platform.linux);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more linux development setup here

  final logger = getIt<TestAppLogger>();
  final app = linux.App(
    navigatorObserverBuilder: () => [
      TestAppRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runMacosApp() async {
  configureDependencies(Environment.prod, Platform.macos);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more macos development setup here

  final logger = getIt<TestAppLogger>();
  final app = macos.App(
    navigatorObserverBuilder: () => [
      TestAppRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

Future<void> runWindowsApp() async {
  configureDependencies(Environment.prod, Platform.windows);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more windows development setup here

  final logger = getIt<TestAppLogger>();
  final app = windows.App(
    navigatorObserverBuilder: () => [
      TestAppRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}

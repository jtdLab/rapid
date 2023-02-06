import 'package:project_android_android_app/project_android_android_app.dart'
    as android;
import 'package:project_android_di/project_android_di.dart';
import 'package:project_android_logging/project_android_logging.dart';
import 'package:flutter/widgets.dart';
import 'package:rapid/rapid.dart';

import 'bootstrap.dart';
import 'router_observer.dart';

void main() => runOnPlatform(
      android: runAndroidApp,
    );

Future<void> runAndroidApp() async {
  configureDependencies(Environment.dev, Platform.android);
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: add more android development setup here

  final logger = getIt<ProjectAndroidLogger>();
  final app = android.App(
    routerObserverBuilder: () => [
      ProjectAndroidRouterObserver(logger),
    ],
  );
  await bootstrap(app, logger);
}
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:project_windows_di/project_windows_di.dart';
import 'package:project_windows_logging/project_windows_logging.dart';
import 'package:project_windows_windows/run_on_windows.dart';
import 'package:project_windows_windows_app/project_windows_windows_app.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnWindows(() async {
      configureDependencies(Environment.prod, Platform.windows);
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more windows production setup here

      final logger = getIt<ProjectWindowsLogger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          ProjectWindowsRouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });

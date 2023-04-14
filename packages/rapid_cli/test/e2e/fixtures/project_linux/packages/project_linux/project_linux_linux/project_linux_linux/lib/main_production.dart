import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:project_linux_di/project_linux_di.dart';
import 'package:project_linux_logging/project_linux_logging.dart';
import 'package:project_linux_linux/run_on_linux.dart';
import 'package:project_linux_linux_app/project_linux_linux_app.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnLinux(() async {
      configureDependencies(Environment.prod, Platform.linux);
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more linux production setup here

      final logger = getIt<ProjectLinuxLogger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          ProjectLinuxRouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });

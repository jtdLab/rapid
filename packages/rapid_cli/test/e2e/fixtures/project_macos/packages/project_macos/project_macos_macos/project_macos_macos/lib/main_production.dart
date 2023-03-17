import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:project_macos_di/project_macos_di.dart';
import 'package:project_macos_logging/project_macos_logging.dart';
import 'package:project_macos_macos/run_on_macos.dart';
import 'package:project_macos_macos_app/project_macos_macos_app.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnMacos(() async {
      configureDependencies(Environment.prod, Platform.macos);
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more macos production setup here

      final logger = getIt<ProjectMacosLogger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          ProjectMacosRouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });

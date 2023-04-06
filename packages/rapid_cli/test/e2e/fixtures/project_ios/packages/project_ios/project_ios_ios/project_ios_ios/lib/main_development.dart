import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:project_ios_di/project_ios_di.dart';
import 'package:project_ios_logging/project_ios_logging.dart';
import 'package:project_ios_ios/run_on_ios.dart';
import 'package:project_ios_ios_app/project_ios_ios_app.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnIos(() async {
      configureDependencies(Environment.dev, Platform.ios);
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more ios development setup here

      final logger = getIt<ProjectIosLogger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          ProjectIosRouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });

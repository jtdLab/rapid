import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:project_web_di/project_web_di.dart';
import 'package:project_web_logging/project_web_logging.dart';
import 'package:project_web_web/run_on_web.dart';
import 'package:project_web_web_app/project_web_web_app.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnWeb(() async {
      configureDependencies(Environment.prod, Platform.web);
      setPathUrlStrategy();
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more web production setup here

      final logger = getIt<ProjectWebLogger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          ProjectWebRouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });

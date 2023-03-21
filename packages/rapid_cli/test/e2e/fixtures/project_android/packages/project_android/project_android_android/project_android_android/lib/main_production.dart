import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:project_android_di/project_android_di.dart';
import 'package:project_android_logging/project_android_logging.dart';
import 'package:project_android_android/run_on_android.dart';
import 'package:project_android_android_app/project_android_android_app.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnAndroid(() async {
      configureDependencies(Environment.prod, Platform.android);
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more android production setup here

      final logger = getIt<ProjectAndroidLogger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          ProjectAndroidRouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });

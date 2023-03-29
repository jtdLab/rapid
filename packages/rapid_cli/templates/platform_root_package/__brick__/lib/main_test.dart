{{#android}}import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:{{project_name}}_android/run_on_android.dart';
import 'package:{{project_name}}_android_app/{{project_name}}_android_app.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnAndroid(() async {
      configureDependencies(Environment.test, Platform.android);
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more android test setup here

      final logger = getIt<{{project_name.pascalCase()}}Logger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          {{project_name.pascalCase()}}RouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });
{{/android}}{{#ios}}import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:{{project_name}}_ios/run_on_ios.dart';
import 'package:{{project_name}}_ios_app/{{project_name}}_ios_app.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnIos(() async {
      configureDependencies(Environment.test, Platform.ios);
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more ios test setup here

      final logger = getIt<{{project_name.pascalCase()}}Logger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          {{project_name.pascalCase()}}RouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });
{{/ios}}{{#web}}
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:{{project_name}}_web/run_on_web.dart';
import 'package:{{project_name}}_web_app/{{project_name}}_web_app.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnWeb(() async {
      configureDependencies(Environment.test, Platform.web);
      setPathUrlStrategy();
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more web test setup here

      final logger = getIt<{{project_name.pascalCase()}}Logger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          {{project_name.pascalCase()}}RouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });
{{/web}}{{#linux}}import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:{{project_name}}_linux/run_on_linux.dart';
import 'package:{{project_name}}_linux_app/{{project_name}}_linux_app.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnLinux(() async {
      configureDependencies(Environment.test, Platform.linux);
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more linux test setup here

      final logger = getIt<{{project_name.pascalCase()}}Logger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          {{project_name.pascalCase()}}RouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });
{{/linux}}{{#macos}}
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:{{project_name}}_macos/run_on_macos.dart';
import 'package:{{project_name}}_macos_app/{{project_name}}_macos_app.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnMacos(() async {
      configureDependencies(Environment.test, Platform.macos);
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more macos test setup here

      final logger = getIt<{{project_name.pascalCase()}}Logger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          {{project_name.pascalCase()}}RouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });
{{/macos}}{{#windows}}import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:{{project_name}}_windows/run_on_windows.dart';
import 'package:{{project_name}}_windows_app/{{project_name}}_windows_app.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

void main() => runOnWindows(() async {
      configureDependencies(Environment.test, Platform.windows);
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add more windows test setup here

      final logger = getIt<{{project_name.pascalCase()}}Logger>();
      final router = Router();
      final app = App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        router: router,
        routerObserverBuilder: () => [
          {{project_name.pascalCase()}}RouterObserver(logger),
        ],
      );
      await bootstrap(app, logger);
    });
{{/windows}}
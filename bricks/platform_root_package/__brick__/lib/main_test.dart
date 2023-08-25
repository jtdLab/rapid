{{#android}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_android.dart';

Future<void> main() => runOnAndroid(() async {
      await configureDependencies(Environment.test, Platform.android);
      // TODO: add Android test setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Android test setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/android}}{{#ios}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_ios.dart';

Future<void> main() => runOnIos(() async {
      await configureDependencies(Environment.test, Platform.ios);
      // TODO: add iOS test setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add iOS test setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/ios}}{{#web}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart'
    show WidgetsFlutterBinding, visibleForTesting;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_web.dart';

@visibleForTesting
void Function()? setUrlStrategy = usePathUrlStrategy;

Future<void> main() => runOnWeb(() async {
      await configureDependencies(Environment.test, Platform.web);
      setUrlStrategy?.call();
      // TODO: add Web test setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Web test setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/web}}{{#linux}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_linux.dart';

Future<void> main() => runOnLinux(() async {
      await configureDependencies(Environment.test, Platform.linux);
      // TODO: add Linux test setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Linux test setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/linux}}{{#macos}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_macos.dart';

Future<void> main() => runOnMacos(() async {
      await configureDependencies(Environment.test, Platform.macos);
      // TODO: add macOS test setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add macOS test setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/macos}}{{#windows}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_windows.dart';

Future<void> main() => runOnWindows(() async {
      await configureDependencies(Environment.test, Platform.windows);
      // TODO: add Windows test setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Windows test setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/windows}}{{#mobile}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_mobile.dart';

Future<void> main() => runOnMobile(() async {
      await configureDependencies(Environment.test, Platform.mobile);
      // TODO: add Mobile test setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Mobile test setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/mobile}}
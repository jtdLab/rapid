{{#android}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_android.dart';

Future<void> main() => runOnAndroid(() async {
      await configureDependencies(Environment.prod, Platform.android);
      // TODO: add Android production setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Android production setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/android}}{{#ios}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_ios.dart';

Future<void> main() => runOnIos(() async {
      await configureDependencies(Environment.prod, Platform.ios);
      // TODO: add iOS production setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add iOS production setup here
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
      await configureDependencies(Environment.prod, Platform.web);
      setUrlStrategy?.call();
      // TODO: add Web production setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Web production setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/web}}{{#linux}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_linux.dart';

Future<void> main() => runOnLinux(() async {
      await configureDependencies(Environment.prod, Platform.linux);
      // TODO: add Linux production setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Linux production setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/linux}}{{#macos}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_macos.dart';

Future<void> main() => runOnMacos(() async {
      await configureDependencies(Environment.prod, Platform.macos);
      // TODO: add macOS production setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add macOS production setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/macos}}{{#windows}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_windows.dart';

Future<void> main() => runOnWindows(() async {
      await configureDependencies(Environment.prod, Platform.windows);
      // TODO: add Windows production setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Windows production setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/windows}}{{#mobile}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';
import 'run_on_mobile.dart';

Future<void> main() => runOnMobile(() async {
      await configureDependencies(Environment.prod, Platform.mobile);
      // TODO: add Mobile production setup here
      // (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Mobile production setup here
      // (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/mobile}}
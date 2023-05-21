{{#android}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_android/run_on_android.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnAndroid(() async {
      configureDependencies(Environment.test, Platform.android);
      // TODO: add Android test setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Android test setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/android}}{{#ios}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_ios/run_on_ios.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnIos(() async {
      configureDependencies(Environment.test, Platform.ios);
      // TODO: add iOS test setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add iOS test setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/ios}}{{#web}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_web/run_on_web.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnWeb(() async {
      configureDependencies(Environment.test, Platform.web);
      setPathUrlStrategy();
      // TODO: add Web test setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Web test setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/web}}{{#linux}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_linux/run_on_linux.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnLinux(() async {
      configureDependencies(Environment.test, Platform.linux);
      // TODO: add Linux test setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Linux test setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/linux}}{{#macos}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_macos/run_on_macos.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnMacos(() async {
      configureDependencies(Environment.test, Platform.macos);
      // TODO: add macOS test setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add macOS test setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/macos}}{{#windows}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_windows/run_on_windows.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnWindows(() async {
      configureDependencies(Environment.test, Platform.windows);
      // TODO: add Windows test setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Windows test setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/windows}}{{#mobile}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_mobile/run_on_mobile.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnMobile(() async {
      configureDependencies(Environment.test, Platform.mobile);
      // TODO: add Mobile test setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Mobile test setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
{{/mobile}}
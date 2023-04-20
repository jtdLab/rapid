import 'package:example_di/example_di.dart';
import 'package:example_windows/run_on_windows.dart';
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

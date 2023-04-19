import 'package:project_windows_di/project_windows_di.dart';
import 'package:project_windows_windows/run_on_windows.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnWindows(() async {
      configureDependencies(Environment.dev, Platform.windows);
      // TODO: add Windows development setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Windows development setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });

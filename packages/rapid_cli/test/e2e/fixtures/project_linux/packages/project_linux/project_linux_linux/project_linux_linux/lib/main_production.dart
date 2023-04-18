import 'package:project_linux_di/project_linux_di.dart';
import 'package:project_linux_linux/run_on_linux.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnLinux(() async {
      configureDependencies(Environment.prod, Platform.linux);
      // TODO: add Linux production setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Linux production setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
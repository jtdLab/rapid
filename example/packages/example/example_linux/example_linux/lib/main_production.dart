import 'package:example_di/example_di.dart';
import 'package:example_linux/run_on_linux.dart';
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
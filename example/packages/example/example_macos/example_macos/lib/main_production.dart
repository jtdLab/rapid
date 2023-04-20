import 'package:example_di/example_di.dart';
import 'package:example_macos/run_on_macos.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnMacos(() async {
      configureDependencies(Environment.prod, Platform.macos);
      // TODO: add macOS production setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add macOS production setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });

import 'package:example_di/example_di.dart';
import 'package:example_macos/run_on_macos.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnMacos(() async {
      configureDependencies(Environment.dev, Platform.macos);
      // TODO: add macOS development setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add macOS development setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });

import 'package:example_di/example_di.dart';
import 'package:example_ios/run_on_ios.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnIos(() async {
      configureDependencies(Environment.dev, Platform.ios);
      // TODO: add iOS development setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add iOS development setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });

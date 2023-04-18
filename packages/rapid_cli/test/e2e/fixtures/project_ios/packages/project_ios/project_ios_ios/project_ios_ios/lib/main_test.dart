import 'package:project_ios_di/project_ios_di.dart';
import 'package:project_ios_ios/run_on_ios.dart';
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
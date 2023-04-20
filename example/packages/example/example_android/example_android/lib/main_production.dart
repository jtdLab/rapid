import 'package:example_di/example_di.dart';
import 'package:example_android/run_on_android.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnAndroid(() async {
      configureDependencies(Environment.prod, Platform.android);
      // TODO: add Android production setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Android production setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });

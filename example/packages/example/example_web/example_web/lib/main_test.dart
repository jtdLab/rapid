import 'package:example_di/example_di.dart';
import 'package:example_web/run_on_web.dart';
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

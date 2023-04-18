import 'package:project_web_di/project_web_di.dart';
import 'package:project_web_web/run_on_web.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:url_strategy/url_strategy.dart';

import 'bootstrap.dart';
import 'injection.dart';

void main() => runOnWeb(() async {
      configureDependencies(Environment.dev, Platform.web);
      setPathUrlStrategy();
      // TODO: add Web development setup here (pre WidgetsFlutterBinding.ensureInitialized())
      WidgetsFlutterBinding.ensureInitialized();
      // TODO: add Web development setup here (post WidgetsFlutterBinding.ensureInitialized())

      await bootstrap();
    });
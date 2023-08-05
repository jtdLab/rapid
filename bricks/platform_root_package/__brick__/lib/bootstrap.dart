import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_{{platform}}_app/{{project_name}}_{{platform}}_app.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:flutter/widgets.dart' show runApp;

import 'bloc_observer.dart';
import 'router.dart';
import 'router_observer.dart';

Future<void> bootstrap() async {
  final logger = getIt<{{project_name.pascalCase()}}Logger>();
  Bloc.observer = {{project_name.pascalCase()}}BlocObserver(logger);
  Bloc.transformer = sequential();

  final router = Router();

  runApp(
    App(
      router: router,
      navigatorObserverBuilder: () => [
        {{project_name.pascalCase()}}RouterObserver(logger),
      ],
    ),
  );
}

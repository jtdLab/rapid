import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';

import 'bloc_observer.dart';

Future<void> bootstrap(Widget app, {{project_name.pascalCase()}}Logger logger) async {
  Bloc.observer = {{project_name.pascalCase()}}BlocObserver(logger);
  Bloc.transformer = sequential();

  runApp(app);
}

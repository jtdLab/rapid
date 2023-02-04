import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:project_web_logging/project_web_logging.dart';

import 'bloc_observer.dart';

Future<void> bootstrap(Widget app, ProjectWebLogger logger) async {
  Bloc.observer = ProjectWebBlocObserver(logger);
  Bloc.transformer = sequential();

  runApp(app);
}

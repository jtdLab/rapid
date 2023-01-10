import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:project_all_logging/project_all_logging.dart';

import 'bloc_observer.dart';

Future<void> bootstrap(Widget app, ProjectAllLogger logger) async {
  Bloc.observer = ProjectAllBlocObserver(logger);
  Bloc.transformer = sequential();

  runApp(app);
}

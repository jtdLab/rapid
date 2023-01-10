import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:project_none_logging/project_none_logging.dart';

import 'bloc_observer.dart';

Future<void> bootstrap(Widget app, ProjectNoneLogger logger) async {
  Bloc.observer = ProjectNoneBlocObserver(logger);
  Bloc.transformer = sequential();

  runApp(app);
}

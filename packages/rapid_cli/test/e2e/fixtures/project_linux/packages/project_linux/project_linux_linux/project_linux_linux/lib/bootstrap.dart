import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:project_linux_logging/project_linux_logging.dart';

import 'bloc_observer.dart';

Future<void> bootstrap(Widget app, ProjectLinuxLogger logger) async {
  Bloc.observer = ProjectLinuxBlocObserver(logger);
  Bloc.transformer = sequential();

  runApp(app);
}

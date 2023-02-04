import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:project_windows_logging/project_windows_logging.dart';

import 'bloc_observer.dart';

Future<void> bootstrap(Widget app, ProjectWindowsLogger logger) async {
  Bloc.observer = ProjectWindowsBlocObserver(logger);
  Bloc.transformer = sequential();

  runApp(app);
}

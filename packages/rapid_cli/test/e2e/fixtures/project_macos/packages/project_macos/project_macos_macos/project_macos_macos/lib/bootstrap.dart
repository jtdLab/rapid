import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:project_macos_logging/project_macos_logging.dart';

import 'bloc_observer.dart';

Future<void> bootstrap(Widget app, ProjectMacosLogger logger) async {
  Bloc.observer = ProjectMacosBlocObserver(logger);
  Bloc.transformer = sequential();

  runApp(app);
}

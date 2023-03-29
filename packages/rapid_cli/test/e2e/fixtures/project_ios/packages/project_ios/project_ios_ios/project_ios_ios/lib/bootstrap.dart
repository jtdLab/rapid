import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:project_ios_logging/project_ios_logging.dart';

import 'bloc_observer.dart';

Future<void> bootstrap(Widget app, ProjectIosLogger logger) async {
  Bloc.observer = ProjectIosBlocObserver(logger);
  Bloc.transformer = sequential();

  runApp(app);
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:project_android_logging/project_android_logging.dart';

import 'bloc_observer.dart';

Future<void> bootstrap(Widget app, ProjectAndroidLogger logger) async {
  Bloc.observer = ProjectAndroidBlocObserver(logger);
  Bloc.transformer = sequential();

  runApp(app);
}

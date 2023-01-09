import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:test_app_logging/test_app_logging.dart';

import 'bloc_observer.dart';

Future<void> bootstrap(Widget app, TestAppLogger logger) async {
  Bloc.observer = TestAppBlocObserver(logger);
  Bloc.transformer = sequential();

  runApp(app);
}

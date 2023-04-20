import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:example_di/example_di.dart';
import 'package:example_ios_app/example_ios_app.dart';
import 'package:example_logging/example_logging.dart';
import 'package:flutter/widgets.dart' show runApp;

import 'bloc_observer.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

Future<void> bootstrap() async {
  final logger = getIt<ExampleLogger>();
  Bloc.observer = ExampleBlocObserver(logger);
  Bloc.transformer = sequential();

  final router = Router();

  runApp(
    App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      router: router,
      routerObserverBuilder: () => [
        ExampleRouterObserver(logger),
      ],
    ),
  );
}

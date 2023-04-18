import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:project_ios_di/project_ios_di.dart';
import 'package:project_ios_ios_app/project_ios_ios_app.dart';
import 'package:project_ios_logging/project_ios_logging.dart';
import 'package:flutter/widgets.dart' show runApp;

import 'bloc_observer.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

Future<void> bootstrap() async {
  final logger = getIt<ProjectIosLogger>();
  Bloc.observer = ProjectIosBlocObserver(logger);
  Bloc.transformer = sequential();

  final router = Router();

  runApp(
    App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      router: router,
      routerObserverBuilder: () => [
        ProjectIosRouterObserver(logger),
      ],
    ),
  );
}

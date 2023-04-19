import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:project_linux_di/project_linux_di.dart';
import 'package:project_linux_linux_app/project_linux_linux_app.dart';
import 'package:project_linux_logging/project_linux_logging.dart';
import 'package:flutter/widgets.dart' show runApp;

import 'bloc_observer.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

Future<void> bootstrap() async {
  final logger = getIt<ProjectLinuxLogger>();
  Bloc.observer = ProjectLinuxBlocObserver(logger);
  Bloc.transformer = sequential();

  final router = Router();

  runApp(
    App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      router: router,
      routerObserverBuilder: () => [
        ProjectLinuxRouterObserver(logger),
      ],
    ),
  );
}

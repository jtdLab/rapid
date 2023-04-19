import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:project_macos_di/project_macos_di.dart';
import 'package:project_macos_macos_app/project_macos_macos_app.dart';
import 'package:project_macos_logging/project_macos_logging.dart';
import 'package:flutter/widgets.dart' show runApp;

import 'bloc_observer.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

Future<void> bootstrap() async {
  final logger = getIt<ProjectMacosLogger>();
  Bloc.observer = ProjectMacosBlocObserver(logger);
  Bloc.transformer = sequential();

  final router = Router();

  runApp(
    App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      router: router,
      routerObserverBuilder: () => [
        ProjectMacosRouterObserver(logger),
      ],
    ),
  );
}

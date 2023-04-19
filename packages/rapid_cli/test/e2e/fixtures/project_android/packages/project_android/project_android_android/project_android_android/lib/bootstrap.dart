import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:project_android_di/project_android_di.dart';
import 'package:project_android_android_app/project_android_android_app.dart';
import 'package:project_android_logging/project_android_logging.dart';
import 'package:flutter/widgets.dart' show runApp;

import 'bloc_observer.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

Future<void> bootstrap() async {
  final logger = getIt<ProjectAndroidLogger>();
  Bloc.observer = ProjectAndroidBlocObserver(logger);
  Bloc.transformer = sequential();

  final router = Router();

  runApp(
    App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      router: router,
      routerObserverBuilder: () => [
        ProjectAndroidRouterObserver(logger),
      ],
    ),
  );
}

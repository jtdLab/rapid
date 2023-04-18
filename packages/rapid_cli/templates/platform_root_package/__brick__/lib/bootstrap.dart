import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:{{project_name}}_di/{{project_name}}_di.dart';
{{#android}}import 'package:{{project_name}}_android_app/{{project_name}}_android_app.dart';{{/android}}{{#ios}}import 'package:{{project_name}}_ios_app/{{project_name}}_ios_app.dart';{{/ios}}{{#linux}}import 'package:{{project_name}}_linux_app/{{project_name}}_linux_app.dart';{{/linux}}{{#macos}}import 'package:{{project_name}}_macos_app/{{project_name}}_macos_app.dart';{{/macos}}{{#web}}import 'package:{{project_name}}_web_app/{{project_name}}_web_app.dart';{{/web}}{{#windows}}import 'package:{{project_name}}_windows_app/{{project_name}}_windows_app.dart';{{/windows}}
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:flutter/widgets.dart' show runApp;

import 'bloc_observer.dart';
import 'localizations_delegates.dart';
import 'router.dart';
import 'router_observer.dart';

Future<void> bootstrap() async {
  final logger = getIt<{{project_name.pascalCase()}}Logger>();
  Bloc.observer = {{project_name.pascalCase()}}BlocObserver(logger);
  Bloc.transformer = sequential();

  final router = Router();

  runApp(
    App(
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      router: router,
      routerObserverBuilder: () => [
        {{project_name.pascalCase()}}RouterObserver(logger),
      ],
    )
  );
}

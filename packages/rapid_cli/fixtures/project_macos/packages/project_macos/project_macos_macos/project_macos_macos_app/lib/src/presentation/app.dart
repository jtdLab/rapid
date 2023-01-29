import 'dart:ui';

import 'package:project_macos_macos_routing/project_macos_macos_routing.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';

import 'localizations.dart';

class App extends StatelessWidget {
  final List<AutoRouterObserver> Function()? routerObserverBuilder;
  final Locale? locale;
  final Brightness? brightness;
  final Router? router;
  final Widget? home;

  const App({
    super.key,
    this.routerObserverBuilder,
    this.locale,
    this.brightness,
    this.router,
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    final router = this.router ?? Router();

    if (home != null) {
      return ProjectMacosApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          locale: locale,
          brightness: brightness,
          home: home);
    }

    return ProjectMacosApp(
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      routeInformationParser: router.defaultRouteParser(),
      routerDelegate: router.delegate(
        navigatorObservers: routerObserverBuilder ??
            AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      locale: locale,
      brightness: brightness,
    );
  }
}

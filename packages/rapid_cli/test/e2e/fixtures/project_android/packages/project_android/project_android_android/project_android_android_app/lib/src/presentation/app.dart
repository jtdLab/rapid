import 'package:project_android_android_routing/project_android_android_routing.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';

import 'localizations.dart';

class App extends StatelessWidget {
  final List<AutoRouterObserver> Function()? routerObserverBuilder;
  final Locale? locale;
  final ThemeMode? themeMode;
  final Router? router;
  final Widget? home;

  const App({
    super.key,
    this.routerObserverBuilder,
    this.locale,
    this.themeMode,
    this.router,
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    final router = this.router ?? Router();

    if (home != null) {
      return ProjectAndroidApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          locale: locale,
          themeMode: themeMode,
          home: home);
    }

    return ProjectAndroidApp(
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      routeInformationParser: router.defaultRouteParser(),
      routerDelegate: router.delegate(
        navigatorObservers: routerObserverBuilder ??
            AutoRouterDelegate.defaultNavigatorObserversBuilder,
      ),
      locale: locale,
      themeMode: themeMode,
    );
  }
}

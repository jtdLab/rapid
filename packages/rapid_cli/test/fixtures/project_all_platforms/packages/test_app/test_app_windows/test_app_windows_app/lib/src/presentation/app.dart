import 'package:test_app_windows_home_page/test_app_windows_home_page.dart';
import 'package:test_app_windows_routing/test_app_windows_routing.dart';
import 'package:test_app_ui_windows/test_app_ui_windows.dart';

class App extends StatelessWidget {
  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

  const App({
    super.key,
    this.navigatorObserverBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final router = Router();

    return TestAppApp(
      localizationsDelegates: const {
        TestAppWindowsHomePageLocalizations.delegate,
      },
      supportedLocales: const [
        Locale('en'),
      ],
      routeInformationParser: router.defaultRouteParser(),
      routerDelegate: router.delegate(
        navigatorObservers: navigatorObserverBuilder ?? () => [],
      ),
    );
  }
}

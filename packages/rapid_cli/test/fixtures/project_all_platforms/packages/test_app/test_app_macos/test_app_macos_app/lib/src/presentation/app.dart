import 'package:test_app_macos_home_page/test_app_macos_home_page.dart';
import 'package:test_app_macos_routing/test_app_macos_routing.dart';
import 'package:test_app_ui_macos/test_app_ui_macos.dart';

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
        TestAppMacosHomePageLocalizations.delegate,
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

import 'package:test_app_android_home_page/test_app_android_home_page.dart';
import 'package:test_app_android_routing/test_app_android_routing.dart';
import 'package:test_app_ui_android/test_app_ui_android.dart';

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
        TestAppAndroidHomePageLocalizations.delegate,
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

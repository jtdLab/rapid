import 'package:project_android_android_home_page/project_android_android_home_page.dart';
import 'package:project_android_android_routing/project_android_android_routing.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';

class App extends StatelessWidget {
  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

  const App({
    super.key,
    this.navigatorObserverBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final router = Router();

    return ProjectAndroidApp(
      localizationsDelegates: const {
        ProjectAndroidAndroidHomePageLocalizations.delegate,
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

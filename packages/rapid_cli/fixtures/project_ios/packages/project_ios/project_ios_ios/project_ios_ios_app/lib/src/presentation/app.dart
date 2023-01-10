import 'package:project_ios_ios_home_page/project_ios_ios_home_page.dart';
import 'package:project_ios_ios_routing/project_ios_ios_routing.dart';
import 'package:project_ios_ui_ios/project_ios_ui_ios.dart';

class App extends StatelessWidget {
  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

  const App({
    super.key,
    this.navigatorObserverBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final router = Router();

    return ProjectIosApp(
      localizationsDelegates: const {
        ProjectIosIosHomePageLocalizations.delegate,
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

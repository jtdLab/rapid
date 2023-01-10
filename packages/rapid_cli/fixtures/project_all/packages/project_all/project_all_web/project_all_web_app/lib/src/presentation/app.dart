import 'package:project_all_web_home_page/project_all_web_home_page.dart';
import 'package:project_all_web_routing/project_all_web_routing.dart';
import 'package:project_all_ui_web/project_all_ui_web.dart';

class App extends StatelessWidget {
  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

  const App({
    super.key,
    this.navigatorObserverBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final router = Router();

    return ProjectAllApp(
      localizationsDelegates: const {
        ProjectAllWebHomePageLocalizations.delegate,
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

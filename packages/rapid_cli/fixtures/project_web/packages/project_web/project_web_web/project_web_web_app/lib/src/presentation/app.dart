import 'package:project_web_web_home_page/project_web_web_home_page.dart';
import 'package:project_web_web_routing/project_web_web_routing.dart';
import 'package:project_web_ui_web/project_web_ui_web.dart';

class App extends StatelessWidget {
  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

  const App({
    super.key,
    this.navigatorObserverBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final router = Router();

    return ProjectWebApp(
      localizationsDelegates: const {
        ProjectWebWebHomePageLocalizations.delegate,
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

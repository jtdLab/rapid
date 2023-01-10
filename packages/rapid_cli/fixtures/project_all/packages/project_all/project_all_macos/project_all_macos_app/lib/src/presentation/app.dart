import 'package:project_all_macos_home_page/project_all_macos_home_page.dart';
import 'package:project_all_macos_routing/project_all_macos_routing.dart';
import 'package:project_all_ui_macos/project_all_ui_macos.dart';

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
        ProjectAllMacosHomePageLocalizations.delegate,
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

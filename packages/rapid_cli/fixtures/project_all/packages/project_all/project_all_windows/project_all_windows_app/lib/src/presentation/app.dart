import 'package:project_all_windows_home_page/project_all_windows_home_page.dart';
import 'package:project_all_windows_routing/project_all_windows_routing.dart';
import 'package:project_all_ui_windows/project_all_ui_windows.dart';

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
        ProjectAllWindowsHomePageLocalizations.delegate,
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

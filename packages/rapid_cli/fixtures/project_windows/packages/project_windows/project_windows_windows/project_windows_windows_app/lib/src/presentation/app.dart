import 'package:project_windows_windows_home_page/project_windows_windows_home_page.dart';
import 'package:project_windows_windows_routing/project_windows_windows_routing.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';

class App extends StatelessWidget {
  final List<NavigatorObserver> Function()? navigatorObserverBuilder;

  const App({
    super.key,
    this.navigatorObserverBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final router = Router();

    return ProjectWindowsApp(
      localizationsDelegates: const {
        ProjectWindowsWindowsHomePageLocalizations.delegate,
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

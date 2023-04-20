import 'package:auto_route/auto_route.dart';
import 'package:project_windows_windows_home_page/project_windows_windows_home_page.dart';

/// Setup auto route which generates routing code.
///
/// For more info see: https://pub.dev/packages/auto_route
class Router extends RootStackRouter {
  final _homePageRouter = HomePageRouter();

  @override
  Map<String, PageFactory> get pagesMap => {
        ..._homePageRouter.pagesMap,
      };

  @override
  List<AutoRoute> get routes => [
        ..._homePageRouter.routes,
      ];
}

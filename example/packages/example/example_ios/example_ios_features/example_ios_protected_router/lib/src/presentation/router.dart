import 'package:auto_route/auto_route.dart';
import 'package:example_ios_home_page/example_ios_home_page.dart';

import 'router.gr.dart';

/// Setup auto route which generates routing code.
///
/// For more info see: https://pub.dev/packages/auto_route
@AutoRouterConfig()
class ProtectedRouter extends $ProtectedRouter {
  final _homePageRouter = HomePageRouter();

  @override
  Map<String, PageFactory> get pagesMap => {
        ...super.pagesMap,
        ..._homePageRouter.pagesMap,
      };

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: ProtectedRouterRoute.page,
          path: '/',
          children: [
            ..._homePageRouter.routes,
          ],
        ),
      ];
}

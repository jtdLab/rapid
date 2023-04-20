import 'package:auto_route/auto_route.dart';
import 'package:example_di/example_di.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_home_page/example_ios_home_page.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:injectable/injectable.dart';

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
          guards: [getIt<AuthGuard>()],
        ),
      ];
}

@ios
@lazySingleton
class AuthGuard extends AutoRouteGuard {
  final IAuthService _authService;
  final IPublicRouterNavigator _publicRouterNavigator;

  AuthGuard(this._authService, this._publicRouterNavigator);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authenticated = _authService.isAuthenticated();

    if (authenticated) {
      resolver.next(true);
    } else {
      _publicRouterNavigator.replace(router);
      resolver.next(false);
    }
  }
}

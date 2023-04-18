import 'package:auto_route/auto_route.dart';
import 'package:example_ios_login_page/example_ios_login_page.dart';
import 'package:example_ios_sign_up_page/example_ios_sign_up_page.dart';

import 'router.gr.dart';

/// Setup auto route which generates routing code.
///
/// For more info see: https://pub.dev/packages/auto_route
@AutoRouterConfig()
class PublicRouter extends $PublicRouter {
  final _loginPageRouter = LoginPageRouter();
  final _signUpPageRouter = SignUpPageRouter();

  @override
  Map<String, PageFactory> get pagesMap => {
        ...super.pagesMap,
        ..._loginPageRouter.pagesMap,
        ..._signUpPageRouter.pagesMap,
      };

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: PublicRouterRoute.page,
          path: '/auth',
          children: [
            ..._loginPageRouter.routes,
            ..._signUpPageRouter.routes,
          ],
        ),
      ];
}

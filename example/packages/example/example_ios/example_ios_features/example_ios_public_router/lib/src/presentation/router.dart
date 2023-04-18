import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

/// Setup auto route which generates routing code.
///
/// For more info see: https://pub.dev/packages/auto_route
@AutoRouterConfig()
class PublicRouterRouter extends $PublicRouterRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: PublicRouterRoute.page, path: '/'),
        // TODO setup the routes of this feature here
      ];
}

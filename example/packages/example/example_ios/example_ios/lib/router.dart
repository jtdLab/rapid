import 'package:auto_route/auto_route.dart';
import 'package:example_ios_protected_router/example_ios_protected_router.dart';
import 'package:example_ios_public_router/example_ios_public_router.dart';

/// Setup auto route which generates routing code.
///
/// For more info see: https://pub.dev/packages/auto_route
class Router extends RootStackRouter {
  final _publicRouter = PublicRouter();
  final _protectedRouter = ProtectedRouter();

  @override
  Map<String, PageFactory> get pagesMap => {
        ..._publicRouter.pagesMap,
        ..._protectedRouter.pagesMap,
      };

  @override
  List<AutoRoute> get routes => [
        ..._publicRouter.routes,
        ..._protectedRouter.routes,
      ];
}

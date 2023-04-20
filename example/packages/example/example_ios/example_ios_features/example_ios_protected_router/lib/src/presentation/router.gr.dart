// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:example_ios_protected_router/src/presentation/protected_router_page.dart'
    as _i1;

abstract class $ProtectedRouter extends _i2.RootStackRouter {
  $ProtectedRouter({super.navigatorKey});

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    ProtectedRouterRoute.name: (routeData) {
      return _i2.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ProtectedRouterPage(),
      );
    }
  };
}

/// generated route for
/// [_i1.ProtectedRouterPage]
class ProtectedRouterRoute extends _i2.PageRouteInfo<void> {
  const ProtectedRouterRoute({List<_i2.PageRouteInfo>? children})
      : super(
          ProtectedRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProtectedRouterRoute';

  static const _i2.PageInfo<void> page = _i2.PageInfo<void>(name);
}

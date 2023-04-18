// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:example_ios_sign_up_page/src/presentation/sign_up_page.dart'
    as _i1;

abstract class $SignUpPageRouter extends _i2.RootStackRouter {
  $SignUpPageRouter({super.navigatorKey});

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    SignUpRoute.name: (routeData) {
      return _i2.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.SignUpPage(),
      );
    }
  };
}

/// generated route for
/// [_i1.SignUpPage]
class SignUpRoute extends _i2.PageRouteInfo<void> {
  const SignUpRoute({List<_i2.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i2.PageInfo<void> page = _i2.PageInfo<void>(name);
}

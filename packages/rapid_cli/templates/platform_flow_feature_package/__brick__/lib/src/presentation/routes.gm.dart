// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:{{project_name}}_{{platform}}_{{name.snakeCase()}}/src/presentation/{{name.snakeCase()}}.dart'
    as _i1;

abstract class ${{name.pascalCase()}}Module extends _i2.AutoRouterModule {

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    {{name.pascalCase()}}Route.name: (routeData) {
      return _i2.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.{{name.pascalCase()}}(),
      );
    }
  };
}

/// generated route for
/// [_i1.{{name.pascalCase()}}]
class {{name.pascalCase()}}Route extends _i2.PageRouteInfo<void> {
  const {{name.pascalCase()}}Route({List<_i2.PageRouteInfo>? children})
      : super(
          {{name.pascalCase()}}Route.name,
          initialChildren: children,
        );

  static const String name = '{{name.pascalCase()}}Route';

  static const _i2.PageInfo<void> page = _i2.PageInfo<void>(name);
}

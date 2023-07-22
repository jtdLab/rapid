import 'package:auto_route/auto_route.dart';

import 'routes.gm.dart';

/// Setup auto route which generates routing code.
///
/// For more info see: https://pub.dev/packages/auto_route#including-microexternal-packages
@AutoRouterConfig.module(
  replaceInRouteName: null,
)
class {{name.pascalCase()}}Module extends ${{name.pascalCase()}}Module {}
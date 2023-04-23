import 'package:auto_route/auto_route.dart';
import 'package:example_di/example_di.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import 'router.gr.dart';

@ios
@LazySingleton(as: IProtectedRouterNavigator)
class ProtectedRouterNavigator implements IProtectedRouterNavigator {
  @visibleForTesting
  StackRouter? routerOverrides;

  @override
  void replace(BuildContext context) {
    (routerOverrides ?? context.router).replace(const ProtectedRouterRoute());
  }
}

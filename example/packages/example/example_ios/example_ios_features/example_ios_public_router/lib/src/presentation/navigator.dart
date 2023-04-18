import 'package:auto_route/auto_route.dart';
import 'package:example_di/example_di.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:injectable/injectable.dart';

import 'router.gr.dart';

@ios
@LazySingleton(as: IPublicRouterNavigator)
class PublicRouterNavigator implements IPublicRouterNavigator {
  @override
  void replace(StackRouter router) {
    router.replace(const PublicRouterRoute());
  }
}

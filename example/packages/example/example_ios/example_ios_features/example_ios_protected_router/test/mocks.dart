import 'package:auto_route/auto_route.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:example_ios_protected_router/src/presentation/router.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthGuard extends Mock implements AuthGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    resolver.next(true);
  }
}

class MockAuthService extends Mock implements IAuthService {}

class MockPublicRouterNavigator extends Mock
    implements IPublicRouterNavigator {}

class MockNavigationResolver extends Mock implements NavigationResolver {}

class MockStackRouter extends Mock implements StackRouter {}

class FakeBuildContext extends Fake implements BuildContext {}

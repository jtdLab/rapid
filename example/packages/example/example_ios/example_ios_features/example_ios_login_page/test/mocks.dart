import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_login_page/src/application/application.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements IAuthService {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockProtectedRouterNavigator extends Mock
    implements IProtectedRouterNavigator {}

class FakeBuildContext extends Fake implements BuildContext {}

class MockSignUpPageNavigator extends Mock implements ISignUpPageNavigator {}

class MockStackRouter extends Mock implements StackRouter {}

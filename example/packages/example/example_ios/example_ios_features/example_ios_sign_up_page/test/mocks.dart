import 'package:bloc_test/bloc_test.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:example_ios_sign_up_page/src/application/application.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthService extends Mock implements IAuthService {}

class MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

class MockProtectedRouterNavigator extends Mock
    implements IProtectedRouterNavigator {}

class FakeBuildContext extends Fake implements BuildContext {}

class MockLoginPageNavigator extends Mock implements ILoginPageNavigator {}

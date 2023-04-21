import 'package:bloc_test/bloc_test.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_login_page/example_ios_login_page.dart';
import 'package:example_ios_sign_up_page/example_ios_sign_up_page.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {
  MockLoginBloc() {
    whenListen(
      this,
      const Stream<LoginState>.empty(),
      initialState: LoginState.initial(
        username: Username.empty(),
        password: Password.empty(),
      ),
    );
  }
}

class MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {
  MockSignUpBloc() {
    whenListen(
      this,
      const Stream<SignUpState>.empty(),
      initialState: SignUpState.initial(
        emailAddress: EmailAddress.empty(),
        username: Username.empty(),
        password: Password.empty(),
        passwordAgain: Password.empty(),
        showErrorMessages: false,
      ),
    );
  }
}

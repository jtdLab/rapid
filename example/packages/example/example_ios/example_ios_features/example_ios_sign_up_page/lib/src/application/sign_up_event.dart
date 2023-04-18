part of 'sign_up_bloc.dart';

@freezed
class SignUpEvent with _$SignUpEvent {
  const factory SignUpEvent.emailChanged({
    required String newEmail,
  }) = _EmailChanged;
  const factory SignUpEvent.usernameChanged({
    required String newUsername,
  }) = _UsernameChanged;
  const factory SignUpEvent.passwordChanged({
    required String newPassword,
  }) = _PasswordChanged;
  const factory SignUpEvent.passwordAgainChanged({
    required String newPasswordAgain,
  }) = _PasswordAgainChanged;
  const factory SignUpEvent.signUpPressed() = _SignUpPressed;
}

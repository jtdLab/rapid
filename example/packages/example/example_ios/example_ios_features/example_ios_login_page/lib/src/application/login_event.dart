part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.usernameChanged({
    required String newUsername,
  }) = _UsernameChanged;
  const factory LoginEvent.passwordChanged({
    required String newPassword,
  }) = _PasswordChanged;
  const factory LoginEvent.loginPressed() = _LoginPressed;
}

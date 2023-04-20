part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial({
    required Username username,
    required Password password,
  }) = LoginInitial;
  const factory LoginState.loadInProgress() = LoginLoadInProgress;
  const factory LoginState.loadSuccess() = LoginLoadSuccess;
  const factory LoginState.loadFailure({
    required AuthServiceLoginWithUsernameAndPasswordFailure failure,
  }) = LoginLoadFailure;
}

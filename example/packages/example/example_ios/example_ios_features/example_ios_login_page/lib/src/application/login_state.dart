part of 'login_bloc.dart';

@freezed
class LoginState<T> with _$LoginState<T> {
  const factory LoginState.initial({
    required Username username,
    required Password password,
  }) = LoginInitial;
  const factory LoginState.loadInProgress() = LoginLoadInProgress;
  const factory LoginState.loadSuccess() = LoginLoadSuccess;
  const factory LoginState.loadFailure({
    required T failure,
  }) = LoginLoadFailure<T>;
}

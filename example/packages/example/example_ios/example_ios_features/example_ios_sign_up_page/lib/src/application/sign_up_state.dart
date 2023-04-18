part of 'sign_up_bloc.dart';

@freezed
class SignUpState<T> with _$SignUpState<T> {
  const factory SignUpState.initial({
    required EmailAddress email,
    required Username username,
    required Password password,
    required Password passwordAgain,
    required bool showErrorMessages,
  }) = SignUpInitial;
  const factory SignUpState.loadInProgress() = SignUpLoadInProgress;
  const factory SignUpState.loadSuccess() = SignUpLoadSuccess;
  const factory SignUpState.loadFailure({
    required T failure,
  }) = SignUpLoadFailure<T>;
}

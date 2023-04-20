part of 'sign_up_bloc.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.initial({
    required EmailAddress emailAddress,
    required Username username,
    required Password password,
    required Password passwordAgain,
    required bool showErrorMessages,
  }) = SignUpInitial;
  const factory SignUpState.loadInProgress() = SignUpLoadInProgress;
  const factory SignUpState.loadSuccess() = SignUpLoadSuccess;
  const factory SignUpState.loadFailure({
    required AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure,
  }) = SignUpLoadFailure;
}

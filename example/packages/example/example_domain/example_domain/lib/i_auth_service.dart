import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'email_address.dart';
import 'password.dart';
import 'username.dart';

part 'i_auth_service.freezed.dart';

// Service to handle user authentication.
abstract class IAuthService {
  bool isAuthenticated();

  /// Log in with [username] and [password].
  Future<Either<AuthServiceLoginInWithUsernameAndPasswordFailure, Unit>>
      loginInWithUsernameAndPassword({
    required Username username,
    required Password password,
  });

  /// Sign out.
  Future<Either<AuthServiceSignOutFailure, Unit>> signOut();

  /// Sign up with [emailAddress], [username] and [password].
  Future<Either<AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure, Unit>>
      signUpWithEmailAndUsernameAndPassword({
    required EmailAddress emailAddress,
    required Username username,
    required Password password,
  });
}

/// Failure union that belongs to [IAuthService.loginInWithUsernameAndPassword].
@freezed
class AuthServiceLoginInWithUsernameAndPasswordFailure
    with _$AuthServiceLoginInWithUsernameAndPasswordFailure {
  const factory AuthServiceLoginInWithUsernameAndPasswordFailure.serverError() =
      _AuthServiceLoginInWithUsernameAndPasswordServerError;
  const factory AuthServiceLoginInWithUsernameAndPasswordFailure.invalidUsernameAndPasswordCombination() =
      _AuthServiceLoginInWithUsernameAndPasswordInvalidUsernameAndPasswordCombination;
}

/// Failure union that belongs to [IAuthService.signOut].
@freezed
class AuthServiceSignOutFailure with _$AuthServiceSignOutFailure {
  const factory AuthServiceSignOutFailure.serverError() =
      _AuthServiceSignOutServerError;
}

/// Failure union that belongs to [IAuthService.signUpWithEmailAndUsernameAndPassword].
@freezed
class AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
    with _$AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure {
  const factory AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure.serverError() =
      _AuthServiceSignUpWithEmailAndUsernameAndPasswordServerError;
  const factory AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure.invalidEmail() =
      _AuthServiceSignUpWithEmailAndUsernameAndPasswordInvalidEmail;
  const factory AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure.invalidUsername() =
      _AuthServiceSignUpWithEmailAndUsernameAndPasswordInvalidUsername;
  const factory AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure.invalidPassword() =
      _AuthServiceSignUpWithEmailAndUsernameAndPasswordInvalidPassword;
  const factory AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure.emailAlreadyInUse() =
      _AuthServiceSignUpWithEmailAndUsernameAndPasswordEmailAlreadyInUse;
  const factory AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure.usernameAlreadyInUse() =
      _AuthServiceSignUpWithEmailAndUsernameAndPasswordUsernameAlreadyInUse;
}

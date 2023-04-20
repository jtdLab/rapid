import 'package:dartz/dartz.dart';
import 'package:example_domain/email_address.dart';
import 'package:example_domain/i_auth_service.dart';
import 'package:example_domain/password.dart';
import 'package:example_domain/username.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// Fake implementation of [IAuthService].
@dev
@LazySingleton(as: IAuthService)
class FakeAuthService implements IAuthService {
  bool hasNetworkConnection = true;
  bool emailAlreadyInUse = false;
  bool usernameAlreadyInUse = false;

  final BehaviorSubject<bool> _authenticatedController;

  FakeAuthService() : _authenticatedController = BehaviorSubject.seeded(false);

  @override
  bool isAuthenticated() => _authenticatedController.value;

  @override
  Future<Either<AuthServiceLoginWithUsernameAndPasswordFailure, Unit>>
      loginWithUsernameAndPassword({
    required Username username,
    required Password password,
  }) async {
    if (hasNetworkConnection) {
      if (!username.isValid() || !password.isValid()) {
        return left(
          const AuthServiceLoginWithUsernameAndPasswordFailure
              .invalidUsernameAndPasswordCombination(),
        );
      }

      _authenticatedController.add(true);
      return right(unit);
    }

    return left(AuthServiceLoginWithUsernameAndPasswordFailure.serverError());
  }

  @override
  Future<Either<AuthServiceSignOutFailure, Unit>> signOut() async {
    if (hasNetworkConnection) {
      _authenticatedController.add(false);
      return right(unit);
    }

    return left(const AuthServiceSignOutFailure.serverError());
  }

  @override
  Future<Either<AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure, Unit>>
      signUpWithEmailAndUsernameAndPassword({
    required EmailAddress emailAddress,
    required Username username,
    required Password password,
  }) async {
    if (hasNetworkConnection) {
      if (!emailAddress.isValid()) {
        return left(
          const AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
              .invalidEmail(),
        );
      }

      if (!username.isValid()) {
        return left(
          const AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
              .invalidUsername(),
        );
      }

      if (!password.isValid()) {
        return left(
          const AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
              .invalidPassword(),
        );
      }

      if (emailAlreadyInUse) {
        return left(
          const AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
              .emailAlreadyInUse(),
        );
      }

      if (usernameAlreadyInUse) {
        return left(
          const AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
              .usernameAlreadyInUse(),
        );
      }

      _authenticatedController.add(true);
      return right(unit);
    }

    return left(
      const AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
          .serverError(),
    );
  }
}

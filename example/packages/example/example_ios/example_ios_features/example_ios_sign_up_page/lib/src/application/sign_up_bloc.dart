import 'package:bloc/bloc.dart';
import 'package:example_di/example_di.dart';
import 'package:example_domain/example_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_up_bloc.freezed.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

@ios
@injectable
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final IAuthService _authService;

  SignUpBloc(
    this._authService,
  ) : super(
          // Set initial state
          SignUpState.initial(
            emailAddress: EmailAddress.empty(),
            username: Username.empty(),
            password: Password.empty(),
            passwordAgain: Password.empty(),
            showErrorMessages: false,
          ),
        ) {
    // Register event handlers
    on<_EmailAddressChanged>(_handleEmailAddressChanged);
    on<_UsernameChanged>(_handleUsernameChanged);
    on<_PasswordChanged>(_handlePasswordChanged);
    on<_PasswordAgainChanged>(_handlePasswordAgainChanged);
    on<_SignUpPressed>((_, emit) async => _handleSignUpPressed(emit));
  }

  /// Handle incoming [_EmailAddressChanged] event.
  void _handleEmailAddressChanged(
    _EmailAddressChanged event,
    Emitter<SignUpState> emit,
  ) {
    state.mapOrNull(
      initial: (initial) {
        emit(
          initial.copyWith(emailAddress: EmailAddress(event.newEmailAddress)),
        );
      },
    );
  }

  /// Handle incoming [_UsernameChanged] event.
  void _handleUsernameChanged(
    _UsernameChanged event,
    Emitter<SignUpState> emit,
  ) {
    state.mapOrNull(
      initial: (initial) {
        emit(initial.copyWith(username: Username(event.newUsername)));
      },
    );
  }

  /// Handle incoming [_PasswordChanged] event.
  void _handlePasswordChanged(
    _PasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    state.mapOrNull(
      initial: (initial) {
        emit(initial.copyWith(password: Password(event.newPassword)));
      },
    );
  }

  /// Handle incoming [_PasswordAgainChanged] event.
  void _handlePasswordAgainChanged(
    _PasswordAgainChanged event,
    Emitter<SignUpState> emit,
  ) {
    state.mapOrNull(
      initial: (initial) {
        emit(initial.copyWith(passwordAgain: Password(event.newPasswordAgain)));
      },
    );
  }

  /// Handle incoming [_SignUpPressed] event.
  Future<void> _handleSignUpPressed(
    Emitter<SignUpState> emit,
  ) async {
    await state.mapOrNull(
      initial: (initial) async {
        final isEmailAddressValid = initial.emailAddress.isValid();
        final isUsernameValid = initial.username.isValid();
        final isPasswordValid = initial.password.isValid();
        final isPasswordAgainValid = initial.passwordAgain.isValid();
        final passwordsMatch = initial.password == initial.passwordAgain;

        if (isEmailAddressValid &&
            isUsernameValid &&
            isPasswordValid &&
            isPasswordAgainValid &&
            passwordsMatch) {
          emit(const SignUpState.loadInProgress());

          await Future.delayed(const Duration(milliseconds: 500));

          final signUpResult =
              await _authService.signUpWithEmailAndUsernameAndPassword(
            emailAddress: initial.emailAddress,
            username: initial.username,
            password: initial.password,
          );
          signUpResult.fold(
            (failure) {
              emit(SignUpState.loadFailure(failure: failure));
              emit(initial.copyWith(showErrorMessages: true));
            },
            (_) {
              emit(const SignUpState.loadSuccess());
            },
          );
        } else {
          emit(initial.copyWith(showErrorMessages: true));
        }
      },
    );
  }
}

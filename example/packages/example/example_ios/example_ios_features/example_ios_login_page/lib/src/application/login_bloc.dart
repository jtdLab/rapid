import 'package:bloc/bloc.dart';
import 'package:example_di/example_di.dart';
import 'package:example_domain/example_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

@ios
@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IAuthService _authService;

  LoginBloc(this._authService)
      : super(
          // Set initial state
          LoginState.initial(
            username: Username.empty(),
            password: Password.empty(),
          ),
        ) {
    // Register handlers
    on<_UsernameChanged>(_handleUsernameChanged);
    on<_PasswordChanged>(_handlePasswordChanged);
    on<_LoginPressed>((_, emit) async => _handleLoginPressed(emit));
  }

  /// Handle incoming [_UsernameChanged] event.
  void _handleUsernameChanged(
    _UsernameChanged event,
    Emitter<LoginState> emit,
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
    Emitter<LoginState> emit,
  ) {
    state.mapOrNull(
      initial: (initial) {
        emit(initial.copyWith(password: Password(event.newPassword)));
      },
    );
  }

  /// Handle incoming [_LoginPressed] event.
  Future<void> _handleLoginPressed(
    Emitter<LoginState> emit,
  ) async {
    await state.mapOrNull(
      initial: (initial) async {
        await state.mapOrNull(
          initial: (initial) async {
            emit(const LoginState.loadInProgress());

            // this adds some min. loading
            await Future.delayed(const Duration(milliseconds: 500));

            final loginResult = await _authService.loginWithUsernameAndPassword(
              username: initial.username,
              password: initial.password,
            );
            loginResult.fold(
              (failure) {
                emit(LoginState.loadFailure(failure: failure));
                emit(initial);
              },
              (_) {
                emit(const LoginState.loadSuccess());
              },
            );
          },
        );
      },
    );
  }
}

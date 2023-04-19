// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LoginEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function() loginPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function()? loginPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function()? loginPressed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_LoginPressed value) loginPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_LoginPressed value)? loginPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UsernameChanged value)? usernameChanged,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_LoginPressed value)? loginPressed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginEventCopyWith<$Res> {
  factory $LoginEventCopyWith(
          LoginEvent value, $Res Function(LoginEvent) then) =
      _$LoginEventCopyWithImpl<$Res, LoginEvent>;
}

/// @nodoc
class _$LoginEventCopyWithImpl<$Res, $Val extends LoginEvent>
    implements $LoginEventCopyWith<$Res> {
  _$LoginEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_UsernameChangedCopyWith<$Res> {
  factory _$$_UsernameChangedCopyWith(
          _$_UsernameChanged value, $Res Function(_$_UsernameChanged) then) =
      __$$_UsernameChangedCopyWithImpl<$Res>;
  @useResult
  $Res call({String newUsername});
}

/// @nodoc
class __$$_UsernameChangedCopyWithImpl<$Res>
    extends _$LoginEventCopyWithImpl<$Res, _$_UsernameChanged>
    implements _$$_UsernameChangedCopyWith<$Res> {
  __$$_UsernameChangedCopyWithImpl(
      _$_UsernameChanged _value, $Res Function(_$_UsernameChanged) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newUsername = null,
  }) {
    return _then(_$_UsernameChanged(
      newUsername: null == newUsername
          ? _value.newUsername
          : newUsername // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_UsernameChanged implements _UsernameChanged {
  const _$_UsernameChanged({required this.newUsername});

  @override
  final String newUsername;

  @override
  String toString() {
    return 'LoginEvent.usernameChanged(newUsername: $newUsername)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UsernameChanged &&
            (identical(other.newUsername, newUsername) ||
                other.newUsername == newUsername));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newUsername);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UsernameChangedCopyWith<_$_UsernameChanged> get copyWith =>
      __$$_UsernameChangedCopyWithImpl<_$_UsernameChanged>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function() loginPressed,
  }) {
    return usernameChanged(newUsername);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function()? loginPressed,
  }) {
    return usernameChanged?.call(newUsername);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function()? loginPressed,
    required TResult orElse(),
  }) {
    if (usernameChanged != null) {
      return usernameChanged(newUsername);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_LoginPressed value) loginPressed,
  }) {
    return usernameChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_LoginPressed value)? loginPressed,
  }) {
    return usernameChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UsernameChanged value)? usernameChanged,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_LoginPressed value)? loginPressed,
    required TResult orElse(),
  }) {
    if (usernameChanged != null) {
      return usernameChanged(this);
    }
    return orElse();
  }
}

abstract class _UsernameChanged implements LoginEvent {
  const factory _UsernameChanged({required final String newUsername}) =
      _$_UsernameChanged;

  String get newUsername;
  @JsonKey(ignore: true)
  _$$_UsernameChangedCopyWith<_$_UsernameChanged> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_PasswordChangedCopyWith<$Res> {
  factory _$$_PasswordChangedCopyWith(
          _$_PasswordChanged value, $Res Function(_$_PasswordChanged) then) =
      __$$_PasswordChangedCopyWithImpl<$Res>;
  @useResult
  $Res call({String newPassword});
}

/// @nodoc
class __$$_PasswordChangedCopyWithImpl<$Res>
    extends _$LoginEventCopyWithImpl<$Res, _$_PasswordChanged>
    implements _$$_PasswordChangedCopyWith<$Res> {
  __$$_PasswordChangedCopyWithImpl(
      _$_PasswordChanged _value, $Res Function(_$_PasswordChanged) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newPassword = null,
  }) {
    return _then(_$_PasswordChanged(
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PasswordChanged implements _PasswordChanged {
  const _$_PasswordChanged({required this.newPassword});

  @override
  final String newPassword;

  @override
  String toString() {
    return 'LoginEvent.passwordChanged(newPassword: $newPassword)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PasswordChanged &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newPassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PasswordChangedCopyWith<_$_PasswordChanged> get copyWith =>
      __$$_PasswordChangedCopyWithImpl<_$_PasswordChanged>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function() loginPressed,
  }) {
    return passwordChanged(newPassword);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function()? loginPressed,
  }) {
    return passwordChanged?.call(newPassword);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function()? loginPressed,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(newPassword);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_LoginPressed value) loginPressed,
  }) {
    return passwordChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_LoginPressed value)? loginPressed,
  }) {
    return passwordChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UsernameChanged value)? usernameChanged,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_LoginPressed value)? loginPressed,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(this);
    }
    return orElse();
  }
}

abstract class _PasswordChanged implements LoginEvent {
  const factory _PasswordChanged({required final String newPassword}) =
      _$_PasswordChanged;

  String get newPassword;
  @JsonKey(ignore: true)
  _$$_PasswordChangedCopyWith<_$_PasswordChanged> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_LoginPressedCopyWith<$Res> {
  factory _$$_LoginPressedCopyWith(
          _$_LoginPressed value, $Res Function(_$_LoginPressed) then) =
      __$$_LoginPressedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_LoginPressedCopyWithImpl<$Res>
    extends _$LoginEventCopyWithImpl<$Res, _$_LoginPressed>
    implements _$$_LoginPressedCopyWith<$Res> {
  __$$_LoginPressedCopyWithImpl(
      _$_LoginPressed _value, $Res Function(_$_LoginPressed) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_LoginPressed implements _LoginPressed {
  const _$_LoginPressed();

  @override
  String toString() {
    return 'LoginEvent.loginPressed()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_LoginPressed);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function() loginPressed,
  }) {
    return loginPressed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function()? loginPressed,
  }) {
    return loginPressed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function()? loginPressed,
    required TResult orElse(),
  }) {
    if (loginPressed != null) {
      return loginPressed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_LoginPressed value) loginPressed,
  }) {
    return loginPressed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_LoginPressed value)? loginPressed,
  }) {
    return loginPressed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UsernameChanged value)? usernameChanged,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_LoginPressed value)? loginPressed,
    required TResult orElse(),
  }) {
    if (loginPressed != null) {
      return loginPressed(this);
    }
    return orElse();
  }
}

abstract class _LoginPressed implements LoginEvent {
  const factory _LoginPressed() = _$_LoginPressed;
}

/// @nodoc
mixin _$LoginState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Username username, Password password) initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(
            AuthServiceLoginWithUsernameAndPasswordFailure failure)
        loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Username username, Password password)? initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(AuthServiceLoginWithUsernameAndPasswordFailure failure)?
        loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Username username, Password password)? initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(AuthServiceLoginWithUsernameAndPasswordFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginInitial value) initial,
    required TResult Function(LoginLoadInProgress value) loadInProgress,
    required TResult Function(LoginLoadSuccess value) loadSuccess,
    required TResult Function(LoginLoadFailure value) loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginInitial value)? initial,
    TResult? Function(LoginLoadInProgress value)? loadInProgress,
    TResult? Function(LoginLoadSuccess value)? loadSuccess,
    TResult? Function(LoginLoadFailure value)? loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginInitial value)? initial,
    TResult Function(LoginLoadInProgress value)? loadInProgress,
    TResult Function(LoginLoadSuccess value)? loadSuccess,
    TResult Function(LoginLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginStateCopyWith<$Res> {
  factory $LoginStateCopyWith(
          LoginState value, $Res Function(LoginState) then) =
      _$LoginStateCopyWithImpl<$Res, LoginState>;
}

/// @nodoc
class _$LoginStateCopyWithImpl<$Res, $Val extends LoginState>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoginInitialCopyWith<$Res> {
  factory _$$LoginInitialCopyWith(
          _$LoginInitial value, $Res Function(_$LoginInitial) then) =
      __$$LoginInitialCopyWithImpl<$Res>;
  @useResult
  $Res call({Username username, Password password});
}

/// @nodoc
class __$$LoginInitialCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginInitial>
    implements _$$LoginInitialCopyWith<$Res> {
  __$$LoginInitialCopyWithImpl(
      _$LoginInitial _value, $Res Function(_$LoginInitial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
  }) {
    return _then(_$LoginInitial(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as Username,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as Password,
    ));
  }
}

/// @nodoc

class _$LoginInitial implements LoginInitial {
  const _$LoginInitial({required this.username, required this.password});

  @override
  final Username username;
  @override
  final Password password;

  @override
  String toString() {
    return 'LoginState.initial(username: $username, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginInitial &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, username, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginInitialCopyWith<_$LoginInitial> get copyWith =>
      __$$LoginInitialCopyWithImpl<_$LoginInitial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Username username, Password password) initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(
            AuthServiceLoginWithUsernameAndPasswordFailure failure)
        loadFailure,
  }) {
    return initial(username, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Username username, Password password)? initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(AuthServiceLoginWithUsernameAndPasswordFailure failure)?
        loadFailure,
  }) {
    return initial?.call(username, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Username username, Password password)? initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(AuthServiceLoginWithUsernameAndPasswordFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(username, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginInitial value) initial,
    required TResult Function(LoginLoadInProgress value) loadInProgress,
    required TResult Function(LoginLoadSuccess value) loadSuccess,
    required TResult Function(LoginLoadFailure value) loadFailure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginInitial value)? initial,
    TResult? Function(LoginLoadInProgress value)? loadInProgress,
    TResult? Function(LoginLoadSuccess value)? loadSuccess,
    TResult? Function(LoginLoadFailure value)? loadFailure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginInitial value)? initial,
    TResult Function(LoginLoadInProgress value)? loadInProgress,
    TResult Function(LoginLoadSuccess value)? loadSuccess,
    TResult Function(LoginLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class LoginInitial implements LoginState {
  const factory LoginInitial(
      {required final Username username,
      required final Password password}) = _$LoginInitial;

  Username get username;
  Password get password;
  @JsonKey(ignore: true)
  _$$LoginInitialCopyWith<_$LoginInitial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoginLoadInProgressCopyWith<$Res> {
  factory _$$LoginLoadInProgressCopyWith(_$LoginLoadInProgress value,
          $Res Function(_$LoginLoadInProgress) then) =
      __$$LoginLoadInProgressCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginLoadInProgressCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginLoadInProgress>
    implements _$$LoginLoadInProgressCopyWith<$Res> {
  __$$LoginLoadInProgressCopyWithImpl(
      _$LoginLoadInProgress _value, $Res Function(_$LoginLoadInProgress) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoginLoadInProgress implements LoginLoadInProgress {
  const _$LoginLoadInProgress();

  @override
  String toString() {
    return 'LoginState.loadInProgress()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginLoadInProgress);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Username username, Password password) initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(
            AuthServiceLoginWithUsernameAndPasswordFailure failure)
        loadFailure,
  }) {
    return loadInProgress();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Username username, Password password)? initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(AuthServiceLoginWithUsernameAndPasswordFailure failure)?
        loadFailure,
  }) {
    return loadInProgress?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Username username, Password password)? initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(AuthServiceLoginWithUsernameAndPasswordFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) {
    if (loadInProgress != null) {
      return loadInProgress();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginInitial value) initial,
    required TResult Function(LoginLoadInProgress value) loadInProgress,
    required TResult Function(LoginLoadSuccess value) loadSuccess,
    required TResult Function(LoginLoadFailure value) loadFailure,
  }) {
    return loadInProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginInitial value)? initial,
    TResult? Function(LoginLoadInProgress value)? loadInProgress,
    TResult? Function(LoginLoadSuccess value)? loadSuccess,
    TResult? Function(LoginLoadFailure value)? loadFailure,
  }) {
    return loadInProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginInitial value)? initial,
    TResult Function(LoginLoadInProgress value)? loadInProgress,
    TResult Function(LoginLoadSuccess value)? loadSuccess,
    TResult Function(LoginLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadInProgress != null) {
      return loadInProgress(this);
    }
    return orElse();
  }
}

abstract class LoginLoadInProgress implements LoginState {
  const factory LoginLoadInProgress() = _$LoginLoadInProgress;
}

/// @nodoc
abstract class _$$LoginLoadSuccessCopyWith<$Res> {
  factory _$$LoginLoadSuccessCopyWith(
          _$LoginLoadSuccess value, $Res Function(_$LoginLoadSuccess) then) =
      __$$LoginLoadSuccessCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginLoadSuccessCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginLoadSuccess>
    implements _$$LoginLoadSuccessCopyWith<$Res> {
  __$$LoginLoadSuccessCopyWithImpl(
      _$LoginLoadSuccess _value, $Res Function(_$LoginLoadSuccess) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoginLoadSuccess implements LoginLoadSuccess {
  const _$LoginLoadSuccess();

  @override
  String toString() {
    return 'LoginState.loadSuccess()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginLoadSuccess);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Username username, Password password) initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(
            AuthServiceLoginWithUsernameAndPasswordFailure failure)
        loadFailure,
  }) {
    return loadSuccess();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Username username, Password password)? initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(AuthServiceLoginWithUsernameAndPasswordFailure failure)?
        loadFailure,
  }) {
    return loadSuccess?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Username username, Password password)? initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(AuthServiceLoginWithUsernameAndPasswordFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) {
    if (loadSuccess != null) {
      return loadSuccess();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginInitial value) initial,
    required TResult Function(LoginLoadInProgress value) loadInProgress,
    required TResult Function(LoginLoadSuccess value) loadSuccess,
    required TResult Function(LoginLoadFailure value) loadFailure,
  }) {
    return loadSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginInitial value)? initial,
    TResult? Function(LoginLoadInProgress value)? loadInProgress,
    TResult? Function(LoginLoadSuccess value)? loadSuccess,
    TResult? Function(LoginLoadFailure value)? loadFailure,
  }) {
    return loadSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginInitial value)? initial,
    TResult Function(LoginLoadInProgress value)? loadInProgress,
    TResult Function(LoginLoadSuccess value)? loadSuccess,
    TResult Function(LoginLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadSuccess != null) {
      return loadSuccess(this);
    }
    return orElse();
  }
}

abstract class LoginLoadSuccess implements LoginState {
  const factory LoginLoadSuccess() = _$LoginLoadSuccess;
}

/// @nodoc
abstract class _$$LoginLoadFailureCopyWith<$Res> {
  factory _$$LoginLoadFailureCopyWith(
          _$LoginLoadFailure value, $Res Function(_$LoginLoadFailure) then) =
      __$$LoginLoadFailureCopyWithImpl<$Res>;
  @useResult
  $Res call({AuthServiceLoginWithUsernameAndPasswordFailure failure});

  $AuthServiceLoginWithUsernameAndPasswordFailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$LoginLoadFailureCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginLoadFailure>
    implements _$$LoginLoadFailureCopyWith<$Res> {
  __$$LoginLoadFailureCopyWithImpl(
      _$LoginLoadFailure _value, $Res Function(_$LoginLoadFailure) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
  }) {
    return _then(_$LoginLoadFailure(
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as AuthServiceLoginWithUsernameAndPasswordFailure,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $AuthServiceLoginWithUsernameAndPasswordFailureCopyWith<$Res> get failure {
    return $AuthServiceLoginWithUsernameAndPasswordFailureCopyWith<$Res>(
        _value.failure, (value) {
      return _then(_value.copyWith(failure: value));
    });
  }
}

/// @nodoc

class _$LoginLoadFailure implements LoginLoadFailure {
  const _$LoginLoadFailure({required this.failure});

  @override
  final AuthServiceLoginWithUsernameAndPasswordFailure failure;

  @override
  String toString() {
    return 'LoginState.loadFailure(failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginLoadFailure &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginLoadFailureCopyWith<_$LoginLoadFailure> get copyWith =>
      __$$LoginLoadFailureCopyWithImpl<_$LoginLoadFailure>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Username username, Password password) initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(
            AuthServiceLoginWithUsernameAndPasswordFailure failure)
        loadFailure,
  }) {
    return loadFailure(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Username username, Password password)? initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(AuthServiceLoginWithUsernameAndPasswordFailure failure)?
        loadFailure,
  }) {
    return loadFailure?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Username username, Password password)? initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(AuthServiceLoginWithUsernameAndPasswordFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) {
    if (loadFailure != null) {
      return loadFailure(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginInitial value) initial,
    required TResult Function(LoginLoadInProgress value) loadInProgress,
    required TResult Function(LoginLoadSuccess value) loadSuccess,
    required TResult Function(LoginLoadFailure value) loadFailure,
  }) {
    return loadFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginInitial value)? initial,
    TResult? Function(LoginLoadInProgress value)? loadInProgress,
    TResult? Function(LoginLoadSuccess value)? loadSuccess,
    TResult? Function(LoginLoadFailure value)? loadFailure,
  }) {
    return loadFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginInitial value)? initial,
    TResult Function(LoginLoadInProgress value)? loadInProgress,
    TResult Function(LoginLoadSuccess value)? loadSuccess,
    TResult Function(LoginLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadFailure != null) {
      return loadFailure(this);
    }
    return orElse();
  }
}

abstract class LoginLoadFailure implements LoginState {
  const factory LoginLoadFailure(
      {required final AuthServiceLoginWithUsernameAndPasswordFailure
          failure}) = _$LoginLoadFailure;

  AuthServiceLoginWithUsernameAndPasswordFailure get failure;
  @JsonKey(ignore: true)
  _$$LoginLoadFailureCopyWith<_$LoginLoadFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

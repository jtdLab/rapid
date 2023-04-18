// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SignUpEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newEmail) emailChanged,
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function(String newPasswordAgain) passwordAgainChanged,
    required TResult Function() signUpPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newEmail)? emailChanged,
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function(String newPasswordAgain)? passwordAgainChanged,
    TResult? Function()? signUpPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newEmail)? emailChanged,
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function(String newPasswordAgain)? passwordAgainChanged,
    TResult Function()? signUpPressed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EmailChanged value) emailChanged,
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordAgainChanged value) passwordAgainChanged,
    required TResult Function(_SignUpPressed value) signUpPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EmailChanged value)? emailChanged,
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult? Function(_SignUpPressed value)? signUpPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EmailChanged value)? emailChanged,
    TResult Function(_UsernameChanged value)? usernameChanged,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult Function(_SignUpPressed value)? signUpPressed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpEventCopyWith<$Res> {
  factory $SignUpEventCopyWith(
          SignUpEvent value, $Res Function(SignUpEvent) then) =
      _$SignUpEventCopyWithImpl<$Res, SignUpEvent>;
}

/// @nodoc
class _$SignUpEventCopyWithImpl<$Res, $Val extends SignUpEvent>
    implements $SignUpEventCopyWith<$Res> {
  _$SignUpEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_EmailChangedCopyWith<$Res> {
  factory _$$_EmailChangedCopyWith(
          _$_EmailChanged value, $Res Function(_$_EmailChanged) then) =
      __$$_EmailChangedCopyWithImpl<$Res>;
  @useResult
  $Res call({String newEmail});
}

/// @nodoc
class __$$_EmailChangedCopyWithImpl<$Res>
    extends _$SignUpEventCopyWithImpl<$Res, _$_EmailChanged>
    implements _$$_EmailChangedCopyWith<$Res> {
  __$$_EmailChangedCopyWithImpl(
      _$_EmailChanged _value, $Res Function(_$_EmailChanged) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newEmail = null,
  }) {
    return _then(_$_EmailChanged(
      newEmail: null == newEmail
          ? _value.newEmail
          : newEmail // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_EmailChanged implements _EmailChanged {
  const _$_EmailChanged({required this.newEmail});

  @override
  final String newEmail;

  @override
  String toString() {
    return 'SignUpEvent.emailChanged(newEmail: $newEmail)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EmailChanged &&
            (identical(other.newEmail, newEmail) ||
                other.newEmail == newEmail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newEmail);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EmailChangedCopyWith<_$_EmailChanged> get copyWith =>
      __$$_EmailChangedCopyWithImpl<_$_EmailChanged>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newEmail) emailChanged,
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function(String newPasswordAgain) passwordAgainChanged,
    required TResult Function() signUpPressed,
  }) {
    return emailChanged(newEmail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newEmail)? emailChanged,
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function(String newPasswordAgain)? passwordAgainChanged,
    TResult? Function()? signUpPressed,
  }) {
    return emailChanged?.call(newEmail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newEmail)? emailChanged,
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function(String newPasswordAgain)? passwordAgainChanged,
    TResult Function()? signUpPressed,
    required TResult orElse(),
  }) {
    if (emailChanged != null) {
      return emailChanged(newEmail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EmailChanged value) emailChanged,
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordAgainChanged value) passwordAgainChanged,
    required TResult Function(_SignUpPressed value) signUpPressed,
  }) {
    return emailChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EmailChanged value)? emailChanged,
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult? Function(_SignUpPressed value)? signUpPressed,
  }) {
    return emailChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EmailChanged value)? emailChanged,
    TResult Function(_UsernameChanged value)? usernameChanged,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult Function(_SignUpPressed value)? signUpPressed,
    required TResult orElse(),
  }) {
    if (emailChanged != null) {
      return emailChanged(this);
    }
    return orElse();
  }
}

abstract class _EmailChanged implements SignUpEvent {
  const factory _EmailChanged({required final String newEmail}) =
      _$_EmailChanged;

  String get newEmail;
  @JsonKey(ignore: true)
  _$$_EmailChangedCopyWith<_$_EmailChanged> get copyWith =>
      throw _privateConstructorUsedError;
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
    extends _$SignUpEventCopyWithImpl<$Res, _$_UsernameChanged>
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
    return 'SignUpEvent.usernameChanged(newUsername: $newUsername)';
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
    required TResult Function(String newEmail) emailChanged,
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function(String newPasswordAgain) passwordAgainChanged,
    required TResult Function() signUpPressed,
  }) {
    return usernameChanged(newUsername);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newEmail)? emailChanged,
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function(String newPasswordAgain)? passwordAgainChanged,
    TResult? Function()? signUpPressed,
  }) {
    return usernameChanged?.call(newUsername);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newEmail)? emailChanged,
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function(String newPasswordAgain)? passwordAgainChanged,
    TResult Function()? signUpPressed,
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
    required TResult Function(_EmailChanged value) emailChanged,
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordAgainChanged value) passwordAgainChanged,
    required TResult Function(_SignUpPressed value) signUpPressed,
  }) {
    return usernameChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EmailChanged value)? emailChanged,
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult? Function(_SignUpPressed value)? signUpPressed,
  }) {
    return usernameChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EmailChanged value)? emailChanged,
    TResult Function(_UsernameChanged value)? usernameChanged,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult Function(_SignUpPressed value)? signUpPressed,
    required TResult orElse(),
  }) {
    if (usernameChanged != null) {
      return usernameChanged(this);
    }
    return orElse();
  }
}

abstract class _UsernameChanged implements SignUpEvent {
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
    extends _$SignUpEventCopyWithImpl<$Res, _$_PasswordChanged>
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
    return 'SignUpEvent.passwordChanged(newPassword: $newPassword)';
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
    required TResult Function(String newEmail) emailChanged,
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function(String newPasswordAgain) passwordAgainChanged,
    required TResult Function() signUpPressed,
  }) {
    return passwordChanged(newPassword);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newEmail)? emailChanged,
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function(String newPasswordAgain)? passwordAgainChanged,
    TResult? Function()? signUpPressed,
  }) {
    return passwordChanged?.call(newPassword);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newEmail)? emailChanged,
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function(String newPasswordAgain)? passwordAgainChanged,
    TResult Function()? signUpPressed,
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
    required TResult Function(_EmailChanged value) emailChanged,
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordAgainChanged value) passwordAgainChanged,
    required TResult Function(_SignUpPressed value) signUpPressed,
  }) {
    return passwordChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EmailChanged value)? emailChanged,
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult? Function(_SignUpPressed value)? signUpPressed,
  }) {
    return passwordChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EmailChanged value)? emailChanged,
    TResult Function(_UsernameChanged value)? usernameChanged,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult Function(_SignUpPressed value)? signUpPressed,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(this);
    }
    return orElse();
  }
}

abstract class _PasswordChanged implements SignUpEvent {
  const factory _PasswordChanged({required final String newPassword}) =
      _$_PasswordChanged;

  String get newPassword;
  @JsonKey(ignore: true)
  _$$_PasswordChangedCopyWith<_$_PasswordChanged> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_PasswordAgainChangedCopyWith<$Res> {
  factory _$$_PasswordAgainChangedCopyWith(_$_PasswordAgainChanged value,
          $Res Function(_$_PasswordAgainChanged) then) =
      __$$_PasswordAgainChangedCopyWithImpl<$Res>;
  @useResult
  $Res call({String newPasswordAgain});
}

/// @nodoc
class __$$_PasswordAgainChangedCopyWithImpl<$Res>
    extends _$SignUpEventCopyWithImpl<$Res, _$_PasswordAgainChanged>
    implements _$$_PasswordAgainChangedCopyWith<$Res> {
  __$$_PasswordAgainChangedCopyWithImpl(_$_PasswordAgainChanged _value,
      $Res Function(_$_PasswordAgainChanged) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newPasswordAgain = null,
  }) {
    return _then(_$_PasswordAgainChanged(
      newPasswordAgain: null == newPasswordAgain
          ? _value.newPasswordAgain
          : newPasswordAgain // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PasswordAgainChanged implements _PasswordAgainChanged {
  const _$_PasswordAgainChanged({required this.newPasswordAgain});

  @override
  final String newPasswordAgain;

  @override
  String toString() {
    return 'SignUpEvent.passwordAgainChanged(newPasswordAgain: $newPasswordAgain)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PasswordAgainChanged &&
            (identical(other.newPasswordAgain, newPasswordAgain) ||
                other.newPasswordAgain == newPasswordAgain));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newPasswordAgain);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PasswordAgainChangedCopyWith<_$_PasswordAgainChanged> get copyWith =>
      __$$_PasswordAgainChangedCopyWithImpl<_$_PasswordAgainChanged>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newEmail) emailChanged,
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function(String newPasswordAgain) passwordAgainChanged,
    required TResult Function() signUpPressed,
  }) {
    return passwordAgainChanged(newPasswordAgain);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newEmail)? emailChanged,
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function(String newPasswordAgain)? passwordAgainChanged,
    TResult? Function()? signUpPressed,
  }) {
    return passwordAgainChanged?.call(newPasswordAgain);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newEmail)? emailChanged,
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function(String newPasswordAgain)? passwordAgainChanged,
    TResult Function()? signUpPressed,
    required TResult orElse(),
  }) {
    if (passwordAgainChanged != null) {
      return passwordAgainChanged(newPasswordAgain);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EmailChanged value) emailChanged,
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordAgainChanged value) passwordAgainChanged,
    required TResult Function(_SignUpPressed value) signUpPressed,
  }) {
    return passwordAgainChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EmailChanged value)? emailChanged,
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult? Function(_SignUpPressed value)? signUpPressed,
  }) {
    return passwordAgainChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EmailChanged value)? emailChanged,
    TResult Function(_UsernameChanged value)? usernameChanged,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult Function(_SignUpPressed value)? signUpPressed,
    required TResult orElse(),
  }) {
    if (passwordAgainChanged != null) {
      return passwordAgainChanged(this);
    }
    return orElse();
  }
}

abstract class _PasswordAgainChanged implements SignUpEvent {
  const factory _PasswordAgainChanged(
      {required final String newPasswordAgain}) = _$_PasswordAgainChanged;

  String get newPasswordAgain;
  @JsonKey(ignore: true)
  _$$_PasswordAgainChangedCopyWith<_$_PasswordAgainChanged> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_SignUpPressedCopyWith<$Res> {
  factory _$$_SignUpPressedCopyWith(
          _$_SignUpPressed value, $Res Function(_$_SignUpPressed) then) =
      __$$_SignUpPressedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_SignUpPressedCopyWithImpl<$Res>
    extends _$SignUpEventCopyWithImpl<$Res, _$_SignUpPressed>
    implements _$$_SignUpPressedCopyWith<$Res> {
  __$$_SignUpPressedCopyWithImpl(
      _$_SignUpPressed _value, $Res Function(_$_SignUpPressed) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_SignUpPressed implements _SignUpPressed {
  const _$_SignUpPressed();

  @override
  String toString() {
    return 'SignUpEvent.signUpPressed()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_SignUpPressed);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newEmail) emailChanged,
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function(String newPasswordAgain) passwordAgainChanged,
    required TResult Function() signUpPressed,
  }) {
    return signUpPressed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newEmail)? emailChanged,
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function(String newPasswordAgain)? passwordAgainChanged,
    TResult? Function()? signUpPressed,
  }) {
    return signUpPressed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newEmail)? emailChanged,
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function(String newPasswordAgain)? passwordAgainChanged,
    TResult Function()? signUpPressed,
    required TResult orElse(),
  }) {
    if (signUpPressed != null) {
      return signUpPressed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EmailChanged value) emailChanged,
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordAgainChanged value) passwordAgainChanged,
    required TResult Function(_SignUpPressed value) signUpPressed,
  }) {
    return signUpPressed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EmailChanged value)? emailChanged,
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult? Function(_SignUpPressed value)? signUpPressed,
  }) {
    return signUpPressed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EmailChanged value)? emailChanged,
    TResult Function(_UsernameChanged value)? usernameChanged,
    TResult Function(_PasswordChanged value)? passwordChanged,
    TResult Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult Function(_SignUpPressed value)? signUpPressed,
    required TResult orElse(),
  }) {
    if (signUpPressed != null) {
      return signUpPressed(this);
    }
    return orElse();
  }
}

abstract class _SignUpPressed implements SignUpEvent {
  const factory _SignUpPressed() = _$_SignUpPressed;
}

/// @nodoc
mixin _$SignUpState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(EmailAddress email, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)
        initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(T failure) loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(EmailAddress email, Username username, Password password,
            Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(T failure)? loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(EmailAddress email, Username username, Password password,
            Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(T failure)? loadFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignUpInitial<T> value) initial,
    required TResult Function(SignUpLoadInProgress<T> value) loadInProgress,
    required TResult Function(SignUpLoadSuccess<T> value) loadSuccess,
    required TResult Function(SignUpLoadFailure<T> value) loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpInitial<T> value)? initial,
    TResult? Function(SignUpLoadInProgress<T> value)? loadInProgress,
    TResult? Function(SignUpLoadSuccess<T> value)? loadSuccess,
    TResult? Function(SignUpLoadFailure<T> value)? loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpInitial<T> value)? initial,
    TResult Function(SignUpLoadInProgress<T> value)? loadInProgress,
    TResult Function(SignUpLoadSuccess<T> value)? loadSuccess,
    TResult Function(SignUpLoadFailure<T> value)? loadFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpStateCopyWith<T, $Res> {
  factory $SignUpStateCopyWith(
          SignUpState<T> value, $Res Function(SignUpState<T>) then) =
      _$SignUpStateCopyWithImpl<T, $Res, SignUpState<T>>;
}

/// @nodoc
class _$SignUpStateCopyWithImpl<T, $Res, $Val extends SignUpState<T>>
    implements $SignUpStateCopyWith<T, $Res> {
  _$SignUpStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SignUpInitialCopyWith<T, $Res> {
  factory _$$SignUpInitialCopyWith(
          _$SignUpInitial<T> value, $Res Function(_$SignUpInitial<T>) then) =
      __$$SignUpInitialCopyWithImpl<T, $Res>;
  @useResult
  $Res call(
      {EmailAddress email,
      Username username,
      Password password,
      Password passwordAgain,
      bool showErrorMessages});
}

/// @nodoc
class __$$SignUpInitialCopyWithImpl<T, $Res>
    extends _$SignUpStateCopyWithImpl<T, $Res, _$SignUpInitial<T>>
    implements _$$SignUpInitialCopyWith<T, $Res> {
  __$$SignUpInitialCopyWithImpl(
      _$SignUpInitial<T> _value, $Res Function(_$SignUpInitial<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? username = null,
    Object? password = null,
    Object? passwordAgain = null,
    Object? showErrorMessages = null,
  }) {
    return _then(_$SignUpInitial<T>(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as EmailAddress,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as Username,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as Password,
      passwordAgain: null == passwordAgain
          ? _value.passwordAgain
          : passwordAgain // ignore: cast_nullable_to_non_nullable
              as Password,
      showErrorMessages: null == showErrorMessages
          ? _value.showErrorMessages
          : showErrorMessages // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SignUpInitial<T> implements SignUpInitial<T> {
  const _$SignUpInitial(
      {required this.email,
      required this.username,
      required this.password,
      required this.passwordAgain,
      required this.showErrorMessages});

  @override
  final EmailAddress email;
  @override
  final Username username;
  @override
  final Password password;
  @override
  final Password passwordAgain;
  @override
  final bool showErrorMessages;

  @override
  String toString() {
    return 'SignUpState<$T>.initial(email: $email, username: $username, password: $password, passwordAgain: $passwordAgain, showErrorMessages: $showErrorMessages)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpInitial<T> &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordAgain, passwordAgain) ||
                other.passwordAgain == passwordAgain) &&
            (identical(other.showErrorMessages, showErrorMessages) ||
                other.showErrorMessages == showErrorMessages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, email, username, password, passwordAgain, showErrorMessages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpInitialCopyWith<T, _$SignUpInitial<T>> get copyWith =>
      __$$SignUpInitialCopyWithImpl<T, _$SignUpInitial<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(EmailAddress email, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)
        initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(T failure) loadFailure,
  }) {
    return initial(email, username, password, passwordAgain, showErrorMessages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(EmailAddress email, Username username, Password password,
            Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(T failure)? loadFailure,
  }) {
    return initial?.call(
        email, username, password, passwordAgain, showErrorMessages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(EmailAddress email, Username username, Password password,
            Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(T failure)? loadFailure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(
          email, username, password, passwordAgain, showErrorMessages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignUpInitial<T> value) initial,
    required TResult Function(SignUpLoadInProgress<T> value) loadInProgress,
    required TResult Function(SignUpLoadSuccess<T> value) loadSuccess,
    required TResult Function(SignUpLoadFailure<T> value) loadFailure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpInitial<T> value)? initial,
    TResult? Function(SignUpLoadInProgress<T> value)? loadInProgress,
    TResult? Function(SignUpLoadSuccess<T> value)? loadSuccess,
    TResult? Function(SignUpLoadFailure<T> value)? loadFailure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpInitial<T> value)? initial,
    TResult Function(SignUpLoadInProgress<T> value)? loadInProgress,
    TResult Function(SignUpLoadSuccess<T> value)? loadSuccess,
    TResult Function(SignUpLoadFailure<T> value)? loadFailure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SignUpInitial<T> implements SignUpState<T> {
  const factory SignUpInitial(
      {required final EmailAddress email,
      required final Username username,
      required final Password password,
      required final Password passwordAgain,
      required final bool showErrorMessages}) = _$SignUpInitial<T>;

  EmailAddress get email;
  Username get username;
  Password get password;
  Password get passwordAgain;
  bool get showErrorMessages;
  @JsonKey(ignore: true)
  _$$SignUpInitialCopyWith<T, _$SignUpInitial<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignUpLoadInProgressCopyWith<T, $Res> {
  factory _$$SignUpLoadInProgressCopyWith(_$SignUpLoadInProgress<T> value,
          $Res Function(_$SignUpLoadInProgress<T>) then) =
      __$$SignUpLoadInProgressCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$SignUpLoadInProgressCopyWithImpl<T, $Res>
    extends _$SignUpStateCopyWithImpl<T, $Res, _$SignUpLoadInProgress<T>>
    implements _$$SignUpLoadInProgressCopyWith<T, $Res> {
  __$$SignUpLoadInProgressCopyWithImpl(_$SignUpLoadInProgress<T> _value,
      $Res Function(_$SignUpLoadInProgress<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignUpLoadInProgress<T> implements SignUpLoadInProgress<T> {
  const _$SignUpLoadInProgress();

  @override
  String toString() {
    return 'SignUpState<$T>.loadInProgress()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpLoadInProgress<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(EmailAddress email, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)
        initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(T failure) loadFailure,
  }) {
    return loadInProgress();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(EmailAddress email, Username username, Password password,
            Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(T failure)? loadFailure,
  }) {
    return loadInProgress?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(EmailAddress email, Username username, Password password,
            Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(T failure)? loadFailure,
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
    required TResult Function(SignUpInitial<T> value) initial,
    required TResult Function(SignUpLoadInProgress<T> value) loadInProgress,
    required TResult Function(SignUpLoadSuccess<T> value) loadSuccess,
    required TResult Function(SignUpLoadFailure<T> value) loadFailure,
  }) {
    return loadInProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpInitial<T> value)? initial,
    TResult? Function(SignUpLoadInProgress<T> value)? loadInProgress,
    TResult? Function(SignUpLoadSuccess<T> value)? loadSuccess,
    TResult? Function(SignUpLoadFailure<T> value)? loadFailure,
  }) {
    return loadInProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpInitial<T> value)? initial,
    TResult Function(SignUpLoadInProgress<T> value)? loadInProgress,
    TResult Function(SignUpLoadSuccess<T> value)? loadSuccess,
    TResult Function(SignUpLoadFailure<T> value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadInProgress != null) {
      return loadInProgress(this);
    }
    return orElse();
  }
}

abstract class SignUpLoadInProgress<T> implements SignUpState<T> {
  const factory SignUpLoadInProgress() = _$SignUpLoadInProgress<T>;
}

/// @nodoc
abstract class _$$SignUpLoadSuccessCopyWith<T, $Res> {
  factory _$$SignUpLoadSuccessCopyWith(_$SignUpLoadSuccess<T> value,
          $Res Function(_$SignUpLoadSuccess<T>) then) =
      __$$SignUpLoadSuccessCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$SignUpLoadSuccessCopyWithImpl<T, $Res>
    extends _$SignUpStateCopyWithImpl<T, $Res, _$SignUpLoadSuccess<T>>
    implements _$$SignUpLoadSuccessCopyWith<T, $Res> {
  __$$SignUpLoadSuccessCopyWithImpl(_$SignUpLoadSuccess<T> _value,
      $Res Function(_$SignUpLoadSuccess<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignUpLoadSuccess<T> implements SignUpLoadSuccess<T> {
  const _$SignUpLoadSuccess();

  @override
  String toString() {
    return 'SignUpState<$T>.loadSuccess()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignUpLoadSuccess<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(EmailAddress email, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)
        initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(T failure) loadFailure,
  }) {
    return loadSuccess();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(EmailAddress email, Username username, Password password,
            Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(T failure)? loadFailure,
  }) {
    return loadSuccess?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(EmailAddress email, Username username, Password password,
            Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(T failure)? loadFailure,
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
    required TResult Function(SignUpInitial<T> value) initial,
    required TResult Function(SignUpLoadInProgress<T> value) loadInProgress,
    required TResult Function(SignUpLoadSuccess<T> value) loadSuccess,
    required TResult Function(SignUpLoadFailure<T> value) loadFailure,
  }) {
    return loadSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpInitial<T> value)? initial,
    TResult? Function(SignUpLoadInProgress<T> value)? loadInProgress,
    TResult? Function(SignUpLoadSuccess<T> value)? loadSuccess,
    TResult? Function(SignUpLoadFailure<T> value)? loadFailure,
  }) {
    return loadSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpInitial<T> value)? initial,
    TResult Function(SignUpLoadInProgress<T> value)? loadInProgress,
    TResult Function(SignUpLoadSuccess<T> value)? loadSuccess,
    TResult Function(SignUpLoadFailure<T> value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadSuccess != null) {
      return loadSuccess(this);
    }
    return orElse();
  }
}

abstract class SignUpLoadSuccess<T> implements SignUpState<T> {
  const factory SignUpLoadSuccess() = _$SignUpLoadSuccess<T>;
}

/// @nodoc
abstract class _$$SignUpLoadFailureCopyWith<T, $Res> {
  factory _$$SignUpLoadFailureCopyWith(_$SignUpLoadFailure<T> value,
          $Res Function(_$SignUpLoadFailure<T>) then) =
      __$$SignUpLoadFailureCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T failure});
}

/// @nodoc
class __$$SignUpLoadFailureCopyWithImpl<T, $Res>
    extends _$SignUpStateCopyWithImpl<T, $Res, _$SignUpLoadFailure<T>>
    implements _$$SignUpLoadFailureCopyWith<T, $Res> {
  __$$SignUpLoadFailureCopyWithImpl(_$SignUpLoadFailure<T> _value,
      $Res Function(_$SignUpLoadFailure<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = freezed,
  }) {
    return _then(_$SignUpLoadFailure<T>(
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$SignUpLoadFailure<T> implements SignUpLoadFailure<T> {
  const _$SignUpLoadFailure({required this.failure});

  @override
  final T failure;

  @override
  String toString() {
    return 'SignUpState<$T>.loadFailure(failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpLoadFailure<T> &&
            const DeepCollectionEquality().equals(other.failure, failure));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(failure));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpLoadFailureCopyWith<T, _$SignUpLoadFailure<T>> get copyWith =>
      __$$SignUpLoadFailureCopyWithImpl<T, _$SignUpLoadFailure<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(EmailAddress email, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)
        initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(T failure) loadFailure,
  }) {
    return loadFailure(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(EmailAddress email, Username username, Password password,
            Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(T failure)? loadFailure,
  }) {
    return loadFailure?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(EmailAddress email, Username username, Password password,
            Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(T failure)? loadFailure,
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
    required TResult Function(SignUpInitial<T> value) initial,
    required TResult Function(SignUpLoadInProgress<T> value) loadInProgress,
    required TResult Function(SignUpLoadSuccess<T> value) loadSuccess,
    required TResult Function(SignUpLoadFailure<T> value) loadFailure,
  }) {
    return loadFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpInitial<T> value)? initial,
    TResult? Function(SignUpLoadInProgress<T> value)? loadInProgress,
    TResult? Function(SignUpLoadSuccess<T> value)? loadSuccess,
    TResult? Function(SignUpLoadFailure<T> value)? loadFailure,
  }) {
    return loadFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpInitial<T> value)? initial,
    TResult Function(SignUpLoadInProgress<T> value)? loadInProgress,
    TResult Function(SignUpLoadSuccess<T> value)? loadSuccess,
    TResult Function(SignUpLoadFailure<T> value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadFailure != null) {
      return loadFailure(this);
    }
    return orElse();
  }
}

abstract class SignUpLoadFailure<T> implements SignUpState<T> {
  const factory SignUpLoadFailure({required final T failure}) =
      _$SignUpLoadFailure<T>;

  T get failure;
  @JsonKey(ignore: true)
  _$$SignUpLoadFailureCopyWith<T, _$SignUpLoadFailure<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

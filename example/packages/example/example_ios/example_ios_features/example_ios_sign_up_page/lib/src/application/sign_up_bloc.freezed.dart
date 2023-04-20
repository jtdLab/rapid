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
    required TResult Function(String newEmailAddress) emailChanged,
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function(String newPasswordAgain) passwordAgainChanged,
    required TResult Function() signUpPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newEmailAddress)? emailChanged,
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function(String newPasswordAgain)? passwordAgainChanged,
    TResult? Function()? signUpPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newEmailAddress)? emailChanged,
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function(String newPasswordAgain)? passwordAgainChanged,
    TResult Function()? signUpPressed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EmailAddressChanged value) emailChanged,
    required TResult Function(_UsernameChanged value) usernameChanged,
    required TResult Function(_PasswordChanged value) passwordChanged,
    required TResult Function(_PasswordAgainChanged value) passwordAgainChanged,
    required TResult Function(_SignUpPressed value) signUpPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EmailAddressChanged value)? emailChanged,
    TResult? Function(_UsernameChanged value)? usernameChanged,
    TResult? Function(_PasswordChanged value)? passwordChanged,
    TResult? Function(_PasswordAgainChanged value)? passwordAgainChanged,
    TResult? Function(_SignUpPressed value)? signUpPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EmailAddressChanged value)? emailChanged,
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
abstract class _$$_EmailAddressChangedCopyWith<$Res> {
  factory _$$_EmailAddressChangedCopyWith(_$_EmailAddressChanged value,
          $Res Function(_$_EmailAddressChanged) then) =
      __$$_EmailAddressChangedCopyWithImpl<$Res>;
  @useResult
  $Res call({String newEmailAddress});
}

/// @nodoc
class __$$_EmailAddressChangedCopyWithImpl<$Res>
    extends _$SignUpEventCopyWithImpl<$Res, _$_EmailAddressChanged>
    implements _$$_EmailAddressChangedCopyWith<$Res> {
  __$$_EmailAddressChangedCopyWithImpl(_$_EmailAddressChanged _value,
      $Res Function(_$_EmailAddressChanged) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newEmailAddress = null,
  }) {
    return _then(_$_EmailAddressChanged(
      newEmailAddress: null == newEmailAddress
          ? _value.newEmailAddress
          : newEmailAddress // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_EmailAddressChanged implements _EmailAddressChanged {
  const _$_EmailAddressChanged({required this.newEmailAddress});

  @override
  final String newEmailAddress;

  @override
  String toString() {
    return 'SignUpEvent.emailChanged(newEmailAddress: $newEmailAddress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EmailAddressChanged &&
            (identical(other.newEmailAddress, newEmailAddress) ||
                other.newEmailAddress == newEmailAddress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newEmailAddress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EmailAddressChangedCopyWith<_$_EmailAddressChanged> get copyWith =>
      __$$_EmailAddressChangedCopyWithImpl<_$_EmailAddressChanged>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String newEmailAddress) emailChanged,
    required TResult Function(String newUsername) usernameChanged,
    required TResult Function(String newPassword) passwordChanged,
    required TResult Function(String newPasswordAgain) passwordAgainChanged,
    required TResult Function() signUpPressed,
  }) {
    return emailChanged(newEmailAddress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String newEmailAddress)? emailChanged,
    TResult? Function(String newUsername)? usernameChanged,
    TResult? Function(String newPassword)? passwordChanged,
    TResult? Function(String newPasswordAgain)? passwordAgainChanged,
    TResult? Function()? signUpPressed,
  }) {
    return emailChanged?.call(newEmailAddress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String newEmailAddress)? emailChanged,
    TResult Function(String newUsername)? usernameChanged,
    TResult Function(String newPassword)? passwordChanged,
    TResult Function(String newPasswordAgain)? passwordAgainChanged,
    TResult Function()? signUpPressed,
    required TResult orElse(),
  }) {
    if (emailChanged != null) {
      return emailChanged(newEmailAddress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EmailAddressChanged value) emailChanged,
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
    TResult? Function(_EmailAddressChanged value)? emailChanged,
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
    TResult Function(_EmailAddressChanged value)? emailChanged,
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

abstract class _EmailAddressChanged implements SignUpEvent {
  const factory _EmailAddressChanged({required final String newEmailAddress}) =
      _$_EmailAddressChanged;

  String get newEmailAddress;
  @JsonKey(ignore: true)
  _$$_EmailAddressChangedCopyWith<_$_EmailAddressChanged> get copyWith =>
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
    required TResult Function(String newEmailAddress) emailChanged,
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
    TResult? Function(String newEmailAddress)? emailChanged,
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
    TResult Function(String newEmailAddress)? emailChanged,
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
    required TResult Function(_EmailAddressChanged value) emailChanged,
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
    TResult? Function(_EmailAddressChanged value)? emailChanged,
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
    TResult Function(_EmailAddressChanged value)? emailChanged,
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
    required TResult Function(String newEmailAddress) emailChanged,
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
    TResult? Function(String newEmailAddress)? emailChanged,
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
    TResult Function(String newEmailAddress)? emailChanged,
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
    required TResult Function(_EmailAddressChanged value) emailChanged,
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
    TResult? Function(_EmailAddressChanged value)? emailChanged,
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
    TResult Function(_EmailAddressChanged value)? emailChanged,
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
    required TResult Function(String newEmailAddress) emailChanged,
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
    TResult? Function(String newEmailAddress)? emailChanged,
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
    TResult Function(String newEmailAddress)? emailChanged,
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
    required TResult Function(_EmailAddressChanged value) emailChanged,
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
    TResult? Function(_EmailAddressChanged value)? emailChanged,
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
    TResult Function(_EmailAddressChanged value)? emailChanged,
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
    required TResult Function(String newEmailAddress) emailChanged,
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
    TResult? Function(String newEmailAddress)? emailChanged,
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
    TResult Function(String newEmailAddress)? emailChanged,
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
    required TResult Function(_EmailAddressChanged value) emailChanged,
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
    TResult? Function(_EmailAddressChanged value)? emailChanged,
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
    TResult Function(_EmailAddressChanged value)? emailChanged,
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
mixin _$SignUpState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)
        initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)
        loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)?
        loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignUpInitial value) initial,
    required TResult Function(SignUpLoadInProgress value) loadInProgress,
    required TResult Function(SignUpLoadSuccess value) loadSuccess,
    required TResult Function(SignUpLoadFailure value) loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpInitial value)? initial,
    TResult? Function(SignUpLoadInProgress value)? loadInProgress,
    TResult? Function(SignUpLoadSuccess value)? loadSuccess,
    TResult? Function(SignUpLoadFailure value)? loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpInitial value)? initial,
    TResult Function(SignUpLoadInProgress value)? loadInProgress,
    TResult Function(SignUpLoadSuccess value)? loadSuccess,
    TResult Function(SignUpLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpStateCopyWith<$Res> {
  factory $SignUpStateCopyWith(
          SignUpState value, $Res Function(SignUpState) then) =
      _$SignUpStateCopyWithImpl<$Res, SignUpState>;
}

/// @nodoc
class _$SignUpStateCopyWithImpl<$Res, $Val extends SignUpState>
    implements $SignUpStateCopyWith<$Res> {
  _$SignUpStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SignUpInitialCopyWith<$Res> {
  factory _$$SignUpInitialCopyWith(
          _$SignUpInitial value, $Res Function(_$SignUpInitial) then) =
      __$$SignUpInitialCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {EmailAddress emailAddress,
      Username username,
      Password password,
      Password passwordAgain,
      bool showErrorMessages});
}

/// @nodoc
class __$$SignUpInitialCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpInitial>
    implements _$$SignUpInitialCopyWith<$Res> {
  __$$SignUpInitialCopyWithImpl(
      _$SignUpInitial _value, $Res Function(_$SignUpInitial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailAddress = null,
    Object? username = null,
    Object? password = null,
    Object? passwordAgain = null,
    Object? showErrorMessages = null,
  }) {
    return _then(_$SignUpInitial(
      emailAddress: null == emailAddress
          ? _value.emailAddress
          : emailAddress // ignore: cast_nullable_to_non_nullable
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

class _$SignUpInitial implements SignUpInitial {
  const _$SignUpInitial(
      {required this.emailAddress,
      required this.username,
      required this.password,
      required this.passwordAgain,
      required this.showErrorMessages});

  @override
  final EmailAddress emailAddress;
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
    return 'SignUpState.initial(emailAddress: $emailAddress, username: $username, password: $password, passwordAgain: $passwordAgain, showErrorMessages: $showErrorMessages)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpInitial &&
            (identical(other.emailAddress, emailAddress) ||
                other.emailAddress == emailAddress) &&
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
  int get hashCode => Object.hash(runtimeType, emailAddress, username, password,
      passwordAgain, showErrorMessages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpInitialCopyWith<_$SignUpInitial> get copyWith =>
      __$$SignUpInitialCopyWithImpl<_$SignUpInitial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)
        initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)
        loadFailure,
  }) {
    return initial(
        emailAddress, username, password, passwordAgain, showErrorMessages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)?
        loadFailure,
  }) {
    return initial?.call(
        emailAddress, username, password, passwordAgain, showErrorMessages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(
          emailAddress, username, password, passwordAgain, showErrorMessages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignUpInitial value) initial,
    required TResult Function(SignUpLoadInProgress value) loadInProgress,
    required TResult Function(SignUpLoadSuccess value) loadSuccess,
    required TResult Function(SignUpLoadFailure value) loadFailure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpInitial value)? initial,
    TResult? Function(SignUpLoadInProgress value)? loadInProgress,
    TResult? Function(SignUpLoadSuccess value)? loadSuccess,
    TResult? Function(SignUpLoadFailure value)? loadFailure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpInitial value)? initial,
    TResult Function(SignUpLoadInProgress value)? loadInProgress,
    TResult Function(SignUpLoadSuccess value)? loadSuccess,
    TResult Function(SignUpLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SignUpInitial implements SignUpState {
  const factory SignUpInitial(
      {required final EmailAddress emailAddress,
      required final Username username,
      required final Password password,
      required final Password passwordAgain,
      required final bool showErrorMessages}) = _$SignUpInitial;

  EmailAddress get emailAddress;
  Username get username;
  Password get password;
  Password get passwordAgain;
  bool get showErrorMessages;
  @JsonKey(ignore: true)
  _$$SignUpInitialCopyWith<_$SignUpInitial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignUpLoadInProgressCopyWith<$Res> {
  factory _$$SignUpLoadInProgressCopyWith(_$SignUpLoadInProgress value,
          $Res Function(_$SignUpLoadInProgress) then) =
      __$$SignUpLoadInProgressCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignUpLoadInProgressCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpLoadInProgress>
    implements _$$SignUpLoadInProgressCopyWith<$Res> {
  __$$SignUpLoadInProgressCopyWithImpl(_$SignUpLoadInProgress _value,
      $Res Function(_$SignUpLoadInProgress) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignUpLoadInProgress implements SignUpLoadInProgress {
  const _$SignUpLoadInProgress();

  @override
  String toString() {
    return 'SignUpState.loadInProgress()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignUpLoadInProgress);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)
        initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)
        loadFailure,
  }) {
    return loadInProgress();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)?
        loadFailure,
  }) {
    return loadInProgress?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)?
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
    required TResult Function(SignUpInitial value) initial,
    required TResult Function(SignUpLoadInProgress value) loadInProgress,
    required TResult Function(SignUpLoadSuccess value) loadSuccess,
    required TResult Function(SignUpLoadFailure value) loadFailure,
  }) {
    return loadInProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpInitial value)? initial,
    TResult? Function(SignUpLoadInProgress value)? loadInProgress,
    TResult? Function(SignUpLoadSuccess value)? loadSuccess,
    TResult? Function(SignUpLoadFailure value)? loadFailure,
  }) {
    return loadInProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpInitial value)? initial,
    TResult Function(SignUpLoadInProgress value)? loadInProgress,
    TResult Function(SignUpLoadSuccess value)? loadSuccess,
    TResult Function(SignUpLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadInProgress != null) {
      return loadInProgress(this);
    }
    return orElse();
  }
}

abstract class SignUpLoadInProgress implements SignUpState {
  const factory SignUpLoadInProgress() = _$SignUpLoadInProgress;
}

/// @nodoc
abstract class _$$SignUpLoadSuccessCopyWith<$Res> {
  factory _$$SignUpLoadSuccessCopyWith(
          _$SignUpLoadSuccess value, $Res Function(_$SignUpLoadSuccess) then) =
      __$$SignUpLoadSuccessCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignUpLoadSuccessCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpLoadSuccess>
    implements _$$SignUpLoadSuccessCopyWith<$Res> {
  __$$SignUpLoadSuccessCopyWithImpl(
      _$SignUpLoadSuccess _value, $Res Function(_$SignUpLoadSuccess) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignUpLoadSuccess implements SignUpLoadSuccess {
  const _$SignUpLoadSuccess();

  @override
  String toString() {
    return 'SignUpState.loadSuccess()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignUpLoadSuccess);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)
        initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)
        loadFailure,
  }) {
    return loadSuccess();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)?
        loadFailure,
  }) {
    return loadSuccess?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)?
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
    required TResult Function(SignUpInitial value) initial,
    required TResult Function(SignUpLoadInProgress value) loadInProgress,
    required TResult Function(SignUpLoadSuccess value) loadSuccess,
    required TResult Function(SignUpLoadFailure value) loadFailure,
  }) {
    return loadSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpInitial value)? initial,
    TResult? Function(SignUpLoadInProgress value)? loadInProgress,
    TResult? Function(SignUpLoadSuccess value)? loadSuccess,
    TResult? Function(SignUpLoadFailure value)? loadFailure,
  }) {
    return loadSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpInitial value)? initial,
    TResult Function(SignUpLoadInProgress value)? loadInProgress,
    TResult Function(SignUpLoadSuccess value)? loadSuccess,
    TResult Function(SignUpLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadSuccess != null) {
      return loadSuccess(this);
    }
    return orElse();
  }
}

abstract class SignUpLoadSuccess implements SignUpState {
  const factory SignUpLoadSuccess() = _$SignUpLoadSuccess;
}

/// @nodoc
abstract class _$$SignUpLoadFailureCopyWith<$Res> {
  factory _$$SignUpLoadFailureCopyWith(
          _$SignUpLoadFailure value, $Res Function(_$SignUpLoadFailure) then) =
      __$$SignUpLoadFailureCopyWithImpl<$Res>;
  @useResult
  $Res call({AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure});

  $AuthServiceSignUpWithEmailAndUsernameAndPasswordFailureCopyWith<$Res>
      get failure;
}

/// @nodoc
class __$$SignUpLoadFailureCopyWithImpl<$Res>
    extends _$SignUpStateCopyWithImpl<$Res, _$SignUpLoadFailure>
    implements _$$SignUpLoadFailureCopyWith<$Res> {
  __$$SignUpLoadFailureCopyWithImpl(
      _$SignUpLoadFailure _value, $Res Function(_$SignUpLoadFailure) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
  }) {
    return _then(_$SignUpLoadFailure(
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $AuthServiceSignUpWithEmailAndUsernameAndPasswordFailureCopyWith<$Res>
      get failure {
    return $AuthServiceSignUpWithEmailAndUsernameAndPasswordFailureCopyWith<
        $Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value));
    });
  }
}

/// @nodoc

class _$SignUpLoadFailure implements SignUpLoadFailure {
  const _$SignUpLoadFailure({required this.failure});

  @override
  final AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure;

  @override
  String toString() {
    return 'SignUpState.loadFailure(failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpLoadFailure &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpLoadFailureCopyWith<_$SignUpLoadFailure> get copyWith =>
      __$$SignUpLoadFailureCopyWithImpl<_$SignUpLoadFailure>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)
        initial,
    required TResult Function() loadInProgress,
    required TResult Function() loadSuccess,
    required TResult Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)
        loadFailure,
  }) {
    return loadFailure(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult? Function()? loadInProgress,
    TResult? Function()? loadSuccess,
    TResult? Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)?
        loadFailure,
  }) {
    return loadFailure?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(EmailAddress emailAddress, Username username,
            Password password, Password passwordAgain, bool showErrorMessages)?
        initial,
    TResult Function()? loadInProgress,
    TResult Function()? loadSuccess,
    TResult Function(
            AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure failure)?
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
    required TResult Function(SignUpInitial value) initial,
    required TResult Function(SignUpLoadInProgress value) loadInProgress,
    required TResult Function(SignUpLoadSuccess value) loadSuccess,
    required TResult Function(SignUpLoadFailure value) loadFailure,
  }) {
    return loadFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpInitial value)? initial,
    TResult? Function(SignUpLoadInProgress value)? loadInProgress,
    TResult? Function(SignUpLoadSuccess value)? loadSuccess,
    TResult? Function(SignUpLoadFailure value)? loadFailure,
  }) {
    return loadFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpInitial value)? initial,
    TResult Function(SignUpLoadInProgress value)? loadInProgress,
    TResult Function(SignUpLoadSuccess value)? loadSuccess,
    TResult Function(SignUpLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadFailure != null) {
      return loadFailure(this);
    }
    return orElse();
  }
}

abstract class SignUpLoadFailure implements SignUpState {
  const factory SignUpLoadFailure(
      {required final AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
          failure}) = _$SignUpLoadFailure;

  AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure get failure;
  @JsonKey(ignore: true)
  _$$SignUpLoadFailureCopyWith<_$SignUpLoadFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

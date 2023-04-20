// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PasswordFailure {
  String get failedValue => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String failedValue) shortPassword,
    required TResult Function(String failedValue) longPassword,
    required TResult Function(String failedValue) invalidWhitespaces,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String failedValue)? shortPassword,
    TResult? Function(String failedValue)? longPassword,
    TResult? Function(String failedValue)? invalidWhitespaces,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String failedValue)? shortPassword,
    TResult Function(String failedValue)? longPassword,
    TResult Function(String failedValue)? invalidWhitespaces,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShortPassword value) shortPassword,
    required TResult Function(_LongPassword value) longPassword,
    required TResult Function(_InvalidWhitespaces value) invalidWhitespaces,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ShortPassword value)? shortPassword,
    TResult? Function(_LongPassword value)? longPassword,
    TResult? Function(_InvalidWhitespaces value)? invalidWhitespaces,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShortPassword value)? shortPassword,
    TResult Function(_LongPassword value)? longPassword,
    TResult Function(_InvalidWhitespaces value)? invalidWhitespaces,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PasswordFailureCopyWith<PasswordFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordFailureCopyWith<$Res> {
  factory $PasswordFailureCopyWith(
          PasswordFailure value, $Res Function(PasswordFailure) then) =
      _$PasswordFailureCopyWithImpl<$Res, PasswordFailure>;
  @useResult
  $Res call({String failedValue});
}

/// @nodoc
class _$PasswordFailureCopyWithImpl<$Res, $Val extends PasswordFailure>
    implements $PasswordFailureCopyWith<$Res> {
  _$PasswordFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = null,
  }) {
    return _then(_value.copyWith(
      failedValue: null == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ShortPasswordCopyWith<$Res>
    implements $PasswordFailureCopyWith<$Res> {
  factory _$$_ShortPasswordCopyWith(
          _$_ShortPassword value, $Res Function(_$_ShortPassword) then) =
      __$$_ShortPasswordCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String failedValue});
}

/// @nodoc
class __$$_ShortPasswordCopyWithImpl<$Res>
    extends _$PasswordFailureCopyWithImpl<$Res, _$_ShortPassword>
    implements _$$_ShortPasswordCopyWith<$Res> {
  __$$_ShortPasswordCopyWithImpl(
      _$_ShortPassword _value, $Res Function(_$_ShortPassword) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = null,
  }) {
    return _then(_$_ShortPassword(
      failedValue: null == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ShortPassword implements _ShortPassword {
  const _$_ShortPassword({required this.failedValue});

  @override
  final String failedValue;

  @override
  String toString() {
    return 'PasswordFailure.shortPassword(failedValue: $failedValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ShortPassword &&
            (identical(other.failedValue, failedValue) ||
                other.failedValue == failedValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failedValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ShortPasswordCopyWith<_$_ShortPassword> get copyWith =>
      __$$_ShortPasswordCopyWithImpl<_$_ShortPassword>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String failedValue) shortPassword,
    required TResult Function(String failedValue) longPassword,
    required TResult Function(String failedValue) invalidWhitespaces,
  }) {
    return shortPassword(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String failedValue)? shortPassword,
    TResult? Function(String failedValue)? longPassword,
    TResult? Function(String failedValue)? invalidWhitespaces,
  }) {
    return shortPassword?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String failedValue)? shortPassword,
    TResult Function(String failedValue)? longPassword,
    TResult Function(String failedValue)? invalidWhitespaces,
    required TResult orElse(),
  }) {
    if (shortPassword != null) {
      return shortPassword(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShortPassword value) shortPassword,
    required TResult Function(_LongPassword value) longPassword,
    required TResult Function(_InvalidWhitespaces value) invalidWhitespaces,
  }) {
    return shortPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ShortPassword value)? shortPassword,
    TResult? Function(_LongPassword value)? longPassword,
    TResult? Function(_InvalidWhitespaces value)? invalidWhitespaces,
  }) {
    return shortPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShortPassword value)? shortPassword,
    TResult Function(_LongPassword value)? longPassword,
    TResult Function(_InvalidWhitespaces value)? invalidWhitespaces,
    required TResult orElse(),
  }) {
    if (shortPassword != null) {
      return shortPassword(this);
    }
    return orElse();
  }
}

abstract class _ShortPassword implements PasswordFailure {
  const factory _ShortPassword({required final String failedValue}) =
      _$_ShortPassword;

  @override
  String get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$_ShortPasswordCopyWith<_$_ShortPassword> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_LongPasswordCopyWith<$Res>
    implements $PasswordFailureCopyWith<$Res> {
  factory _$$_LongPasswordCopyWith(
          _$_LongPassword value, $Res Function(_$_LongPassword) then) =
      __$$_LongPasswordCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String failedValue});
}

/// @nodoc
class __$$_LongPasswordCopyWithImpl<$Res>
    extends _$PasswordFailureCopyWithImpl<$Res, _$_LongPassword>
    implements _$$_LongPasswordCopyWith<$Res> {
  __$$_LongPasswordCopyWithImpl(
      _$_LongPassword _value, $Res Function(_$_LongPassword) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = null,
  }) {
    return _then(_$_LongPassword(
      failedValue: null == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LongPassword implements _LongPassword {
  const _$_LongPassword({required this.failedValue});

  @override
  final String failedValue;

  @override
  String toString() {
    return 'PasswordFailure.longPassword(failedValue: $failedValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LongPassword &&
            (identical(other.failedValue, failedValue) ||
                other.failedValue == failedValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failedValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LongPasswordCopyWith<_$_LongPassword> get copyWith =>
      __$$_LongPasswordCopyWithImpl<_$_LongPassword>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String failedValue) shortPassword,
    required TResult Function(String failedValue) longPassword,
    required TResult Function(String failedValue) invalidWhitespaces,
  }) {
    return longPassword(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String failedValue)? shortPassword,
    TResult? Function(String failedValue)? longPassword,
    TResult? Function(String failedValue)? invalidWhitespaces,
  }) {
    return longPassword?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String failedValue)? shortPassword,
    TResult Function(String failedValue)? longPassword,
    TResult Function(String failedValue)? invalidWhitespaces,
    required TResult orElse(),
  }) {
    if (longPassword != null) {
      return longPassword(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShortPassword value) shortPassword,
    required TResult Function(_LongPassword value) longPassword,
    required TResult Function(_InvalidWhitespaces value) invalidWhitespaces,
  }) {
    return longPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ShortPassword value)? shortPassword,
    TResult? Function(_LongPassword value)? longPassword,
    TResult? Function(_InvalidWhitespaces value)? invalidWhitespaces,
  }) {
    return longPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShortPassword value)? shortPassword,
    TResult Function(_LongPassword value)? longPassword,
    TResult Function(_InvalidWhitespaces value)? invalidWhitespaces,
    required TResult orElse(),
  }) {
    if (longPassword != null) {
      return longPassword(this);
    }
    return orElse();
  }
}

abstract class _LongPassword implements PasswordFailure {
  const factory _LongPassword({required final String failedValue}) =
      _$_LongPassword;

  @override
  String get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$_LongPasswordCopyWith<_$_LongPassword> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_InvalidWhitespacesCopyWith<$Res>
    implements $PasswordFailureCopyWith<$Res> {
  factory _$$_InvalidWhitespacesCopyWith(_$_InvalidWhitespaces value,
          $Res Function(_$_InvalidWhitespaces) then) =
      __$$_InvalidWhitespacesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String failedValue});
}

/// @nodoc
class __$$_InvalidWhitespacesCopyWithImpl<$Res>
    extends _$PasswordFailureCopyWithImpl<$Res, _$_InvalidWhitespaces>
    implements _$$_InvalidWhitespacesCopyWith<$Res> {
  __$$_InvalidWhitespacesCopyWithImpl(
      _$_InvalidWhitespaces _value, $Res Function(_$_InvalidWhitespaces) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = null,
  }) {
    return _then(_$_InvalidWhitespaces(
      failedValue: null == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_InvalidWhitespaces implements _InvalidWhitespaces {
  const _$_InvalidWhitespaces({required this.failedValue});

  @override
  final String failedValue;

  @override
  String toString() {
    return 'PasswordFailure.invalidWhitespaces(failedValue: $failedValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InvalidWhitespaces &&
            (identical(other.failedValue, failedValue) ||
                other.failedValue == failedValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failedValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InvalidWhitespacesCopyWith<_$_InvalidWhitespaces> get copyWith =>
      __$$_InvalidWhitespacesCopyWithImpl<_$_InvalidWhitespaces>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String failedValue) shortPassword,
    required TResult Function(String failedValue) longPassword,
    required TResult Function(String failedValue) invalidWhitespaces,
  }) {
    return invalidWhitespaces(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String failedValue)? shortPassword,
    TResult? Function(String failedValue)? longPassword,
    TResult? Function(String failedValue)? invalidWhitespaces,
  }) {
    return invalidWhitespaces?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String failedValue)? shortPassword,
    TResult Function(String failedValue)? longPassword,
    TResult Function(String failedValue)? invalidWhitespaces,
    required TResult orElse(),
  }) {
    if (invalidWhitespaces != null) {
      return invalidWhitespaces(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShortPassword value) shortPassword,
    required TResult Function(_LongPassword value) longPassword,
    required TResult Function(_InvalidWhitespaces value) invalidWhitespaces,
  }) {
    return invalidWhitespaces(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ShortPassword value)? shortPassword,
    TResult? Function(_LongPassword value)? longPassword,
    TResult? Function(_InvalidWhitespaces value)? invalidWhitespaces,
  }) {
    return invalidWhitespaces?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShortPassword value)? shortPassword,
    TResult Function(_LongPassword value)? longPassword,
    TResult Function(_InvalidWhitespaces value)? invalidWhitespaces,
    required TResult orElse(),
  }) {
    if (invalidWhitespaces != null) {
      return invalidWhitespaces(this);
    }
    return orElse();
  }
}

abstract class _InvalidWhitespaces implements PasswordFailure {
  const factory _InvalidWhitespaces({required final String failedValue}) =
      _$_InvalidWhitespaces;

  @override
  String get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$_InvalidWhitespacesCopyWith<_$_InvalidWhitespaces> get copyWith =>
      throw _privateConstructorUsedError;
}

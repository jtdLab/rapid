// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'username.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UsernameFailure {
  String get failedValue => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String failedValue) shortUsername,
    required TResult Function(String failedValue) longUsername,
    required TResult Function(String failedValue) invalidCharacters,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String failedValue)? shortUsername,
    TResult? Function(String failedValue)? longUsername,
    TResult? Function(String failedValue)? invalidCharacters,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String failedValue)? shortUsername,
    TResult Function(String failedValue)? longUsername,
    TResult Function(String failedValue)? invalidCharacters,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShortUsername value) shortUsername,
    required TResult Function(_LongUsername value) longUsername,
    required TResult Function(_InvalidCharacters value) invalidCharacters,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ShortUsername value)? shortUsername,
    TResult? Function(_LongUsername value)? longUsername,
    TResult? Function(_InvalidCharacters value)? invalidCharacters,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShortUsername value)? shortUsername,
    TResult Function(_LongUsername value)? longUsername,
    TResult Function(_InvalidCharacters value)? invalidCharacters,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UsernameFailureCopyWith<UsernameFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsernameFailureCopyWith<$Res> {
  factory $UsernameFailureCopyWith(
          UsernameFailure value, $Res Function(UsernameFailure) then) =
      _$UsernameFailureCopyWithImpl<$Res, UsernameFailure>;
  @useResult
  $Res call({String failedValue});
}

/// @nodoc
class _$UsernameFailureCopyWithImpl<$Res, $Val extends UsernameFailure>
    implements $UsernameFailureCopyWith<$Res> {
  _$UsernameFailureCopyWithImpl(this._value, this._then);

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
abstract class _$$_ShortUsernameCopyWith<$Res>
    implements $UsernameFailureCopyWith<$Res> {
  factory _$$_ShortUsernameCopyWith(
          _$_ShortUsername value, $Res Function(_$_ShortUsername) then) =
      __$$_ShortUsernameCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String failedValue});
}

/// @nodoc
class __$$_ShortUsernameCopyWithImpl<$Res>
    extends _$UsernameFailureCopyWithImpl<$Res, _$_ShortUsername>
    implements _$$_ShortUsernameCopyWith<$Res> {
  __$$_ShortUsernameCopyWithImpl(
      _$_ShortUsername _value, $Res Function(_$_ShortUsername) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = null,
  }) {
    return _then(_$_ShortUsername(
      failedValue: null == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ShortUsername implements _ShortUsername {
  const _$_ShortUsername({required this.failedValue});

  @override
  final String failedValue;

  @override
  String toString() {
    return 'UsernameFailure.shortUsername(failedValue: $failedValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ShortUsername &&
            (identical(other.failedValue, failedValue) ||
                other.failedValue == failedValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failedValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ShortUsernameCopyWith<_$_ShortUsername> get copyWith =>
      __$$_ShortUsernameCopyWithImpl<_$_ShortUsername>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String failedValue) shortUsername,
    required TResult Function(String failedValue) longUsername,
    required TResult Function(String failedValue) invalidCharacters,
  }) {
    return shortUsername(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String failedValue)? shortUsername,
    TResult? Function(String failedValue)? longUsername,
    TResult? Function(String failedValue)? invalidCharacters,
  }) {
    return shortUsername?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String failedValue)? shortUsername,
    TResult Function(String failedValue)? longUsername,
    TResult Function(String failedValue)? invalidCharacters,
    required TResult orElse(),
  }) {
    if (shortUsername != null) {
      return shortUsername(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShortUsername value) shortUsername,
    required TResult Function(_LongUsername value) longUsername,
    required TResult Function(_InvalidCharacters value) invalidCharacters,
  }) {
    return shortUsername(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ShortUsername value)? shortUsername,
    TResult? Function(_LongUsername value)? longUsername,
    TResult? Function(_InvalidCharacters value)? invalidCharacters,
  }) {
    return shortUsername?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShortUsername value)? shortUsername,
    TResult Function(_LongUsername value)? longUsername,
    TResult Function(_InvalidCharacters value)? invalidCharacters,
    required TResult orElse(),
  }) {
    if (shortUsername != null) {
      return shortUsername(this);
    }
    return orElse();
  }
}

abstract class _ShortUsername implements UsernameFailure {
  const factory _ShortUsername({required final String failedValue}) =
      _$_ShortUsername;

  @override
  String get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$_ShortUsernameCopyWith<_$_ShortUsername> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_LongUsernameCopyWith<$Res>
    implements $UsernameFailureCopyWith<$Res> {
  factory _$$_LongUsernameCopyWith(
          _$_LongUsername value, $Res Function(_$_LongUsername) then) =
      __$$_LongUsernameCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String failedValue});
}

/// @nodoc
class __$$_LongUsernameCopyWithImpl<$Res>
    extends _$UsernameFailureCopyWithImpl<$Res, _$_LongUsername>
    implements _$$_LongUsernameCopyWith<$Res> {
  __$$_LongUsernameCopyWithImpl(
      _$_LongUsername _value, $Res Function(_$_LongUsername) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = null,
  }) {
    return _then(_$_LongUsername(
      failedValue: null == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LongUsername implements _LongUsername {
  const _$_LongUsername({required this.failedValue});

  @override
  final String failedValue;

  @override
  String toString() {
    return 'UsernameFailure.longUsername(failedValue: $failedValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LongUsername &&
            (identical(other.failedValue, failedValue) ||
                other.failedValue == failedValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failedValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LongUsernameCopyWith<_$_LongUsername> get copyWith =>
      __$$_LongUsernameCopyWithImpl<_$_LongUsername>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String failedValue) shortUsername,
    required TResult Function(String failedValue) longUsername,
    required TResult Function(String failedValue) invalidCharacters,
  }) {
    return longUsername(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String failedValue)? shortUsername,
    TResult? Function(String failedValue)? longUsername,
    TResult? Function(String failedValue)? invalidCharacters,
  }) {
    return longUsername?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String failedValue)? shortUsername,
    TResult Function(String failedValue)? longUsername,
    TResult Function(String failedValue)? invalidCharacters,
    required TResult orElse(),
  }) {
    if (longUsername != null) {
      return longUsername(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShortUsername value) shortUsername,
    required TResult Function(_LongUsername value) longUsername,
    required TResult Function(_InvalidCharacters value) invalidCharacters,
  }) {
    return longUsername(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ShortUsername value)? shortUsername,
    TResult? Function(_LongUsername value)? longUsername,
    TResult? Function(_InvalidCharacters value)? invalidCharacters,
  }) {
    return longUsername?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShortUsername value)? shortUsername,
    TResult Function(_LongUsername value)? longUsername,
    TResult Function(_InvalidCharacters value)? invalidCharacters,
    required TResult orElse(),
  }) {
    if (longUsername != null) {
      return longUsername(this);
    }
    return orElse();
  }
}

abstract class _LongUsername implements UsernameFailure {
  const factory _LongUsername({required final String failedValue}) =
      _$_LongUsername;

  @override
  String get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$_LongUsernameCopyWith<_$_LongUsername> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_InvalidCharactersCopyWith<$Res>
    implements $UsernameFailureCopyWith<$Res> {
  factory _$$_InvalidCharactersCopyWith(_$_InvalidCharacters value,
          $Res Function(_$_InvalidCharacters) then) =
      __$$_InvalidCharactersCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String failedValue});
}

/// @nodoc
class __$$_InvalidCharactersCopyWithImpl<$Res>
    extends _$UsernameFailureCopyWithImpl<$Res, _$_InvalidCharacters>
    implements _$$_InvalidCharactersCopyWith<$Res> {
  __$$_InvalidCharactersCopyWithImpl(
      _$_InvalidCharacters _value, $Res Function(_$_InvalidCharacters) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = null,
  }) {
    return _then(_$_InvalidCharacters(
      failedValue: null == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_InvalidCharacters implements _InvalidCharacters {
  const _$_InvalidCharacters({required this.failedValue});

  @override
  final String failedValue;

  @override
  String toString() {
    return 'UsernameFailure.invalidCharacters(failedValue: $failedValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InvalidCharacters &&
            (identical(other.failedValue, failedValue) ||
                other.failedValue == failedValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failedValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InvalidCharactersCopyWith<_$_InvalidCharacters> get copyWith =>
      __$$_InvalidCharactersCopyWithImpl<_$_InvalidCharacters>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String failedValue) shortUsername,
    required TResult Function(String failedValue) longUsername,
    required TResult Function(String failedValue) invalidCharacters,
  }) {
    return invalidCharacters(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String failedValue)? shortUsername,
    TResult? Function(String failedValue)? longUsername,
    TResult? Function(String failedValue)? invalidCharacters,
  }) {
    return invalidCharacters?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String failedValue)? shortUsername,
    TResult Function(String failedValue)? longUsername,
    TResult Function(String failedValue)? invalidCharacters,
    required TResult orElse(),
  }) {
    if (invalidCharacters != null) {
      return invalidCharacters(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ShortUsername value) shortUsername,
    required TResult Function(_LongUsername value) longUsername,
    required TResult Function(_InvalidCharacters value) invalidCharacters,
  }) {
    return invalidCharacters(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ShortUsername value)? shortUsername,
    TResult? Function(_LongUsername value)? longUsername,
    TResult? Function(_InvalidCharacters value)? invalidCharacters,
  }) {
    return invalidCharacters?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ShortUsername value)? shortUsername,
    TResult Function(_LongUsername value)? longUsername,
    TResult Function(_InvalidCharacters value)? invalidCharacters,
    required TResult orElse(),
  }) {
    if (invalidCharacters != null) {
      return invalidCharacters(this);
    }
    return orElse();
  }
}

abstract class _InvalidCharacters implements UsernameFailure {
  const factory _InvalidCharacters({required final String failedValue}) =
      _$_InvalidCharacters;

  @override
  String get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$_InvalidCharactersCopyWith<_$_InvalidCharacters> get copyWith =>
      throw _privateConstructorUsedError;
}

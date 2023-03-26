// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'i_{{name.snakeCase()}}_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _${{name.pascalCase()}}ServiceMyMethodFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() myFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? myFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? myFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MyMethodMyFailure value) myFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MyMethodMyFailure value)? myFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MyMethodMyFailure value)? myFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class ${{name.pascalCase()}}ServiceMyMethodFailureCopyWith<$Res> {
  factory ${{name.pascalCase()}}ServiceMyMethodFailureCopyWith(
          {{name.pascalCase()}}ServiceMyMethodFailure value,
          $Res Function({{name.pascalCase()}}ServiceMyMethodFailure) then) =
      _${{name.pascalCase()}}ServiceMyMethodFailureCopyWithImpl<$Res,
          {{name.pascalCase()}}ServiceMyMethodFailure>;
}

/// @nodoc
class _${{name.pascalCase()}}ServiceMyMethodFailureCopyWithImpl<$Res,
        $Val extends {{name.pascalCase()}}ServiceMyMethodFailure>
    implements ${{name.pascalCase()}}ServiceMyMethodFailureCopyWith<$Res> {
  _${{name.pascalCase()}}ServiceMyMethodFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_MyMethodMyFailureCopyWith<$Res> {
  factory _$$_MyMethodMyFailureCopyWith(_$_MyMethodMyFailure value,
          $Res Function(_$_MyMethodMyFailure) then) =
      __$$_MyMethodMyFailureCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_MyMethodMyFailureCopyWithImpl<$Res>
    extends _${{name.pascalCase()}}ServiceMyMethodFailureCopyWithImpl<$Res,
        _$_MyMethodMyFailure> implements _$$_MyMethodMyFailureCopyWith<$Res> {
  __$$_MyMethodMyFailureCopyWithImpl(
      _$_MyMethodMyFailure _value, $Res Function(_$_MyMethodMyFailure) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_MyMethodMyFailure implements _MyMethodMyFailure {
  const _$_MyMethodMyFailure();

  @override
  String toString() {
    return '{{name.pascalCase()}}ServiceMyMethodFailure.myFailure()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_MyMethodMyFailure);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() myFailure,
  }) {
    return myFailure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? myFailure,
  }) {
    return myFailure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? myFailure,
    required TResult orElse(),
  }) {
    if (myFailure != null) {
      return myFailure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_MyMethodMyFailure value) myFailure,
  }) {
    return myFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MyMethodMyFailure value)? myFailure,
  }) {
    return myFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MyMethodMyFailure value)? myFailure,
    required TResult orElse(),
  }) {
    if (myFailure != null) {
      return myFailure(this);
    }
    return orElse();
  }
}

abstract class _MyMethodMyFailure implements {{name.pascalCase()}}ServiceMyMethodFailure {
  const factory _MyMethodMyFailure() = _$_MyMethodMyFailure;
}

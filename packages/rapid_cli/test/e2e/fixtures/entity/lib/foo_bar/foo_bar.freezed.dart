// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'foo_bar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FooBar {
  String get id => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FooBarCopyWith<FooBar> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FooBarCopyWith<$Res> {
  factory $FooBarCopyWith(FooBar value, $Res Function(FooBar) then) =
      _$FooBarCopyWithImpl<$Res, FooBar>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _$FooBarCopyWithImpl<$Res, $Val extends FooBar>
    implements $FooBarCopyWith<$Res> {
  _$FooBarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FooBarCopyWith<$Res> implements $FooBarCopyWith<$Res> {
  factory _$$_FooBarCopyWith(_$_FooBar value, $Res Function(_$_FooBar) then) =
      __$$_FooBarCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$_FooBarCopyWithImpl<$Res>
    extends _$FooBarCopyWithImpl<$Res, _$_FooBar>
    implements _$$_FooBarCopyWith<$Res> {
  __$$_FooBarCopyWithImpl(_$_FooBar _value, $Res Function(_$_FooBar) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$_FooBar(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_FooBar implements _FooBar {
  const _$_FooBar({required this.id});

  @override
  final String id;

  @override
  String toString() {
    return 'FooBar(id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FooBar &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FooBarCopyWith<_$_FooBar> get copyWith =>
      __$$_FooBarCopyWithImpl<_$_FooBar>(this, _$identity);
}

abstract class _FooBar implements FooBar {
  const factory _FooBar({required final String id}) = _$_FooBar;

  @override
  String get id;
  @override
  @JsonKey(ignore: true)
  _$$_FooBarCopyWith<_$_FooBar> get copyWith =>
      throw _privateConstructorUsedError;
}

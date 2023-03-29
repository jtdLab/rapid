// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '{{name.snakeCase()}}.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _${{name.pascalCase()}} {
  String get id => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  ${{name.pascalCase()}}CopyWith<{{name.pascalCase()}}> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class ${{name.pascalCase()}}CopyWith<$Res> {
  factory ${{name.pascalCase()}}CopyWith({{name.pascalCase()}} value, $Res Function({{name.pascalCase()}}) then) =
      _${{name.pascalCase()}}CopyWithImpl<$Res, {{name.pascalCase()}}>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _${{name.pascalCase()}}CopyWithImpl<$Res, $Val extends {{name.pascalCase()}}>
    implements ${{name.pascalCase()}}CopyWith<$Res> {
  _${{name.pascalCase()}}CopyWithImpl(this._value, this._then);

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
abstract class _$$_{{name.pascalCase()}}CopyWith<$Res> implements ${{name.pascalCase()}}CopyWith<$Res> {
  factory _$$_{{name.pascalCase()}}CopyWith(_$_{{name.pascalCase()}} value, $Res Function(_$_{{name.pascalCase()}}) then) =
      __$$_{{name.pascalCase()}}CopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$_{{name.pascalCase()}}CopyWithImpl<$Res> extends _${{name.pascalCase()}}CopyWithImpl<$Res, _$_{{name.pascalCase()}}>
    implements _$$_{{name.pascalCase()}}CopyWith<$Res> {
  __$$_{{name.pascalCase()}}CopyWithImpl(_$_{{name.pascalCase()}} _value, $Res Function(_$_{{name.pascalCase()}}) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$_{{name.pascalCase()}}(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_{{name.pascalCase()}} implements _{{name.pascalCase()}} {
  const _$_{{name.pascalCase()}}({required this.id});

  @override
  final String id;

  @override
  String toString() {
    return '{{name.pascalCase()}}(id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_{{name.pascalCase()}} &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_{{name.pascalCase()}}CopyWith<_$_{{name.pascalCase()}}> get copyWith =>
      __$$_{{name.pascalCase()}}CopyWithImpl<_$_{{name.pascalCase()}}>(this, _$identity);
}

abstract class _{{name.pascalCase()}} implements {{name.pascalCase()}} {
  const factory _{{name.pascalCase()}}({required final String id}) = _$_{{name.pascalCase()}};

  @override
  String get id;
  @override
  @JsonKey(ignore: true)
  _$$_{{name.pascalCase()}}CopyWith<_$_{{name.pascalCase()}}> get copyWith =>
      throw _privateConstructorUsedError;
}

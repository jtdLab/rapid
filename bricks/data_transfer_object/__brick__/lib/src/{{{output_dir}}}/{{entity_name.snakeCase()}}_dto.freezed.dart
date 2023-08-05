// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '{{entity_name.snakeCase()}}_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

{{entity_name.pascalCase()}}Dto _${{entity_name.pascalCase()}}DtoFromJson(Map<String, dynamic> json) {
  return _{{entity_name.pascalCase()}}Dto.fromJson(json);
}

/// @nodoc
mixin _${{entity_name.pascalCase()}}Dto {
  String get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  ${{entity_name.pascalCase()}}DtoCopyWith<{{entity_name.pascalCase()}}Dto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class ${{entity_name.pascalCase()}}DtoCopyWith<$Res> {
  factory ${{entity_name.pascalCase()}}DtoCopyWith({{entity_name.pascalCase()}}Dto value, $Res Function({{entity_name.pascalCase()}}Dto) then) =
      _${{entity_name.pascalCase()}}DtoCopyWithImpl<$Res, {{entity_name.pascalCase()}}Dto>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _${{entity_name.pascalCase()}}DtoCopyWithImpl<$Res, $Val extends {{entity_name.pascalCase()}}Dto>
    implements ${{entity_name.pascalCase()}}DtoCopyWith<$Res> {
  _${{entity_name.pascalCase()}}DtoCopyWithImpl(this._value, this._then);

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
abstract class _$$_{{entity_name.pascalCase()}}DtoCopyWith<$Res> implements ${{entity_name.pascalCase()}}DtoCopyWith<$Res> {
  factory _$$_{{entity_name.pascalCase()}}DtoCopyWith(
          _$_{{entity_name.pascalCase()}}Dto value, $Res Function(_$_{{entity_name.pascalCase()}}Dto) then) =
      __$$_{{entity_name.pascalCase()}}DtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$_{{entity_name.pascalCase()}}DtoCopyWithImpl<$Res>
    extends _${{entity_name.pascalCase()}}DtoCopyWithImpl<$Res, _$_{{entity_name.pascalCase()}}Dto>
    implements _$$_{{entity_name.pascalCase()}}DtoCopyWith<$Res> {
  __$$_{{entity_name.pascalCase()}}DtoCopyWithImpl(
      _$_{{entity_name.pascalCase()}}Dto _value, $Res Function(_$_{{entity_name.pascalCase()}}Dto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$_{{entity_name.pascalCase()}}Dto(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_{{entity_name.pascalCase()}}Dto extends _{{entity_name.pascalCase()}}Dto {
  const _$_{{entity_name.pascalCase()}}Dto({required this.id}) : super._();

  factory _$_{{entity_name.pascalCase()}}Dto.fromJson(Map<String, dynamic> json) =>
      _$$_{{entity_name.pascalCase()}}DtoFromJson(json);

  @override
  final String id;

  @override
  String toString() {
    return '{{entity_name.pascalCase()}}Dto(id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_{{entity_name.pascalCase()}}Dto &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_{{entity_name.pascalCase()}}DtoCopyWith<_$_{{entity_name.pascalCase()}}Dto> get copyWith =>
      __$$_{{entity_name.pascalCase()}}DtoCopyWithImpl<_$_{{entity_name.pascalCase()}}Dto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_{{entity_name.pascalCase()}}DtoToJson(
      this,
    );
  }
}

abstract class _{{entity_name.pascalCase()}}Dto extends {{entity_name.pascalCase()}}Dto {
  const factory _{{entity_name.pascalCase()}}Dto({required final String id}) = _$_{{entity_name.pascalCase()}}Dto;
  const _{{entity_name.pascalCase()}}Dto._() : super._();

  factory _{{entity_name.pascalCase()}}Dto.fromJson(Map<String, dynamic> json) = _$_{{entity_name.pascalCase()}}Dto.fromJson;

  @override
  String get id;
  @override
  @JsonKey(ignore: true)
  _$$_{{entity_name.pascalCase()}}DtoCopyWith<_$_{{entity_name.pascalCase()}}Dto> get copyWith =>
      throw _privateConstructorUsedError;
}

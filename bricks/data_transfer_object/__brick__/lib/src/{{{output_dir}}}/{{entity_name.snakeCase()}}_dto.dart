import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name}}_domain{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}/{{project_name}}_domain{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}.dart';

part '{{entity_name.snakeCase()}}_dto.freezed.dart';
part '{{entity_name.snakeCase()}}_dto.g.dart';

@freezed
class {{entity_name.pascalCase()}}Dto with _${{entity_name.pascalCase()}}Dto {
  const factory {{entity_name.pascalCase()}}Dto({
    required String id,
    // TODO: add more fields here
  }) = _{{entity_name.pascalCase()}}Dto;

  factory {{entity_name.pascalCase()}}Dto.fromDomain({{entity_name.pascalCase()}} domain) {
    return {{entity_name.pascalCase()}}Dto(
      id: domain.id,
    );
  }

  factory {{entity_name.pascalCase()}}Dto.fromJson(Map<String, dynamic> json) =>
      _${{entity_name.pascalCase()}}DtoFromJson(json);

  const {{entity_name.pascalCase()}}Dto._();

  {{entity_name.pascalCase()}} toDomain() {
    return {{entity_name.pascalCase()}}(
      id: id,
    );
  }
}

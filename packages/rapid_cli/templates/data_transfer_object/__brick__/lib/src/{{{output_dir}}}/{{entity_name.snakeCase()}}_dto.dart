import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:{{project_name}}_domain{{#has_subinfrastructure_name}}_{{subinfrastructure_name}}{{/has_subinfrastructure_name}}{{^output_dir_is_cwd}}/{{{output_dir}}}{{/output_dir_is_cwd}}/{{entity_name.snakeCase()}}.dart';

part '{{entity_name.snakeCase()}}_dto.freezed.dart';
part '{{entity_name.snakeCase()}}_dto.g.dart';

@freezed
class {{entity_name.pascalCase()}}Dto with _${{entity_name.pascalCase()}}Dto {
  const factory {{entity_name.pascalCase()}}Dto({
    required String id,
    // TODO: more fields
  }) = _{{entity_name.pascalCase()}}Dto;

  const {{entity_name.pascalCase()}}Dto._();

  factory {{entity_name.pascalCase()}}Dto.fromDomain({{entity_name.pascalCase()}} domain) {
    return {{entity_name.pascalCase()}}Dto(
      id: domain.id,
      // TODO: more fields
    );
  }

  {{entity_name.pascalCase()}} toDomain() {
    return {{entity_name.pascalCase()}}(
      id: id,
      // TODO: more fields
    );
  }

  factory {{entity_name.pascalCase()}}Dto.fromJson(Map<String, dynamic> json) =>
      _${{entity_name.pascalCase()}}DtoFromJson(json);
}

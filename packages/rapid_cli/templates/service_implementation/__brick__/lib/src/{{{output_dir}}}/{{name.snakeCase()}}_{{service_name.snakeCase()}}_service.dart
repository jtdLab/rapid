// import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name}}_domain{{#has_subinfrastructure_name}}_{{subinfrastructure_name}}{{/has_subinfrastructure_name}}{{^output_dir_is_cwd}}/{{{output_dir}}}{{/output_dir_is_cwd}}/i_{{service_name.snakeCase()}}_service.dart';

// TODO: description
@dev
@LazySingleton(as: I{{service_name.pascalCase()}}Service)
class {{name.pascalCase()}}{{service_name.pascalCase()}}Service implements I{{service_name.pascalCase()}}Service {
  // TODO: implement
}
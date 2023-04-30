// import 'package:dartz/dartz.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

part '{{#snakeCase}}i_{{name}}_service{{/snakeCase}}.freezed.dart';

// TODO: description
abstract class I{{name.pascalCase()}}Service {
  // TODO: add service methods
}

// TODO: add failure unions for each service method like:
/* /// Failure union that belongs to [I{{name.pascalCase()}}Service.myMethod].
@freezed
class {{name.pascalCase()}}ServiceMyMethodFailure with _${{name.pascalCase()}}ServiceMyMethodFailure {
  const factory {{name.pascalCase()}}ServiceMyMethodFailure.myFailure() = _MyMethodMyFailure;
  // TODO: add more failure cases
} */

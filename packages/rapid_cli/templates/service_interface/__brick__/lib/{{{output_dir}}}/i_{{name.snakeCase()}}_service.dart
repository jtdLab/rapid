import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{#snakeCase}}i_{{name}}_service{{/snakeCase}}.freezed.dart';

// TODO: Description
abstract class I{{name.pascalCase()}}Service {
  Either<{{name.pascalCase()}}ServiceMyMethodFailure, dynamic> myMethod();
  // TODO more service methods
}

/// Failure union that belongs to [I{{name.pascalCase()}}Service.myMethod].
@freezed
class {{name.pascalCase()}}ServiceMyMethodFailure with _${{name.pascalCase()}}ServiceMyMethodFailure {
  const factory {{name.pascalCase()}}ServiceMyMethodFailure.myFailure() = _MyMethodMyFailure;
  // TODO more failure cases
}

// TODO more failure unions
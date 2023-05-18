// import 'package:dartz/dartz.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

part '{{#snakeCase}}i_{{name}}_service{{/snakeCase}}.freezed.dart';

// TODO: description
abstract class I{{name.pascalCase()}}Service {
  // TODO: add service methods
}

// TODO: add failure unions for each service method like:
/* /// Failure union that belongs to [I{{name.pascalCase()}}Service.myMethod].
sealed class {{name.pascalCase()}}ServiceMyMethodFailure {}

final class {{name.pascalCase()}}ServiceMyMethodMyFailure extends {{name.pascalCase()}}ServiceMyMethodFailure {}
*/

// TODO: add failures that are shared across multiple method specific failures.
/*
final class {{name.pascalCase()}}ServiceMySharedFailure implements {{name.pascalCase()}}ServiceMyMethodFailure {}
*/

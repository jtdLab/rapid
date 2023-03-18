import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name.snakeCase()}}_domain/{{service_name.snakeCase()}}/i_{{service_name.snakeCase()}}_service.dart';

// TODO: description
@dev
@LazySingleton(as: I{{service_name.pascalCase()}}Service)
class {{name.pascalCase()}}{{service_name.pascalCase()}}Service implements I{{service_name.pascalCase()}}Service {
 @override
  Either<{{service_name.pascalCase()}}ServiceMyMethodFailure, dynamic> myMethod() {
    // TODO: implement
    throw UnimplementedError();
  }
}
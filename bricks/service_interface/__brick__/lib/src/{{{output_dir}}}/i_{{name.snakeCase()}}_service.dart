import 'package:freezed_annotation/freezed_annotation.dart';

part 'i_{{name.snakeCase()}}_service.freezed.dart';

abstract class I{{name.pascalCase()}}Service {
  MyMethodResult myMethod();

  // TODO: add more service methods
}

sealed class MyMethodResult {
  const MyMethodResult();
}

@freezed
class MyMethodSuccess extends MyMethodResult with _$MyMethodSuccess {
  const factory MyMethodSuccess(String value) = _MyMethodSuccess;
  const MyMethodSuccess._();
}

@freezed
sealed class MyMethodFailure extends MyMethodResult with _$MyMethodFailure {
  const MyMethodFailure._();
  const factory MyMethodFailure.foo() = MyMethodFailureFoo;
  // TODO: add more failure cases here
}

// TODO: add more service method results here

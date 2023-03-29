import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'i_foo_bar_service.freezed.dart';

// TODO: Description
abstract class IFooBarService {
  Either<FooBarServiceMyMethodFailure, dynamic> myMethod();
  // TODO more service methods
}

/// Failure union that belongs to [IFooBarService.myMethod].
@freezed
class FooBarServiceMyMethodFailure with _$FooBarServiceMyMethodFailure {
  const factory FooBarServiceMyMethodFailure.myFailure() = _MyMethodMyFailure;
  // TODO more failure cases
}

// TODO more failure unions

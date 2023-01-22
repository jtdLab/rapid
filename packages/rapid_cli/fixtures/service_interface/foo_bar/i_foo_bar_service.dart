import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'i_foo_bar_service.freezed.dart';

// TODO: Description
abstract class IFooBarService {
  Either<FooBarServiceMethod1Failure, dynamic> method1();
  Future<Either<FooBarServiceMethod2Failure, dynamic>> method2();
}

/// Failure union that belongs to [IFooBarService.method1].
@freezed
class FooBarServiceMethod1Failure with _$FooBarServiceMethod1Failure {
  const factory FooBarServiceMethod1Failure.failureA() = _Method1FailureA;
  const factory FooBarServiceMethod1Failure.failureB() = _Method1FailureB;
}

/// Failure union that belongs to [IFooBarService.method2].
@freezed
class FooBarServiceMethod2Failure with _$FooBarServiceMethod2Failure {
  const factory FooBarServiceMethod2Failure.failureA() = _Method2FailureA;
  const factory FooBarServiceMethod2Failure.failureB() = _Method2FailureB;
}

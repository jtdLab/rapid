import 'package:dartz/dartz.dart';
import 'package:rapid_domain/rapid_domain.dart';
import 'package:test/test.dart';

HoldsValue holdsValue<T>(T value) => HoldsValue(value);

class HoldsValue<T> extends CustomMatcher {
  HoldsValue(T value)
      : super("Value object holding value", "value", right(value));

  @override
  featureValueOf(actual) => (actual as ValueObject).value;
}

HoldsFailure holdsFailure(ValueFailure failure) => HoldsFailure(failure);

class HoldsFailure extends CustomMatcher {
  HoldsFailure(ValueFailure failure)
      : super("Value object holding failure", "failure", left(failure));

  @override
  featureValueOf(actual) => (actual as ValueObject).value;
}

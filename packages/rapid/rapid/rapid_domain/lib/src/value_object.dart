import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

/// This error indicates that the caller tried to get the value of a invalid [ValueObject].
class UnexpectedValueError extends StateError {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure)
      : super(
          Error.safeToString(
            'ValueFailure occurred at an unrecovarable point. Failure was: $valueFailure',
          ),
        );
}

/// Base class of all value failures.
///
/// Holds a value that failed a [ValueObject]s validation.
abstract class ValueFailure<T> {
  T get failedValue;
}

/// {@template value_object}
/// Base class of all value objects.
///
/// Holding either [T] or a [ValueFailure] if failed validation.
/// {@endtemplate}
@immutable
abstract class ValueObject<T> {
  /// {@macro value_object}
  const ValueObject();

  Either<ValueFailure, T> get value;

  /// Returns the value of this value object.
  ///
  /// Throws [UnexpectedValueError] if this contains a [ValueFailure].
  T getOrCrash() {
    return value.fold((f) => throw UnexpectedValueError(f), id);
  }

  bool isValid() => value.isRight();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

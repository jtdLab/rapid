import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rapid_domain/rapid_domain.dart';

part '{{name.snakeCase()}}.freezed.dart';

/// {@template {{name.snakeCase()}}}
/// ***Valid***:
///
/// TODO: valid cases
///
/// ---
///
/// ***Invalid***:
///
/// TODO: invalid cases
/// {@endtemplate}
class {{name.pascalCase()}}{{{generics}}} extends ValueObject<{{{type}}}> {
  @override
  final Either<{{name.pascalCase()}}Failure, {{{type}}}> value;

  /// {@macro {{name.snakeCase()}}}
  factory {{name.pascalCase()}}({{{type}}} raw) {
    return {{name.pascalCase()}}._(_validate(raw));
  }

  /// Returns a random instance.
  ///
  /// If [isValid] holds value else holds failure.
  factory {{name.pascalCase()}}.random({bool isValid = true}) {
    final faker = Faker();

    if (isValid) {
      // TODO: implement: return instance holding random value
      throw UnimplementedError();
    } else {
      // TODO: implement: return instance holding random failure
      throw UnimplementedError();
    }
  }

  const {{name.pascalCase()}}._(this.value);

  /// ***Returns [raw]***:
  ///
  /// TODO: valid cases
  ///
  /// ---
  ///
  /// ***Returns [{{name.pascalCase()}}Failure]***:
  ///
  /// TODO: invalid cases
  static Either<{{name.pascalCase()}}Failure, {{{type}}}> _validate{{{generics}}}({{{type}}} raw) {
    // TODO: implement validation
    throw UnimplementedError();
  }

  @override
  String toString() => value.fold(
        (failure) => '{{name.pascalCase()}}(failure: $failure)',
        (value) => '{{name.pascalCase()}}(value: $value)',
      );
}

/// [ValueFailure] union that belongs to [{{name.pascalCase()}}].
@freezed
class {{name.pascalCase()}}Failure{{{generics}}} extends ValueFailure<{{{type}}}>
    with _${{name.pascalCase()}}Failure{{{generics}}} {
  const factory {{name.pascalCase()}}Failure.failureA({
    required {{{type}}} failedValue,
  }) = _FailureA;
  // TODO: add more failure cases
}

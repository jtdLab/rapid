import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rapid_domain/rapid_domain.dart';

part 'password.freezed.dart';

/// {@template password}
/// ***Valid***:
///
/// Length 6-32, no white-space characters
///
/// ---
///
/// ***Invalid***:
///
/// Length < 6
///
/// Length > 32
///
/// Containing white spaces
/// {@endtemplate}
class Password extends ValueObject<String> {
  @override
  final Either<PasswordFailure, String> value;

  /// {@macro password}
  factory Password(String raw) {
    return Password._(_validate(raw));
  }

  factory Password.empty() {
    return Password('');
  }

  /// Returns a random instance.
  ///
  /// If [isValid] holds value else holds failure.
  factory Password.random({bool isValid = true}) {
    final faker = Faker();

    if (isValid) {
      return Password(
        faker.randomGenerator.amount((_) => 'a', 32, min: 6).join(),
      );
    } else {
      return Password(
        faker.randomGenerator.element([
          faker.randomGenerator.amount((_) => 'a', 5, min: 0).join(),
          faker.randomGenerator.amount((_) => 'a', 40, min: 33).join(),
          faker.randomGenerator.amount((_) => 'a', 8, min: 6).join(' '),
        ]),
      );
    }
  }

  const Password._(this.value);

  /// ***Returns [raw]***:
  ///
  /// Length 6-32, no white-space characters
  ///
  /// ---
  ///
  /// ***Returns [PasswordFailure]***:
  ///
  /// Length < 6
  ///
  /// Length > 32
  ///
  /// Containing white spaces
  static Either<PasswordFailure, String> _validate(String raw) {
    if (raw.length < 6) {
      return left(PasswordFailure.shortPassword(failedValue: raw));
    } else if (raw.length > 32) {
      return left(PasswordFailure.longPassword(failedValue: raw));
    } else {
      if (!raw.contains(' ')) {
        return right(raw);
      } else {
        return left(PasswordFailure.invalidWhitespaces(failedValue: raw));
      }
    }
  }

  @override
  String toString() => value.fold(
        (failure) => 'Password(failure: $failure)',
        (value) => 'Password(value: $value)',
      );
}

/// [ValueFailure] union that belongs to [Password].
@freezed
class PasswordFailure extends ValueFailure<String> with _$PasswordFailure {
  const factory PasswordFailure.shortPassword({
    required String failedValue,
  }) = _ShortPassword;
  const factory PasswordFailure.longPassword({
    required String failedValue,
  }) = _LongPassword;
  const factory PasswordFailure.invalidWhitespaces({
    required String failedValue,
  }) = _InvalidWhitespaces;
}

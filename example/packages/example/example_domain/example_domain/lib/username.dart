import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rapid_domain/rapid_domain.dart';

part 'username.freezed.dart';

/// {@template username}
/// ***Valid***:
///
///  Length 3-15, alphabetical or numerical characters or [_.-]
///
/// ---
///
/// ***Invalid***:
///
/// Length < 3
///
/// Length > 15
///
/// Containing special characters that are not [_.-]
/// {@endtemplate}
class Username extends ValueObject<String> {
  @override
  final Either<UsernameFailure, String> value;

  /// {@macro username}
  factory Username(String raw) {
    return Username._(_validate(raw));
  }

  factory Username.empty() {
    return Username('');
  }

  /// Returns a random instance.
  ///
  /// If [isValid] holds value else holds failure.
  factory Username.random({bool isValid = true}) {
    final faker = Faker();

    if (isValid) {
      return Username(
        faker.randomGenerator.amount((_) => 'a', 15, min: 3).join(),
      );
    } else {
      return Username(
        faker.randomGenerator.element([
          faker.randomGenerator.amount((_) => 'a', 3, min: 0).join(),
          faker.randomGenerator.amount((_) => 'a', 20, min: 16).join(),
          faker.randomGenerator.amount((_) => 'a', 6, min: 4).join('*'),
        ]),
      );
    }
  }

  const Username._(this.value);

  /// ***Returns [raw]***:
  ///
  ///  Length 3-15, alphabetical or numerical characters or [_.-]
  ///
  /// ---
  ///
  /// ***Returns [UsernameFailure]***:
  ///
  /// Length < 3
  ///
  /// Length > 15
  ///
  /// Containing special characters that are not [_.-]
  static Either<UsernameFailure, String> _validate(String raw) {
    if (raw.length < 3) {
      return left(UsernameFailure.shortUsername(failedValue: raw));
    } else if (raw.length > 15) {
      return left(UsernameFailure.longUsername(failedValue: raw));
    } else {
      const usernameRegex = r"""^[a-zA-Z0-9_.-]*$""";
      if (RegExp(usernameRegex).hasMatch(raw)) {
        return right(raw);
      } else {
        return left(UsernameFailure.invalidCharacters(failedValue: raw));
      }
    }
  }

  @override
  String toString() => value.fold(
        (failure) => 'Username(failure: $failure)',
        (value) => 'Username(value: $value)',
      );
}

/// [ValueFailure] union that belongs to [Username].
@freezed
class UsernameFailure extends ValueFailure<String> with _$UsernameFailure {
  const factory UsernameFailure.shortUsername({
    required String failedValue,
  }) = _ShortUsername;
  const factory UsernameFailure.longUsername({
    required String failedValue,
  }) = _LongUsername;
  const factory UsernameFailure.invalidCharacters({
    required String failedValue,
  }) = _InvalidCharacters;
}

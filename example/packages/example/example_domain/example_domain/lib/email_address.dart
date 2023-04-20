import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rapid_domain/rapid_domain.dart';

part 'email_address.freezed.dart';

/// {@template email_address}
/// ***Valid***:
///
/// Valid email address.
///
/// ---
///
/// ***Invalid***:
///
/// Invalid email address
///
/// {@endtemplate}
class EmailAddress extends ValueObject<String> {
  @override
  final Either<EmailAddressFailure, String> value;

  /// {@macro email_address}
  factory EmailAddress(String raw) {
    return EmailAddress._(_validate(raw));
  }

  factory EmailAddress.empty() {
    return EmailAddress('');
  }

  /// Returns a random instance.
  ///
  /// If [isValid] holds value else holds failure.
  factory EmailAddress.random({bool isValid = true}) {
    final faker = Faker();

    if (isValid) {
      return EmailAddress(faker.internet.email());
    } else {
      return EmailAddress(faker.randomGenerator.string(1));
    }
  }

  const EmailAddress._(this.value);

  /// ***Returns [raw]***:
  ///
  /// Valid email address.
  ///
  /// ---
  ///
  /// ***Returns [EmailAddressFailure]***:
  ///
  /// Invalid email address
  static Either<EmailAddressFailure, String> _validate(String raw) {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
    if (RegExp(emailRegex).hasMatch(raw)) {
      return right(raw);
    } else {
      return left(EmailAddressFailure.invalidEmail(failedValue: raw));
    }
  }

  @override
  String toString() => value.fold(
        (failure) => 'EmailAddress(failure: $failure)',
        (value) => 'EmailAddress(value: $value)',
      );
}

/// [ValueFailure] union that belongs to [EmailAddress].
@freezed
class EmailAddressFailure extends ValueFailure<String>
    with _$EmailAddressFailure {
  const factory EmailAddressFailure.invalidEmail({
    required String failedValue,
  }) = _InvalidEmail;
}

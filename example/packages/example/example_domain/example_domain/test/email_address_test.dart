import 'package:dartz/dartz.dart';
import 'package:example_domain/email_address.dart';
import 'package:test/test.dart';

void main() {
  group('EmailAddress', () {
    group('.()', () {
      group('(valid)', () {
        test('', () {
          // Arrange + Act
          final emailAddress = EmailAddress('foo@bar.com');

          // Assert
          expect(emailAddress.value, right('foo@bar.com'));
        });
      });

      group('(invalid)', () {
        test('', () {
          // Arrange + Act
          final emailAddress = EmailAddress('foo');

          // Assert
          expect(
            emailAddress.value,
            left(EmailAddressFailure.invalidEmail(failedValue: 'foo')),
          );
        });
      });
    });

    group('.empty()', () {
      test('', () {
        // Arrange + Act
        final emailAddress = EmailAddress.empty();

        // Assert
        expect(
          emailAddress.value,
          left(EmailAddressFailure.invalidEmail(failedValue: '')),
        );
      });
    });

    group('.random()', () {
      test('(valid)', () {
        // Arrange + Act
        final emailAddress = EmailAddress.random(isValid: true);

        // Assert
        expect(emailAddress.value, isA<Right>());
      });

      test('(invalid)', () {
        // Arrange + Act
        final emailAddress = EmailAddress.random(isValid: false);

        // Assert
        expect(emailAddress.value, isA<Left>());
      });
    });

    group('.toString()', () {
      test('(valid)', () {
        // Arrange + Act
        final emailAddress = EmailAddress('foo@bar.com');

        // Assert
        expect(emailAddress.toString(), 'EmailAddress(value: foo@bar.com)');
      });

      test('(invalid)', () {
        // Arrange + Act
        final emailAddress = EmailAddress('foo');

        // Assert
        expect(
          emailAddress.toString(),
          'EmailAddress(failure: EmailAddressFailure.invalidEmail(failedValue: foo))',
        );
      });
    });
  });
}

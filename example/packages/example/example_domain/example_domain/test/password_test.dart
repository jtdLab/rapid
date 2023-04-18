import 'package:dartz/dartz.dart';
import 'package:example_domain/password.dart';
import 'package:test/test.dart';

void main() {
  group('Password', () {
    group('.()', () {
      group('(valid)', () {
        test('6 characters ', () {
          // Arrange + Act
          final password = Password('abc123');

          // Assert
          expect(password.value, right('abc123'));
        });

        test('32 characters ', () {
          // Arrange + Act
          final password = Password('abc123abc456abc123abc456abc123ab');

          // Assert
          expect(password.value, right('abc123abc456abc123abc456abc123ab'));
        });
      });

      group('(invalid)', () {
        test('short', () {
          // Arrange + Act
          final password = Password('abc12');

          // Assert
          expect(
            password.value,
            left(PasswordFailure.shortPassword(failedValue: 'abc12')),
          );
        });

        test('long', () {
          // Arrange + Act
          final password = Password('abc123abc456abc123abc456abc123abc');

          // Assert
          expect(
            password.value,
            left(
              PasswordFailure.longPassword(
                failedValue: 'abc123abc456abc123abc456abc123abc',
              ),
            ),
          );
        });

        test('invalid whitespaces', () {
          // Arrange + Act
          final password = Password('abc 123');

          // Assert
          expect(
            password.value,
            left(PasswordFailure.invalidWhitespaces(failedValue: 'abc 123')),
          );
        });
      });
    });

    group('.empty()', () {
      test('', () {
        // Arrange + Act
        final password = Password.empty();

        // Assert
        expect(
          password.value,
          left(PasswordFailure.shortPassword(failedValue: '')),
        );
      });
    });

    group('.random()', () {
      test('(valid)', () {
        // Arrange + Act
        final password = Password.random(isValid: true);

        // Assert
        expect(password.value, isA<Right>());
      });

      test('(invalid)', () {
        // Arrange + Act
        final password = Password.random(isValid: false);

        // Assert
        expect(password.value, isA<Left>());
      });
    });

    group('.toString()', () {
      test('(valid)', () {
        // Arrange + Act
        final password = Password('abc123');

        // Assert
        expect(password.toString(), 'Password(value: abc123)');
      });

      test('(invalid)', () {
        // Arrange + Act
        final password = Password('abc');

        // Assert
        expect(
          password.toString(),
          'Password(failure: PasswordFailure.shortPassword(failedValue: abc))',
        );
      });
    });
  });
}

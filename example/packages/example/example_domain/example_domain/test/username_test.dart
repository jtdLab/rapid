import 'package:dartz/dartz.dart';
import 'package:example_domain/username.dart';
import 'package:test/test.dart';

void main() {
  group('Username', () {
    group('.()', () {
      group('(valid)', () {
        test('3 characters ', () {
          // Arrange + Act
          final username = Username('abc');

          // Assert
          expect(username.value, right('abc'));
        });

        test('15 characters ', () {
          // Arrange + Act
          final username = Username('abc123abc456abc');

          // Assert
          expect(username.value, right('abc123abc456abc'));
        });
      });

      group('(invalid)', () {
        test('short', () {
          // Arrange + Act
          final username = Username('ab');

          // Assert
          expect(
            username.value,
            left(UsernameFailure.shortUsername(failedValue: 'ab')),
          );
        });

        test('long', () {
          // Arrange + Act
          final password = Username('abc123abc456abc1');

          // Assert
          expect(
            password.value,
            left(UsernameFailure.longUsername(failedValue: 'abc123abc456abc1')),
          );
        });

        test('invalid whitespaces', () {
          // Arrange + Act
          final username = Username('abc*123');

          // Assert
          expect(
            username.value,
            left(UsernameFailure.invalidCharacters(failedValue: 'abc*123')),
          );
        });
      });
    });

    group('.empty()', () {
      test('', () {
        // Arrange + Act
        final username = Username.empty();

        // Assert
        expect(
          username.value,
          left(UsernameFailure.shortUsername(failedValue: '')),
        );
      });
    });

    group('.random()', () {
      test('(valid)', () {
        // Arrange + Act
        final username = Username.random(isValid: true);

        // Assert
        expect(username.value, isA<Right>());
      });

      test('(invalid)', () {
        // Arrange + Act
        final username = Username.random(isValid: false);

        // Assert
        expect(username.value, isA<Left>());
      });
    });

    group('.toString()', () {
      test('(valid)', () {
        // Arrange + Act
        final username = Username('abc');

        // Assert
        expect(username.toString(), 'Username(value: abc)');
      });

      test('(invalid)', () {
        // Arrange + Act
        final username = Username('ab');

        // Assert
        expect(
          username.toString(),
          'Username(failure: UsernameFailure.shortUsername(failedValue: ab))',
        );
      });
    });
  });
}

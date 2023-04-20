import 'package:test/test.dart';
import 'package:example_infrastructure/src/fake_auth_service.dart';

void main() {
  group('FakeAuthService', () {
    test('.()', () {
      // Act
      final fakeAuthService = FakeAuthService();

      // Assert
      expect(fakeAuthService, isNotNull);
    });

    group('.myMethod()', () {
      test('TODO description', () {
        // TODO implement
      });
    });
  });
}

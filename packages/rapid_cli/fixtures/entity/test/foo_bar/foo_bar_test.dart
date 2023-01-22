import 'package:test/test.dart';
import 'package:project_none_domain/foo_bar/foo_bar.dart';

void main() {
  group('FooBar', () {
    late String id;
    // late SomeType property;
    // late SomeType nullableProperty;
    // ...

    setUp(() {
      // Set non null default values
      id = 'my_id';
      // property = myValue;
      // nullableProperty = myValue2;
    });

    // Returns FooBar created using the . constructor
    FooBar getInstance() {
      return FooBar(id: id);
    }

    group('.', () {
      late FooBar underTest;

      test(
          'GIVEN all params are not null '
          'THEN assigns all params correctly.', () {
        // Arrange + Act
        underTest = getInstance();

        // Assert
        expect(underTest.id, id);
        // expect(underTest.property, property);
        // expect(underTest.nullableProperty, nullableProperty);
      });

      test(
          'GIVEN all nullable params are null '
          'THEN assigns all params correctly.', () {
        // Arrange
        // nullableProperty = null;

        // Act
        underTest = getInstance();

        // Assert
        // expect(underTest.property, property);
        // expect(underTest.nullableProperty, nullableProperty);
      });
    });

    group('.dummy', () {
      late FooBar underTest;

      test('Returns instance of FooBar.', () {
        // Arrange + Act
        underTest = FooBar.dummy();

        // Assert
        expect(underTest, isA<FooBar>());
      });

      test(
        'GIVEN instance1 and instance2 created using dummy constructor '
        'THEN instance1 is not equal to instance2.',
        () {
          // Arrange
          final instance1 = FooBar.dummy();
          final instance2 = FooBar.dummy();

          //  Act + Assert
          expect(instance1 == instance2, false);
        },
        retry: 5,
      );
    });

    /// ... test other methods here
  });
}

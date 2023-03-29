import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_domain/src/value_object.dart';
import 'package:test/test.dart';

class FakeObject extends Fake implements Object {}

class FakeValueFailure<T> extends Fake implements ValueFailure<T> {}

class _ValueObjectMock<T> extends ValueObject<T> {
  final Either<ValueFailure, T> _value;

  _ValueObjectMock(Either<ValueFailure, T> value) : _value = value;

  @override
  Either<ValueFailure, T> get value => _value;
}

ValueObject _valueObject<T>(Either<ValueFailure, T> value) {
  return _ValueObjectMock(value);
}

void main() {
  group('ValueObject', () {
    group('.getOrCrash()', () {
      test('returns value', () {
        final valueObject = _valueObject(Right(42));
        expect(valueObject.getOrCrash(), 42);
      });

      test('throws UnexpectedValueError', () {
        final valueObject = _valueObject(Left(FakeValueFailure()));
        expect(
          () => valueObject.getOrCrash(),
          throwsA(isA<UnexpectedValueError>()),
        );
      });
    });

    group('.isValid()', () {
      test('returns true', () {
        final valueObject = _valueObject(Right(42));
        expect(valueObject.isValid(), true);
      });

      test('returns false', () {
        final valueObject = _valueObject(Left(FakeValueFailure()));
        expect(valueObject.isValid(), false);
      });
    });

    group('==', () {
      test('returns true (values)', () {
        final object = FakeObject();
        final valueObject1 = _valueObject(Right(object));
        final valueObject2 = _valueObject(Right(object));
        expect(valueObject1 == valueObject2, true);
      });

      test('returns true (failures)', () {
        final failure = FakeValueFailure();
        final valueObject1 = _valueObject(Right(failure));
        final valueObject2 = _valueObject(Right(failure));
        expect(valueObject1 == valueObject2, true);
      });

      test('returns false (values)', () {
        final valueObject1 = _valueObject(Right(FakeObject()));
        final valueObject2 = _valueObject(Right(FakeObject()));
        expect(valueObject1 == valueObject2, false);
      });

      test('returns false (failures)', () {
        final valueObject1 = _valueObject(Right(FakeValueFailure()));
        final valueObject2 = _valueObject(Right(FakeValueFailure()));
        expect(valueObject1 == valueObject2, false);
      });
    });

    group('.hashCode', () {
      test('returns hashCode of value', () {
        final object = FakeObject();
        final valueObject = _valueObject(Right(object));
        expect(valueObject.hashCode, object.hashCode);
      });

      test('returns hashCode of failure', () {
        final failure = FakeValueFailure();
        final valueObject = _valueObject(Left(failure));
        expect(valueObject.hashCode, failure.hashCode);
      });
    });
  });
}

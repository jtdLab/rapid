import 'package:rapid_cli/src/validation.dart';
import 'package:test/test.dart';

void main() {
  group('RapidConfigException', () {
    group('.invalidType', () {
      test('is initialized correctly when key != null && path == null', () {
        final exception = RapidConfigException.invalidType(
          expectedType: String,
          key: 'key',
          value: 'value',
        );

        expect(
          exception.message,
          'The property key is expected to be a String but got value',
        );
      });

      test('is initialized correctly when key != null && path != null', () {
        final exception = RapidConfigException.invalidType(
          expectedType: String,
          key: 'key',
          path: 'path',
          value: 'value',
        );

        expect(
          exception.message,
          'The property key at path is expected to be a String but got value',
        );
      });

      test('is initialized correctly when  index != null && path == null', () {
        final exception = RapidConfigException.invalidType(
          expectedType: String,
          index: 1,
          value: 'value',
        );

        expect(
          exception.message,
          'The index 1 is expected to be a String but got value',
        );
      });

      test('is initialized correctly when  index != null && path != null', () {
        final exception = RapidConfigException.invalidType(
          expectedType: String,
          index: 1,
          path: 'path',
          value: 'value',
        );

        expect(
          exception.message,
          'The index 1 at path is expected to be a String but got value',
        );
      });

      test('throws UnimplementedError when key == null && index == null', () {
        expect(
          () => RapidConfigException.invalidType(
            expectedType: String,
            value: 'value',
          ),
          throwsUnimplementedError,
        );
      });
    });
  });
}

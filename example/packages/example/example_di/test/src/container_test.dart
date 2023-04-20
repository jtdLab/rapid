import 'package:test/test.dart';
import 'package:example_di/example_di.dart';

void main() {
  test('getIt', () {
    expect(getIt, isNotNull);
  });
}

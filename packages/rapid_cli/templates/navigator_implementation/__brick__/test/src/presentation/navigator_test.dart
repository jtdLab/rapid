import 'package:{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}_{{name.snakeCase()}}/src/presentation/navigator.dart';
import 'package:flutter_test/flutter_test.dart';

{{name.pascalCase()}}Navigator _{{name.camelCase()}}Navigator() {
  return {{name.pascalCase()}}Navigator();
}

void main() {
  group('{{name.pascalCase()}}Navigator', () {
    test('.()', () {
      final {{name.camelCase()}}Navigator = _{{name.camelCase()}}Navigator();
      expect({{name.camelCase()}}Navigator, isNotNull);
    });
  });
}

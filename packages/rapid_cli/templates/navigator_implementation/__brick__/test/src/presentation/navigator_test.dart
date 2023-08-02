import 'package:{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}{{#mobile}}mobile{{/mobile}}_{{name.snakeCase()}}/src/presentation/navigator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('{{name.pascalCase()}}Navigator', () {
    test('.()', () {
      final {{name.camelCase()}}Navigator = {{name.pascalCase()}}Navigator();
      expect({{name.camelCase()}}Navigator, isNotNull);
    });

    // TODO: implement tests for navigation methods here
  });
}

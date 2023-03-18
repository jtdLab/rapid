{{#android}}import 'package:flutter/material.dart';{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';{{/ios}}{{#linux}}import 'package:flutter/material.dart';{{/linux}}{{#macos}}import 'package:flutter/cupertino.dart';{{/macos}}{{#web}}import 'package:flutter/material.dart';{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';{{/windows}}
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_ios/src/{{name.snakeCase()}}/{{name.snakeCase()}}.dart';
import 'package:{{project_name.snakeCase()}}_ui_ios/src/{{name.snakeCase()}}/{{name.snakeCase()}}_theme.dart';

import '../helpers/pump_app.dart';

{{project_name.pascalCase()}}{{name.pascalCase()}} _get{{project_name.pascalCase()}}{{name.pascalCase()}}({
  {{project_name.pascalCase()}}{{name.pascalCase()}}Theme? theme,
}) {
  return {{project_name.pascalCase()}}{{name.pascalCase()}}(
    theme: theme,
  );
}

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}', () {
    testWidgets('renders Container correctly', (tester) async {
      // Arrange
      const theme = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme(backgroundColor: Color(0xFF12FF12));
      final {{project_name.camelCase()}}{{name.pascalCase()}} = _get{{project_name.pascalCase()}}{{name.pascalCase()}}(
        theme: theme,
      );

      // Act
      await tester.pumpApp({{project_name.camelCase()}}{{name.pascalCase()}});

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, const Color(0xFF12FF12));
    });

    testWidgets('renders Container correctly when no theme is provided',
        (tester) async {
      // Arrange
      final {{project_name.camelCase()}}{{name.pascalCase()}} = _get{{project_name.pascalCase()}}{{name.pascalCase()}}();

      // Act
      await tester.pumpApp({{project_name.camelCase()}}{{name.pascalCase()}});

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.light.backgroundColor);
    });
  });
}

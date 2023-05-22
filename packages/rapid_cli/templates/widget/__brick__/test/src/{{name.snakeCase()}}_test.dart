{{^android}}{{^ios}}{{^linux}}{{^macos}}{{^web}}{{^windows}}{{^mobile}}import 'package:flutter/material.dart' show Theme, ThemeData;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui/src/{{name.snakeCase()}}.dart';
import 'package:{{project_name.snakeCase()}}_ui/src/{{name.snakeCase()}}_theme.dart';

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
      await tester.pumpWidget(
        Theme(
          data: ThemeData(extensions: {theme}),
          child: {{project_name.camelCase()}}{{name.pascalCase()}},
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, const Color(0xFF12FF12));
    });
  });
}{{/mobile}}{{/windows}}{{/web}}{{/macos}}{{/linux}}{{/ios}}{{/android}}{{#android}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_android/src/{{name.snakeCase()}}.dart';
import 'package:{{project_name.snakeCase()}}_ui_android/src/{{name.snakeCase()}}_theme.dart';

import 'helpers/pump_app.dart';

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
}{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_ios/src/{{name.snakeCase()}}.dart';
import 'package:{{project_name.snakeCase()}}_ui_ios/src/{{name.snakeCase()}}_theme.dart';

import 'helpers/pump_app.dart';

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
}{{/ios}}{{#linux}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_linux/src/{{name.snakeCase()}}.dart';
import 'package:{{project_name.snakeCase()}}_ui_linux/src/{{name.snakeCase()}}_theme.dart';

import 'helpers/pump_app.dart';

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
}{{/linux}}{{#macos}}import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_macos/src/{{name.snakeCase()}}.dart';
import 'package:{{project_name.snakeCase()}}_ui_macos/src/{{name.snakeCase()}}_theme.dart';

import 'helpers/pump_app.dart';

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
}{{/macos}}{{#web}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_web/src/{{name.snakeCase()}}.dart';
import 'package:{{project_name.snakeCase()}}_ui_web/src/{{name.snakeCase()}}_theme.dart';

import 'helpers/pump_app.dart';

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
}{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_windows/src/{{name.snakeCase()}}.dart';
import 'package:{{project_name.snakeCase()}}_ui_windows/src/{{name.snakeCase()}}_theme.dart';

import 'helpers/pump_app.dart';

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
}{{/windows}}{{#mobile}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_mobile/src/{{name.snakeCase()}}.dart';
import 'package:{{project_name.snakeCase()}}_ui_mobile/src/{{name.snakeCase()}}_theme.dart';

import 'helpers/pump_app.dart';

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
}{{/mobile}}

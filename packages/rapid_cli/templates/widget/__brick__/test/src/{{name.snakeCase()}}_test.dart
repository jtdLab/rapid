{{^android}}{{^ios}}{{^linux}}{{^macos}}{{^web}}{{^windows}}{{^mobile}}import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui/src/{{name.snakeCase()}}.dart';

import 'helpers/helpers.dart';

{{project_name.pascalCase()}}{{name.pascalCase()}} _get{{project_name.pascalCase()}}{{name.pascalCase()}}() {
  return const {{project_name.pascalCase()}}{{name.pascalCase()}}();
}

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}', () {
    goldenTest(
      'renders correctly',
      fileName: '{{name.snakeCase()}}',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}{{/mobile}}{{/windows}}{{/web}}{{/macos}}{{/linux}}{{/ios}}{{/android}}{{#android}}import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_android/src/{{name.snakeCase()}}.dart';

import 'helpers/helpers.dart';

{{project_name.pascalCase()}}{{name.pascalCase()}} _get{{project_name.pascalCase()}}{{name.pascalCase()}}() {
  return const {{project_name.pascalCase()}}{{name.pascalCase()}}();
}

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}', () {
    goldenTest(
      'renders correctly',
      fileName: '{{name.snakeCase()}}',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}{{/android}}{{#ios}}import 'package:alchemist/alchemist.dart';import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_ios/src/{{name.snakeCase()}}.dart';

import 'helpers/helpers.dart';

{{project_name.pascalCase()}}{{name.pascalCase()}} _get{{project_name.pascalCase()}}{{name.pascalCase()}}() {
  return const {{project_name.pascalCase()}}{{name.pascalCase()}}();
}

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}', () {
    goldenTest(
      'renders correctly',
      fileName: '{{name.snakeCase()}}',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: appWrapper(
              brightness: Brightness.dark,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: appWrapper(
              brightness: Brightness.dark,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}{{/ios}}{{#linux}}import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_linux/src/{{name.snakeCase()}}.dart';

import 'helpers/helpers.dart';

{{project_name.pascalCase()}}{{name.pascalCase()}} _get{{project_name.pascalCase()}}{{name.pascalCase()}}() {
  return const {{project_name.pascalCase()}}{{name.pascalCase()}}();
}

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}', () {
    goldenTest(
      'renders correctly',
      fileName: '{{name.snakeCase()}}',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}{{/linux}}{{#macos}}import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_macos/src/{{name.snakeCase()}}.dart';

import 'helpers/helpers.dart';

{{project_name.pascalCase()}}{{name.pascalCase()}} _get{{project_name.pascalCase()}}{{name.pascalCase()}}() {
  return const {{project_name.pascalCase()}}{{name.pascalCase()}}();
}

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}', () {
    goldenTest(
      'renders correctly',
      fileName: '{{name.snakeCase()}}',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}{{/macos}}{{#web}}import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_web/src/{{name.snakeCase()}}.dart';

import 'helpers/helpers.dart';

{{project_name.pascalCase()}}{{name.pascalCase()}} _get{{project_name.pascalCase()}}{{name.pascalCase()}}() {
  return const {{project_name.pascalCase()}}{{name.pascalCase()}}();
}

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}', () {
    goldenTest(
      'renders correctly',
      fileName: '{{name.snakeCase()}}',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}{{/web}}{{#windows}}import 'package:alchemist/alchemist.dart';import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_windows/src/{{name.snakeCase()}}.dart';

import 'helpers/helpers.dart';

{{project_name.pascalCase()}}{{name.pascalCase()}} _get{{project_name.pascalCase()}}{{name.pascalCase()}}() {
  return const {{project_name.pascalCase()}}{{name.pascalCase()}}();
}

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}', () {
    goldenTest(
      'renders correctly',
      fileName: '{{name.snakeCase()}}',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}{{/windows}}{{#mobile}}import 'package:alchemist/alchemist.dart';import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_mobile/src/{{name.snakeCase()}}.dart';

import 'helpers/helpers.dart';

{{project_name.pascalCase()}}{{name.pascalCase()}} _get{{project_name.pascalCase()}}{{name.pascalCase()}}() {
  return const {{project_name.pascalCase()}}{{name.pascalCase()}}();
}

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}', () {
    goldenTest(
      'renders correctly',
      fileName: '{{name.snakeCase()}}',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          GoldenTestScenario(
            name: 'dark',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}{{name.pascalCase()}}(),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}{{/mobile}}

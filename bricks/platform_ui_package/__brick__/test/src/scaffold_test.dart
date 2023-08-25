import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
{{#android}}import 'package:flutter/material.dart';{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';{{/ios}}{{#linux}}import 'package:flutter/material.dart';{{/linux}}{{#macos}}import 'package:flutter/material.dart' show ThemeMode;import 'package:flutter/widgets.dart';{{/macos}}{{#web}}import 'package:flutter/material.dart';{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';{{/windows}}{{#mobile}}import 'package:flutter/material.dart';{{/mobile}}
{{#android}}import 'package:{{project_name}}_ui_android/src/scaffold.dart';import 'package:{{project_name}}_ui_android/src/scaffold_theme.dart';{{/android}}{{#ios}}import 'package:{{project_name}}_ui_ios/src/scaffold.dart';import 'package:{{project_name}}_ui_ios/src/scaffold_theme.dart';{{/ios}}{{#linux}}import 'package:{{project_name}}_ui_linux/src/scaffold.dart';import 'package:{{project_name}}_ui_linux/src/scaffold_theme.dart';{{/linux}}{{#macos}}import 'package:{{project_name}}_ui_macos/src/scaffold.dart';import 'package:{{project_name}}_ui_macos/src/scaffold_theme.dart';{{/macos}}{{#web}}import 'package:{{project_name}}_ui_web/src/scaffold.dart';import 'package:{{project_name}}_ui_web/src/scaffold_theme.dart';{{/web}}{{#windows}}import 'package:{{project_name}}_ui_windows/src/scaffold.dart';import 'package:{{project_name}}_ui_windows/src/scaffold_theme.dart';{{/windows}}{{#mobile}}import 'package:{{project_name}}_ui_mobile/src/scaffold.dart';import 'package:{{project_name}}_ui_mobile/src/scaffold_theme.dart';{{/mobile}}
{{#macos}}import 'package:macos_ui/macos_ui.dart';{{/macos}}

import 'helpers/helpers.dart';

{{^macos}}{{project_name.pascalCase()}}Scaffold _get{{project_name.pascalCase()}}Scaffold({
  required Widget body,
  {{project_name.pascalCase()}}ScaffoldTheme? theme,
}) {
  return {{project_name.pascalCase()}}Scaffold(
    theme: theme,
    body: body,
  );
}{{/macos}}{{#macos}}{{project_name.pascalCase()}}Scaffold _get{{project_name.pascalCase()}}Scaffold({
  required List<Widget> children,
  {{project_name.pascalCase()}}ScaffoldTheme? theme,
}) {
  return {{project_name.pascalCase()}}Scaffold(
    theme: theme,
    children: children,
  );
}
{{/macos}}

{{#android}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    goldenTest(
      'renders correctly',
      fileName: 'scaffold',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light - with theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(
                      backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'light - without theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - with theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - without theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}
{{/android}}{{#ios}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    goldenTest(
      'renders correctly',
      fileName: 'scaffold',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light - with theme',
            child: appWrapper(
              brightness: Brightness.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'light - without theme',
            child: appWrapper(
              brightness: Brightness.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - with theme',
            child: appWrapper(
              brightness: Brightness.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - without theme',
            child: appWrapper(
              brightness: Brightness.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}
{{/ios}}{{#linux}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    goldenTest(
      'renders correctly',
      fileName: 'scaffold',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.expand(
          width: 1000,
          height: 500,
        ),
        children: [
          GoldenTestScenario(
            name: 'light - with theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'light - without theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - with theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - without theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}
{{/linux}}{{#macos}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    goldenTest(
      'renders correctly',
      fileName: 'scaffold',
      whilePerforming: (tester) async {
        await tester.pumpAndSettle();
        return;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.expand(
          width: 1000,
          height: 500,
        ),
        children: [
          GoldenTestScenario(
            name: 'light - with theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}                children: [
                  ContentArea(
                    builder: (context, _) => const Placeholder(),
                  ),
                ],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'light - without theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}                children: [
                  ContentArea(
                    builder: (context, _) => const Placeholder(),
                  ),
                ],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - with theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}                children: [
                  ContentArea(
                    builder: (context, _) => const Placeholder(),
                  ),
                ],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - without theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}                children: [
                  ContentArea(
                    builder: (context, _) => const Placeholder(),
                  ),
                ],{{/macos}}
              ),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}
{{/macos}}{{#web}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    goldenTest(
      'renders correctly',
      fileName: 'scaffold',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.expand(
          width: 1000,
          height: 500,
        ),
        children: [
          GoldenTestScenario(
            name: 'light - with theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'light - without theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - with theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - without theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}
{{/web}}{{#windows}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    goldenTest(
      'renders correctly',
      fileName: 'scaffold',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.expand(
          width: 1000,
          height: 500,
        ),
        children: [
          GoldenTestScenario(
            name: 'light - with theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'light - without theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - with theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - without theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}
{{/windows}}{{#mobile}}void main() {
  group('{{project_name.pascalCase()}}Scaffold', () {
    goldenTest(
      'renders correctly',
      fileName: 'scaffold',
      builder: () => GoldenTestGroup(
        scenarioConstraints:
            const BoxConstraints(minWidth: 250, maxHeight: 500),
        children: [
          GoldenTestScenario(
            name: 'light - with theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'light - without theme',
            child: appWrapper(
              themeMode: ThemeMode.light,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - with theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                theme:
                    const {{project_name.pascalCase()}}ScaffoldTheme(backgroundColor: Color(0xFF12FF12),),
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'dark - without theme',
            child: appWrapper(
              themeMode: ThemeMode.dark,
              widget: _get{{project_name.pascalCase()}}Scaffold(
                {{^macos}}body: const Placeholder(),{{/macos}}{{#macos}}children: [const Placeholder()],{{/macos}}
              ),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );
  });
}
{{/mobile}}
import 'package:flutter_test/flutter_test.dart';{{#android}}import 'package:{{project_name}}_android_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';{{/android}}{{#ios}}import 'package:{{project_name}}_ios_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';{{/ios}}{{#linux}}import 'package:{{project_name}}_linux_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';{{/linux}}{{#macos}}import 'package:{{project_name}}_macos_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';{{/macos}}{{#web}}import 'package:{{project_name}}_web_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';{{/web}}{{#windows}}import 'package:{{project_name}}_windows_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';{{/windows}}

import 'helpers/helpers.dart';

void main() {
  group('{{name.pascalCase()}}', () {
    testWidgets('renders correctly ({{default_language}})', (tester) async {
      // Act
      await tester.pumpApp(
        initialRoutes: [
          const {{route_name}}Route(),
        ],
        locale: const Locale('{{default_language}}'),
      );

      // Assert
      expect(find.byType({{project_name.pascalCase()}}Scaffold), findsOneWidget);
      expect(find.text('{{name.titleCase()}} title for {{default_language}}'), findsOneWidget);
    });
  });
}

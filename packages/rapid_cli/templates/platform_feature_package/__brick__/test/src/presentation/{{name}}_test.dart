import 'package:alchemist/alchemist.dart';import 'package:flutter_test/flutter_test.dart';{{#android}}import 'package:{{project_name}}_android_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';{{/android}}{{#ios}}import 'package:{{project_name}}_ios_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';{{/ios}}{{#linux}}import 'package:{{project_name}}_linux_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';{{/linux}}{{#macos}}import 'package:{{project_name}}_macos_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';{{/macos}}{{#web}}import 'package:{{project_name}}_web_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';{{/web}}{{#windows}}import 'package:{{project_name}}_windows_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';{{/windows}}{{#mobile}}import 'package:{{project_name}}_mobile_{{name.snakeCase()}}/src/presentation/presentation.dart';import 'package:{{project_name}}_ui_mobile/{{project_name}}_ui_mobile.dart';{{/mobile}}

import 'helpers/helpers.dart';

void main() {
  group('{{name.pascalCase()}}', () {
    setUpAll(() {
      // TODO: register all bloc/cubits that are injected
      // inside the build() method of the widget under test here.
      // E.g
      // final myCubit = MockMyCubit();
      // whenListen(myCubit, const Stream<MyState>.empty(), initialState: MyInitial());
      // getIt.registerFactory<MyCubit>(() => myCubit);
    });

    goldenTest(
      'renders correctly',
      fileName: '{{name.snakeCase()}}',
{{#macos}}      whilePerforming: (tester) async {
        await tester.pumpAndSettle();
        return;
      },{{/macos}}
      builder: () => GoldenTestGroup(
{{#linux}}        scenarioConstraints: const BoxConstraints.expand(
          width: 1000,
          height: 500,
        ),{{/linux}}
{{#macos}}        scenarioConstraints: const BoxConstraints.expand(
          width: 1000,
          height: 500,
        ),{{/macos}}
{{#web}}        scenarioConstraints: const BoxConstraints.expand(
          width: 1000,
          height: 500,
        ),{{/web}}
{{#windows}}        scenarioConstraints: const BoxConstraints.expand(
          width: 1000,
          height: 500,
        ),{{/windows}}
{{^linux}}{{^macos}}{{^web}}{{^windows}}        scenarioConstraints: const BoxConstraints(minWidth: 250, maxHeight: {{#isWidget}}250{{/isWidget}}{{^isWidget}}500{{/isWidget}}),{{/windows}}{{/web}}{{/macos}}{{/linux}}  
        children: [
          GoldenTestScenario(
            name: '{{#localization}}{{default_language}} - {{/localization}}light',
            child: appWrapper(
              {{#localization}}locale: const Locale('{{default_language}}'),{{/localization}}
              {{#android}}themeMode: ThemeMode.light{{/android}}{{#ios}}brightness: Brightness.light{{/ios}}{{#linux}}themeMode: ThemeMode.light{{/linux}}{{#macos}}themeMode: ThemeMode.light{{/macos}}{{#web}}themeMode: ThemeMode.light{{/web}}{{#windows}}themeMode: ThemeMode.light{{/windows}}{{#mobile}}themeMode: ThemeMode.light{{/mobile}},
              widget: const {{name.pascalCase()}}(),
            ),
          ),
          GoldenTestScenario(
            name: '{{#localization}}{{default_language}} - {{/localization}}dark',
            child: appWrapper(
              {{#localization}}locale: const Locale('{{default_language}}'),{{/localization}}
              {{#android}}themeMode: ThemeMode.dark{{/android}}{{#ios}}brightness: Brightness.dark{{/ios}}{{#linux}}themeMode: ThemeMode.dark{{/linux}}{{#macos}}themeMode: ThemeMode.dark{{/macos}}{{#web}}themeMode: ThemeMode.dark{{/web}}{{#windows}}themeMode: ThemeMode.dark{{/windows}}{{#mobile}}themeMode: ThemeMode.dark{{/mobile}},
              widget: const {{name.pascalCase()}}(),
            ),
          ),
          // TODO: add more scenarios
        ],
      ),
    );

    // TODO: verify actions and events are handled correctly via standard widget tests.
  });
}

import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_{{platform}}_{{name.snakeCase()}}/src/presentation/presentation.dart';
import 'package:{{project_name}}_ui_{{platform}}/{{project_name}}_ui_{{platform}}.dart';

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
            name: '{{default_language}} - light',
            child: appWrapper(
              locale: const Locale('{{default_language}}'),
              {{#android}}themeMode: ThemeMode.light{{/android}}{{#ios}}brightness: Brightness.light{{/ios}}{{#linux}}themeMode: ThemeMode.light{{/linux}}{{#macos}}themeMode: ThemeMode.light{{/macos}}{{#web}}themeMode: ThemeMode.light{{/web}}{{#windows}}themeMode: ThemeMode.light{{/windows}}{{#mobile}}themeMode: ThemeMode.light{{/mobile}},
              widget: const {{name.pascalCase()}}(),
            ),
          ),
          GoldenTestScenario(
            name: '{{default_language}} - dark',
            child: appWrapper(
              locale: const Locale('{{default_language}}'),
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

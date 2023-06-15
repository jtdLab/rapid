import 'package:flutter_localizations/flutter_localizations.dart';import 'package:flutter_test/flutter_test.dart';import 'package:{{project_name}}_ui/{{project_name}}_ui.dart' as ui;{{#android}}import 'package:{{project_name}}_ui_android/src/app.dart';import 'package:{{project_name}}_ui_android/src/theme_extensions.dart';import 'package:flutter/material.dart';{{/android}}{{#ios}}import 'package:{{project_name}}_ui_ios/src/app.dart';import 'package:{{project_name}}_ui_ios/src/theme_extensions.dart';import 'package:flutter/cupertino.dart';import 'package:flutter/material.dart' show Theme;{{/ios}}{{#linux}}import 'package:{{project_name}}_ui_linux/src/app.dart';import 'package:{{project_name}}_ui_linux/src/theme_extensions.dart';import 'package:flutter/material.dart';{{/linux}}{{#macos}}import 'package:{{project_name}}_ui_macos/src/app.dart';import 'package:{{project_name}}_ui_macos/src/theme_extensions.dart';import 'package:flutter/widgets.dart';import 'package:flutter/material.dart' show Theme, ThemeMode;import 'package:macos_ui/macos_ui.dart';{{/macos}}{{#web}}import 'package:{{project_name}}_ui_web/src/app.dart';import 'package:{{project_name}}_ui_web/src/theme_extensions.dart';import 'package:flutter/material.dart';{{/web}}{{#windows}}import 'package:{{project_name}}_ui_windows/src/app.dart';import 'package:{{project_name}}_ui_windows/src/theme_extensions.dart';import 'package:fluent_ui/fluent_ui.dart';{{/windows}}{{#mobile}}import 'package:{{project_name}}_ui_mobile/src/app.dart';import 'package:{{project_name}}_ui_mobile/src/theme_extensions.dart';import 'package:flutter/material.dart';{{/mobile}}

import 'mocks.dart';

{{#android}}
{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}App({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    themeMode: themeMode,
  );
}

{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}AppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  ThemeMode? themeMode,
  required Widget home,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
    home: home,
  );
}

void main() {
  group('{{project_name.pascalCase()}}App', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.supportedLocales, supportedLocales);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(materialApp.locale, null);
      expect(
        materialApp.theme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...lightExtensions, ...ui.lightExtensions},
        ),
      );
      expect(
        materialApp.darkTheme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...darkExtensions, ...ui.darkExtensions},
        ),
      );
      expect(materialApp.routerConfig, routerConfig);
      expect(materialApp.home, null);
    });
  });

  group('{{project_name.pascalCase()}}App.test', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}AppTest(
        locale: const Locale('fr'),
        localizationsDelegates: localizationsDelegates,
        themeMode: ThemeMode.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, const Locale('fr'));
      expect(materialApp.supportedLocales, [const Locale('fr')]);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(
        materialApp.theme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...lightExtensions, ...ui.lightExtensions},
        ),
      );
      expect(
        materialApp.darkTheme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...darkExtensions, ...ui.darkExtensions},
        ),
      );
      expect(materialApp.themeMode, ThemeMode.dark);
      expect(materialApp.home, home);
    });
  });
}
{{/android}}{{#ios}}
{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}App({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  Brightness? brightness,
}) {
  return {{project_name.pascalCase()}}App(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    brightness: brightness,
  );
}

{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}AppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Brightness? brightness,
  required Widget home,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    brightness: brightness,
    home: home,
  );
}

void main() {
  group('{{project_name.pascalCase()}}App', () {
    testWidgets('renders CupertinoApp correctly when brightness is light', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}App(
        locale: const Locale('en'),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
        brightness: Brightness.light,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);
      await tester.pump();

      // Assert
      final cupertinoApp = tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.supportedLocales, supportedLocales);
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.locale, const Locale('en'));
      expect(cupertinoApp.routerConfig, routerConfig);
      expect(cupertinoApp.home, null);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(
        theme.data.extensions.values.toSet(),
        {...lightExtensions, ...ui.lightExtensions},
      );
    });
  
    testWidgets('renders CupertinoApp correctly when brightness is dark', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}App(
        locale: const Locale('en'),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
        brightness: Brightness.dark,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);
      await tester.pump();

      // Assert
      final cupertinoApp = tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.supportedLocales, supportedLocales);
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.locale, const Locale('en'));
      expect(cupertinoApp.routerConfig, routerConfig);
      expect(cupertinoApp.home, null);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(
        theme.data.extensions.values.toSet(),
        {...darkExtensions, ...ui.darkExtensions},
      );
    });
  });

  group('{{project_name.pascalCase()}}App.test', () {
    testWidgets('renders CupertinoApp correctly when brightness is light',
        (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}AppTest(
        locale: const Locale('en'),
        localizationsDelegates: localizationsDelegates,
        brightness: Brightness.light,
        home: home,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);
      await tester.pumpAndSettle();

      // Assert
      final cupertinoApp =
          tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.locale, const Locale('en'));
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.supportedLocales, equals([const Locale('en')]));
      expect(cupertinoApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(
        theme.data.extensions.values.toSet(), 
        {...lightExtensions, ...ui.lightExtensions},
      );
    });

    testWidgets('renders CupertinoApp correctly when brightness is dark',
        (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}AppTest(
        locale: const Locale('en'),
        localizationsDelegates: localizationsDelegates,
        brightness: Brightness.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);
      await tester.pumpAndSettle();

      // Assert
      final cupertinoApp =
          tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.locale, const Locale('en'));
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.supportedLocales, equals([const Locale('en')]));
      expect(cupertinoApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(
        theme.data.extensions.values.toSet(),
        {...darkExtensions, ...ui.darkExtensions},
      );
    });
  });
}
{{/ios}}{{#linux}}
{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}App({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    themeMode: themeMode,
  );
}

{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}AppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  ThemeMode? themeMode,
  required Widget home,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
    home: home,
  );
}

void main() {
  group('{{project_name.pascalCase()}}App', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.supportedLocales, supportedLocales);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(materialApp.locale, null);
      expect(
        materialApp.theme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...lightExtensions, ...ui.lightExtensions},
        ),
      );
      expect(
        materialApp.darkTheme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...darkExtensions, ...ui.darkExtensions},
        ),
      );
      expect(materialApp.routerConfig, routerConfig);
      expect(materialApp.home, null);
    });
  });

  group('{{project_name.pascalCase()}}App.test', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}AppTest(
        locale: const Locale('fr'),
        localizationsDelegates: localizationsDelegates,
        themeMode: ThemeMode.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, const Locale('fr'));
      expect(materialApp.supportedLocales, [const Locale('fr')]);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(
        materialApp.theme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...lightExtensions, ...ui.lightExtensions},
        ),
      );
      expect(
        materialApp.darkTheme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...darkExtensions, ...ui.darkExtensions},
        ),
      );
      expect(materialApp.themeMode, ThemeMode.dark);
      expect(materialApp.home, home);
    });
  });
}
{{/linux}}{{#macos}}
{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}App({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    themeMode: themeMode,
  );
}

{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}AppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  ThemeMode? themeMode,
  required Widget home,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
    home: home,
  );
}

void main() {
  group('{{project_name.pascalCase()}}App', () {
    testWidgets('renders MacosApp correctly when themeMode is light', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}App(
        locale: const Locale('en'),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
        themeMode: ThemeMode.light,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);
      await tester.pump();

      // Assert
      final macosApp = tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.supportedLocales, supportedLocales);
      expect(
        macosApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(macosApp.locale, const Locale('en'));
      expect(macosApp.routerConfig, routerConfig);
      expect(macosApp.home, null);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(
        theme.data.extensions.values.toSet(),
        {...lightExtensions, ...ui.lightExtensions},
      );
    });
  
    testWidgets('renders MacosApp correctly when themeMode is dark', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}App(
        locale: const Locale('en'),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
        themeMode: ThemeMode.dark,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);
      await tester.pump();

      // Assert
      final macosApp = tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.supportedLocales, supportedLocales);
      expect(
        macosApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(macosApp.locale, const Locale('en'));
      expect(macosApp.routerConfig, routerConfig);
      expect(macosApp.home, null);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(
        theme.data.extensions.values.toSet(),
        {...darkExtensions, ...ui.darkExtensions},
      );
    });
  });

  group('{{project_name.pascalCase()}}App.test', () {
    testWidgets('renders MacosApp correctly when themeMode is light',
        (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}AppTest(
        locale: const Locale('en'),
        localizationsDelegates: localizationsDelegates,
        themeMode: ThemeMode.light,
        home: home,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);
      await tester.pumpAndSettle();

      // Assert
      final macosApp =
          tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.locale, const Locale('en'));
      expect(
        macosApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(macosApp.supportedLocales, equals([const Locale('en')]));
      expect(macosApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(
        theme.data.extensions.values.toSet(),
        {...lightExtensions, ...ui.lightExtensions},
      );
    });

    testWidgets('renders MacosApp correctly when themeMode is dark',
        (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}AppTest(
        locale: const Locale('en'),
        localizationsDelegates: localizationsDelegates,
        themeMode: ThemeMode.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);
      await tester.pumpAndSettle();

      // Assert
      final macosApp =
          tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.locale, const Locale('en'));
      expect(
        macosApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(macosApp.supportedLocales, equals([const Locale('en')]));
      expect(macosApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(
        theme.data.extensions.values.toSet(),
        {...darkExtensions, ...ui.darkExtensions},
      );
    });
  });
}
{{/macos}}{{#web}}
{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}App({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    themeMode: themeMode,
  );
}

{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}AppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  ThemeMode? themeMode,
  required Widget home,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
    home: home,
  );
}

void main() {
  group('{{project_name.pascalCase()}}App', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.supportedLocales, supportedLocales);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(materialApp.locale, null);
      expect(
        materialApp.theme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...lightExtensions, ...ui.lightExtensions},
        ),
      );
      expect(
        materialApp.darkTheme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...darkExtensions, ...ui.darkExtensions},
        ),
      );
      expect(materialApp.routerConfig, routerConfig);
      expect(materialApp.home, null);
    });
  });

  group('{{project_name.pascalCase()}}App.test', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}AppTest(
        locale: const Locale('fr'),
        localizationsDelegates: localizationsDelegates,
        themeMode: ThemeMode.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, const Locale('fr'));
      expect(materialApp.supportedLocales, [const Locale('fr')]);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(
        materialApp.theme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...lightExtensions, ...ui.lightExtensions},
        ),
      );
      expect(
        materialApp.darkTheme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...darkExtensions, ...ui.darkExtensions},
        ),
      );
      expect(materialApp.themeMode, ThemeMode.dark);
      expect(materialApp.home, home);
    });
  });
}
{{/web}}{{#windows}}
{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}App({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    themeMode: themeMode,
  );
}

{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}AppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  ThemeMode? themeMode,
  required Widget home,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
    home: home,
  );
}

void main() {
  group('{{project_name.pascalCase()}}App', () {
    testWidgets('renders FluentApp correctly', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);

      // Assert
      final fluentApp = tester.widget<FluentApp>(find.byType(FluentApp));
      expect(fluentApp.supportedLocales, supportedLocales);
      expect(
        fluentApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(fluentApp.locale, null);
      expect(
        fluentApp.theme,
        isA<FluentThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...lightExtensions, ...ui.lightExtensions},
        ),
      );
      expect(
        fluentApp.darkTheme,
        isA<FluentThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...darkExtensions, ...ui.darkExtensions},
        ),
      );
      expect(fluentApp.routerConfig, routerConfig);
      expect(fluentApp.home, null);
    });
  });

  group('{{project_name.pascalCase()}}App.test', () {
    testWidgets('renders FluentApp correctly', (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}AppTest(
        locale: const Locale('fr'),
        localizationsDelegates: localizationsDelegates,
        themeMode: ThemeMode.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);

      // Assert
      final fluentApp = tester.widget<FluentApp>(find.byType(FluentApp));
      expect(fluentApp.locale, const Locale('fr'));
      expect(fluentApp.supportedLocales, [const Locale('fr')]);
      expect(
        fluentApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(
        fluentApp.theme,
        isA<FluentThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...lightExtensions, ...ui.lightExtensions},
        ),
      );
      expect(
        fluentApp.darkTheme,
        isA<FluentThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...darkExtensions, ...ui.darkExtensions},
        ),
      );
      expect(fluentApp.themeMode, ThemeMode.dark);
      expect(fluentApp.home, home);
    });
  });
}
{{/windows}}{{#mobile}}
{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}App({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  ThemeMode? themeMode,
}) {
  return {{project_name.pascalCase()}}App(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    themeMode: themeMode,
  );
}

{{project_name.pascalCase()}}App _get{{project_name.pascalCase()}}AppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  ThemeMode? themeMode,
  required Widget home,
}) {
  return {{project_name.pascalCase()}}App.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
    home: home,
  );
}

void main() {
  group('{{project_name.pascalCase()}}App', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}App(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.supportedLocales, supportedLocales);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(materialApp.locale, null);
      expect(
        materialApp.theme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...lightExtensions, ...ui.lightExtensions},
        ),
      );
      expect(
        materialApp.darkTheme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...darkExtensions, ...ui.darkExtensions},
        ),
      );
      expect(materialApp.routerConfig, routerConfig);
      expect(materialApp.home, null);
    });
  });

  group('{{project_name.pascalCase()}}App.test', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final {{project_name.camelCase()}}App = _get{{project_name.pascalCase()}}AppTest(
        locale: const Locale('fr'),
        localizationsDelegates: localizationsDelegates,
        themeMode: ThemeMode.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget({{project_name.camelCase()}}App);

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, const Locale('fr'));
      expect(materialApp.supportedLocales, [const Locale('fr')]);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(
        materialApp.theme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...lightExtensions, ...ui.lightExtensions},
        ),
      );
      expect(
        materialApp.darkTheme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          {...darkExtensions, ...ui.darkExtensions},
        ),
      );
      expect(materialApp.themeMode, ThemeMode.dark);
      expect(materialApp.home, home);
    });
  });
}
{{/mobile}}
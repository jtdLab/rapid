import 'package:flutter_test/flutter_test.dart';{{#android}}import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';import 'package:{{project_name}}_android_routing/{{project_name}}_android_routing.dart';{{/android}}{{#ios}}import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';import 'package:{{project_name}}_ios_routing/{{project_name}}_ios_routing.dart';{{/ios}}{{#linux}}import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';import 'package:{{project_name}}_linux_routing/{{project_name}}_linux_routing.dart';{{/linux}}{{#macos}}import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';import 'package:{{project_name}}_macos_routing/{{project_name}}_macos_routing.dart';{{/macos}}{{#web}}import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';import 'package:{{project_name}}_web_routing/{{project_name}}_web_routing.dart';{{/web}}{{#windows}}import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';import 'package:{{project_name}}_windows_routing/{{project_name}}_windows_routing.dart';{{/windows}}import 'package:meta/meta.dart';

import 'pump_app.dart';

/// Tests wheter [widget] as a child of [route] contains [amount] text widgets
/// with correct [translations].
/// This launches a test group containing a seperate test for each
/// entry of [translations].
///
/// Specify `findRichText` to also include [RichText] widgets.
///
/// Specify `skipOffstage` exclude offstage widgets.
@isTestGroup
void localizationTest(
  String description, {
  required PageRouteInfo route,
  required Widget widget,
  required Map<Locale, String> translations,
  int amount = 1,
  bool findRichText = false,
  bool skipOffstage = true,
}) =>
    group(description, () {
      for (final e in translations.entries) {
        testWidgets(
          '(${e.key})',
          (tester) async {
            // Act
            await tester.pumpApp(
              route,
              widget,
              locale: e.key,
            );

            // Assert
            expect(
              find.text(
                e.value,
                findRichText: findRichText,
                skipOffstage: skipOffstage,
              ),
              findsNWidgets(amount),
            );
          },
        );
      }
    });

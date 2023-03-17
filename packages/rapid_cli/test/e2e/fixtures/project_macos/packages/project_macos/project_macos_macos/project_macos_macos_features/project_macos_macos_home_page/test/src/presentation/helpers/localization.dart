import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';
import 'package:project_macos_macos_routing/project_macos_macos_routing.dart';
import 'package:meta/meta.dart';

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

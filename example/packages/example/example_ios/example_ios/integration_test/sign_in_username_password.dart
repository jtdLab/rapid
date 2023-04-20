import 'package:example_ios_home_page/example_ios_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> performTest(WidgetTester tester) async {
  await tester.pumpAndSettle();

  final usernameTextField = find.widgetWithText(CupertinoTextField, 'Username');
  final passwordTextField = find.widgetWithText(CupertinoTextField, 'Password');
  final loginButton = find.widgetWithText(CupertinoButton, 'Login');

  await tester.enterText(usernameTextField, 'fooBar12');
  await tester.enterText(passwordTextField, 'foo123bar');
  await tester.tap(loginButton);
  await tester.pumpAndSettle();

  expect(find.byType(HomePage), findsOneWidget);
}

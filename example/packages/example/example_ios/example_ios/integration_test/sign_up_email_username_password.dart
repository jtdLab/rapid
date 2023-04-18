import 'package:example_ios_home_page/example_ios_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> performTest(WidgetTester tester) async {
  await tester.pumpAndSettle();
  final screenCenter = tester.getCenter(find.byType(CupertinoPageScaffold));
  await tester.flingFrom(screenCenter, const Offset(-500, 0), 800);

  final emailTextField =
      find.widgetWithText(CupertinoTextField, 'Email address');
  final usernameTextField = find.widgetWithText(CupertinoTextField, 'Username');
  final passwordTextField = find.widgetWithText(CupertinoTextField, 'Password');
  final passwordAgainTextField =
      find.widgetWithText(CupertinoTextField, 'Password again');
  final signUpButton = find.widgetWithText(CupertinoButton, 'Sign up');

  await tester.enterText(emailTextField, 'foo.bar@baz.com');
  await tester.enterText(usernameTextField, 'foobar1');
  await tester.enterText(passwordTextField, 'foo123bar');
  await tester.enterText(passwordAgainTextField, 'foo123bar');
  await tester.tap(signUpButton);
  await tester.pumpAndSettle();

  expect(find.byType(HomePage), findsOneWidget);
}

import 'package:example_di/example_di.dart';
import 'package:example_ios/main_test.dart' as test;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'sign_in_username_password.dart' as sign_in_username_and_password;
import 'sign_up_email_username_password.dart'
    as sign_up_email_username_and_password;
import 'start_app.dart' as start_app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
  });

  group('E2E (test)', () {
    testWidgets('start app', (tester) async {
      test.main();

      await start_app.performTest(tester);
    });

    testWidgets('start app', (tester) async {
      test.main();

      await start_app.performTest(tester);
    });

    testWidgets('sign in with email and password', (tester) async {
      test.main();

      await sign_in_username_and_password.performTest(tester);
    });

    testWidgets('sign up with email, username and password', (tester) async {
      test.main();
      await tester.pumpAndSettle();

      await sign_up_email_username_and_password.performTest(tester);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:example_ios/main_test.dart' as test;
import 'package:example_di/example_di.dart';

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
  });
}
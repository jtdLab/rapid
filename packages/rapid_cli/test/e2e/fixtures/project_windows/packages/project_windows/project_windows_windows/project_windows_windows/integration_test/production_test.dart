import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_windows_windows/main_production.dart' as production;
import 'package:project_windows_di/project_windows_di.dart';

import 'start_app.dart' as start_app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
  });

  group('E2E (production)', () {
    testWidgets('start app', (tester) async {
      production.main();

      await start_app.performTest(tester);
    });
  });
}

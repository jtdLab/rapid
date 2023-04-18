import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_macos_macos/main_development.dart' as dev;
import 'package:project_macos_di/project_macos_di.dart';

import 'start_app.dart' as start_app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
  });

  group('E2E (development)', () {
    testWidgets('start app', (tester) async {
      dev.main();

      await start_app.performTest(tester);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_android_android/main_development.dart' as dev;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E (development)', () {
    testWidgets('runs successfully', (tester) async {
      dev.main();
      await tester.pumpAndSettle();
    });
  });
}

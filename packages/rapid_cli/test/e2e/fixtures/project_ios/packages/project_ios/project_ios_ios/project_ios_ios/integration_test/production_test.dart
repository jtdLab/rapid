import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_ios_ios/main_production.dart' as production;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E (production)', () {
    testWidgets('runs successfully', (tester) async {
      production.main();
      await tester.pumpAndSettle();
    });
  });
}

import 'package:project_linux/main_production.dart' as production;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E (production)', () {
    testWidgets('runs successfully', (tester) async {
      production.main();
      await tester.pumpAndSettle();
    });
  });
}

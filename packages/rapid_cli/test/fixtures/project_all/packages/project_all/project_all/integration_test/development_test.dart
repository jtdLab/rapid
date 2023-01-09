import 'package:project_all/main_development.dart' as dev;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E (development)', () {
    testWidgets('runs successfully', (tester) async {
      dev.main();
      await tester.pumpAndSettle();
    });
  });
}

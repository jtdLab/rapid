import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_macos_macos/main_test.dart' as test;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E (test)', () {
    testWidgets('runs successfully', (tester) async {
      test.main();
      await tester.pumpAndSettle();
    });
  });
}

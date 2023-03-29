import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}/main_development.dart'
    as dev;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E (development)', () {
    testWidgets('runs successfully', (tester) async {
      dev.main();
      await tester.pumpAndSettle();
    });
  });
}

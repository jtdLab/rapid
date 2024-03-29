import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}{{#mobile}}mobile{{/mobile}}/main_production.dart'
    as production;
import 'package:{{project_name}}_di/{{project_name}}_di.dart';

import 'start_app.dart' as start_app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

{{#web}}  setUpAll(() {
    production.setUrlStrategy = null;
  });
{{/web}}
  setUp(() async {
    await getIt.reset();
  });

  group('E2E (production)', () {
    testWidgets('start app', (tester) async {
      await production.main();

      await start_app.performTest(tester);
    });

    // TODO: add integration tests here (production)
  });
}

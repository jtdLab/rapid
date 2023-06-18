import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}{{#mobile}}mobile{{/mobile}}/main_test.dart'
    as test;
import 'package:{{project_name}}_di/{{project_name}}_di.dart';

import 'start_app.dart' as start_app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

{{#web}}  setUpAll(() {
    test.setUrlStrategy = null;
  });
{{/web}}
  setUp(() async {
    await getIt.reset();
  });

  group('E2E (test)', () {
    testWidgets('start app', (tester) async {
      await test.main();

      await start_app.performTest(tester);
    });

    // TODO: add integration tests here (test)
  });
}

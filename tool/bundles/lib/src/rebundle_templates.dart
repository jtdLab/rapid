import 'package:bundles/src/common.dart';

import 'io.dart';

Future<void> rebundleTemplates(List<Template> templates) async {
  for (final template in templates) {
    final name = template.name;
    final path = template.path;

    print('Rebundling template $name...');
    await run(
      'mason',
      ['bundle', path, '-t', 'dart', '-o', 'packages/rapid_cli/lib/src/project/bundles'],
    );
  }
}

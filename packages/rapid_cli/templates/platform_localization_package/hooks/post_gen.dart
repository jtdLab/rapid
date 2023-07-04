import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  final projectName = context.vars['project_name'];

  generateArbFile(
    projectName: projectName,
    languageCode: context.vars['default_language_code'],
    scriptCode: context.vars['default_script_code'],
    countryCode: context.vars['default_country_code'],
  );
  final fallbackLanguageCode = context.vars['fallback_language_code'];
  if (fallbackLanguageCode != null) {
    generateArbFile(
      projectName: projectName,
      languageCode: fallbackLanguageCode,
    );
  }
}

void generateArbFile({
  required String projectName,
  required String languageCode,
  String? scriptCode,
  String? countryCode,
}) {
  final scriptCodeSegment = scriptCode != null ? '_${scriptCode}' : '';
  final countryCodeSegment = countryCode != null ? '_${countryCode}' : '';

  final arbFile = File(
    'lib/src/arb/${projectName}_$languageCode$scriptCodeSegment$countryCodeSegment.arb',
  );

  if (!arbFile.existsSync()) {
    arbFile.createSync(recursive: true);
  }

  arbFile.writeAsStringSync(
    [
      '{',
      '  "@@locale": "$languageCode$scriptCodeSegment$countryCodeSegment"',
      '}',
    ].join('\n'),
  );
}

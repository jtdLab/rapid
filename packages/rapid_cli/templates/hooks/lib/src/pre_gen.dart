import 'package:mason/mason.dart';

void addPlatformFlags(HookContext context) {
  context.vars = {
    ...context.vars,
    'android': false,
    'ios': false,
    'linux': false,
    'macos': false,
    'web': false,
    'windows': false,
    'mobile': false,
  };

  final platform = context.vars['platform'];
  context.vars = {...context.vars, platform: true};
}

void addLanguageFlags(HookContext context) {
  final scriptCode = context.vars['script_code'];
  final countryCode = context.vars['country_code'];
  context.vars = {
    ...context.vars,
    'has_script_code': scriptCode != null,
    'has_country_code': countryCode != null
  };
}

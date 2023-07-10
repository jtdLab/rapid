import 'package:mason/mason.dart';

void run(HookContext context) {
  // TODO this needs to be updated
  addLanguageFlags(context);
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

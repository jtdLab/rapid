import 'package:mason/mason.dart';

void run(HookContext context) {
  addPlatformFlags(context);
}

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
  if (platform != null) {
    context.vars = {...context.vars, platform: true};
  }
}

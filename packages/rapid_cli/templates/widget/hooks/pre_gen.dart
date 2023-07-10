import 'package:mason/mason.dart';
import 'package:hooks/hooks.dart';

void run(HookContext context) {
  if (context.vars['platform'] != null) {
    addPlatformFlags(context);
  }
}

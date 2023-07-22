import 'package:mason/mason.dart';

void run(HookContext context) {
  final name = context.vars['name'];
  context.vars = {
    ...context.vars,
    'has_name': name != null,
  };
}

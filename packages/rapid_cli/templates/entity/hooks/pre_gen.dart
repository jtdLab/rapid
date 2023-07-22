import 'package:mason/mason.dart';

void run(HookContext context) {
  final outputDir = context.vars['output_dir'];
  final subDomainName = context.vars['sub_domain_name'];
  context.vars = {
    ...context.vars,
    'output_dir_is_cwd': outputDir == '.',
    'has_sub_domain_name': subDomainName != null,
  };
}

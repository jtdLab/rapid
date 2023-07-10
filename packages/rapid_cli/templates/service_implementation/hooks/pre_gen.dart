import 'package:mason/mason.dart';

void run(HookContext context) {
  final outputDir = context.vars['output_dir'];
  final subInfrastructureName = context.vars['sub_infrastructure_name'];
  context.vars = {
    ...context.vars,
    'output_dir_is_cwd': outputDir == '.',
    'has_sub_infrastructure_name': subInfrastructureName != null,
  };
}

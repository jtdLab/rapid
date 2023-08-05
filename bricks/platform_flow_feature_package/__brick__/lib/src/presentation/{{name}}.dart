import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_{{platform}}/{{project_name}}_ui_{{platform}}.dart';

@RoutePage()
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: See https://pub.dev/packages/auto_route#nested-navigation
    return const AutoRouter();
  }
}

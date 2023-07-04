import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_{{platform}}/{{project_name}}_ui_{{platform}}.dart';
{{#subRoutes}}import 'package:{{project_name}}_{{platform}}_{{name.snakeCase()}}/{{project_name}}_{{platform}}_{{name.snakeCase()}}.dart';{{/subRoutes}}

@RoutePage()
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: See https://pub.dev/packages/auto_route#tab-navigation
    return const AutoTabsRouter(
      routes: [
{{#subRoutes}}   
        {{name.pascalCase()}}Route(),
{{/subRoutes}}   
      ],
    );
  }
}

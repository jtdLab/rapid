{{#android}}import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_ui_{{platform}}/{{project_name}}_ui_{{platform}}.dart';

@RoutePage()
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}Scaffold(
{{^macos}}      body: Center(
        child: Text(toString()),
      ),
{{/macos}}{{#macos}}      children: [
        ContentArea(
          builder: (context, _) {
            return Center(
              child: Text(toString()),
            );
          },
        ),
      ],{{/macos}}      
    );
  }
}

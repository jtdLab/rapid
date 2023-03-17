import 'package:auto_route/auto_route.dart';
import 'package:project_web_ui_web/project_web_ui_web.dart';
import 'package:project_web_web_home_page/src/presentation/l10n/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.l10n.title;

    return ProjectWebScaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}

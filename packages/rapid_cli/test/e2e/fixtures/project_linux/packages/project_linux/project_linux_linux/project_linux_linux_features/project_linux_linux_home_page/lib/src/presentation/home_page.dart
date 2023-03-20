import 'package:auto_route/auto_route.dart';
import 'package:project_linux_linux_home_page/src/presentation/l10n/l10n.dart';
import 'package:project_linux_ui_linux/project_linux_ui_linux.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.l10n.title;

    return ProjectLinuxScaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}

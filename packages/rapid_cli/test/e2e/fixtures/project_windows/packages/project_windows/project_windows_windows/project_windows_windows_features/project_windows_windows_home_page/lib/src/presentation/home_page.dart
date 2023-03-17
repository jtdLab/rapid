import 'package:auto_route/auto_route.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';
import 'package:project_windows_windows_home_page/src/presentation/l10n/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.l10n.title;

    return ProjectWindowsScaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}

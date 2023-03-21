import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_windows_ui_windows/src/scaffold_theme.dart';

class ProjectWindowsScaffold extends StatelessWidget {
  final ProjectWindowsScaffoldTheme? theme;
  final Widget body;

  const ProjectWindowsScaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.projectWindowsScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return NavigationView(
      content: Container(
        color: backgroundColor,
        child: body,
      ),
    );
  }
}

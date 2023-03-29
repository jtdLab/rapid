import 'package:flutter/cupertino.dart';
import 'package:project_macos_ui_macos/src/scaffold_theme.dart';
import 'package:macos_ui/macos_ui.dart';

class ProjectMacosScaffold extends StatelessWidget {
  final ProjectMacosScaffoldTheme? theme;
  final List<Widget> children;

  const ProjectMacosScaffold({
    super.key,
    this.theme,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.projectMacosScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return PlatformMenuBar(
      menus: const [],
      child: MacosWindow(
        backgroundColor: backgroundColor,
        child: MacosScaffold(
          backgroundColor: backgroundColor,
          children: children,
        ),
      ),
    );
  }
}

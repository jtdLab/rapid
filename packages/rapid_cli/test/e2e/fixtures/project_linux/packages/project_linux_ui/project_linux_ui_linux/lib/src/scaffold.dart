import 'package:flutter/material.dart';
import 'package:project_linux_ui_linux/src/scaffold_theme.dart';

class ProjectLinuxScaffold extends StatelessWidget {
  final ProjectLinuxScaffoldTheme? theme;
  final Widget body;

  const ProjectLinuxScaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.projectLinuxScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}

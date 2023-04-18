import 'package:flutter/material.dart';
import 'package:project_web_ui_web/src/scaffold_theme.dart';

class ProjectWebScaffold extends StatelessWidget {
  final ProjectWebScaffoldTheme? theme;
  final Widget body;

  const ProjectWebScaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.projectWebScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}

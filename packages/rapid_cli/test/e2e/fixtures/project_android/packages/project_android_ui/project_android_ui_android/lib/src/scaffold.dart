import 'package:flutter/material.dart';
import 'package:project_android_ui_android/src/scaffold_theme.dart';

class ProjectAndroidScaffold extends StatelessWidget {
  final ProjectAndroidScaffoldTheme? theme;
  final Widget body;

  const ProjectAndroidScaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ??
        Theme.of(context).extension<ProjectAndroidScaffoldTheme>()!;
    final backgroundColor = theme.backgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}

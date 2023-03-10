import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:project_ios_ui_ios/src/scaffold_theme.dart';

class ProjectIosScaffold extends StatelessWidget {
  final ProjectIosScaffoldTheme? theme;
  final Widget body;

  const ProjectIosScaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        this.theme ?? Theme.of(context).extension<ProjectIosScaffoldTheme>()!;
    final backgroundColor = theme.backgroundColor;

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      child: body,
    );
  }
}

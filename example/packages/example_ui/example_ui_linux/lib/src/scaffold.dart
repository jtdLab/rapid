import 'package:flutter/material.dart';
import 'package:example_ui_linux/src/scaffold_theme.dart';

class ExampleScaffold extends StatelessWidget {
  final ExampleScaffoldTheme? theme;
  final Widget body;

  const ExampleScaffold({
    super.key,
    this.theme,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.exampleScaffoldTheme;
    final backgroundColor = theme.backgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:example_ui_ios/src/scaffold_theme.dart';

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

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      child: body,
    );
  }
}

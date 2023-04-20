import 'package:flutter/cupertino.dart';
import 'package:example_ui_macos/src/scaffold_theme.dart';
import 'package:macos_ui/macos_ui.dart';

class ExampleScaffold extends StatelessWidget {
  final ExampleScaffoldTheme? theme;
  final List<Widget> children;

  const ExampleScaffold({
    super.key,
    this.theme,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.exampleScaffoldTheme;
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

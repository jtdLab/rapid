import 'package:example_ui_ios/src/scaffold_theme.dart';
import 'package:flutter/cupertino.dart';

class ExampleScaffold extends StatelessWidget {
  final ExampleScaffoldTheme? theme;
  final VoidCallback? onTap;
  final Widget? navigationBar;
  final Widget child;

  const ExampleScaffold({
    super.key,
    this.theme,
    this.onTap,
    this.navigationBar,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.exampleScaffoldTheme;
    final backgroundColor = theme.backgroundColor;
    final padding = theme.padding;

    return GestureDetector(
      onTap: onTap,
      child: CupertinoPageScaffold(
        backgroundColor: backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: padding,
            child: Column(
              children: [
                if (navigationBar != null) ...[
                  navigationBar!,
                  const SizedBox(height: 12),
                ],
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

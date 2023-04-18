import 'package:flutter/cupertino.dart';

import 'link_button_theme.dart';

class ExampleLinkButton extends StatelessWidget {
  final ExampleLinkButtonTheme? theme;
  final String text;
  final VoidCallback? onPressed;

  const ExampleLinkButton({
    super.key,
    this.theme,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.exampleLinkButtonTheme;
    final textStyle = theme.textStyle;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Text(
        text,
        maxLines: 1,
        style: textStyle,
      ),
    );
  }
}

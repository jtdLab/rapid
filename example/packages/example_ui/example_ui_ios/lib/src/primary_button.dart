import 'package:flutter/cupertino.dart';

import 'primary_button_theme.dart';

class ExamplePrimaryButton extends StatelessWidget {
  final ExamplePrimaryButtonTheme? theme;
  final String text;
  final bool isSubmitting;
  final VoidCallback? onPressed;

  const ExamplePrimaryButton({
    super.key,
    this.theme,
    required this.text,
    this.isSubmitting = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? context.examplePrimaryButtonTheme;
    final backgroundColor = theme.backgroundColor;
    final borderRadius = theme.borderRadius;
    final textStyle = theme.textStyle;

    return CupertinoButton(
      minSize: 55,
      padding: const EdgeInsets.all(8.0),
      color: backgroundColor,
      borderRadius: borderRadius,
      onPressed: onPressed,
      child: Center(
        child: !isSubmitting
            ? Text(
                text,
                maxLines: 1,
                style: textStyle,
              )
            : const CupertinoActivityIndicator(radius: 18),
      ),
    );
  }
}

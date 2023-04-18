import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'text_field_theme.dart';

class ExampleTextField extends HookWidget {
  final ExampleTextFieldTheme? theme;
  final String text;
  final Function(String) onChanged;
  final bool autoFocus;
  final bool autoCorrect;
  final String placeholder;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final bool isValid;
  final String? errorMessage;

  const ExampleTextField({
    super.key,
    this.theme,
    this.text = '',
    required this.onChanged,
    this.autoFocus = false,
    this.autoCorrect = false,
    this.placeholder = '',
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onEditingComplete,
  })  : isValid = true,
        errorMessage = null;

  const ExampleTextField.validate({
    super.key,
    this.theme,
    this.text = '',
    required this.onChanged,
    this.autoFocus = false,
    this.autoCorrect = false,
    this.placeholder = '',
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onEditingComplete,
    required this.isValid,
    required this.errorMessage,
  }) : assert(errorMessage != null);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: text);
    final obscureTextNotifier = useState(obscureText);

    final theme = this.theme ?? context.exampleTextFieldTheme;
    final color = theme.color;
    final errorColor = theme.errorColor;
    final cursorColor = theme.cursorColor;
    final border = Border.all(
      color: isValid ? color : errorColor,
      width: isValid ? 0.5 : 1,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          height: 44.0,
          child: ValueListenableBuilder(
            valueListenable: obscureTextNotifier,
            builder: (_, obscureText, ___) => CupertinoTextField(
              cursorColor: cursorColor,
              controller: controller,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              autofocus: autoFocus,
              autocorrect: autoCorrect,
              placeholder: placeholder,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onEditingComplete: onEditingComplete,
              onChanged: onChanged,
              suffix: this.obscureText
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          obscureTextNotifier.value =
                              !obscureTextNotifier.value;
                        },
                        child: Icon(
                          obscureText
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          color: color,
                        ),
                      ),
                    )
                  : null,
              padding: const EdgeInsets.only(left: 12.0),
              decoration: BoxDecoration(
                border: border,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ),
        if (!isValid)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 14,
                color: errorColor,
              ),
            ),
          ),
      ],
    );
  }
}

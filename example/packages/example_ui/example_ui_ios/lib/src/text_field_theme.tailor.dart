// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'text_field_theme.dart';

// **************************************************************************
// TailorGenerator
// **************************************************************************

class ExampleTextFieldTheme extends ThemeExtension<ExampleTextFieldTheme>
    with DiagnosticableTreeMixin {
  const ExampleTextFieldTheme({
    required this.color,
    required this.cursorColor,
    required this.errorColor,
    required this.textColor,
  });

  final Color color;
  final Color cursorColor;
  final Color errorColor;
  final Color textColor;

  static final ExampleTextFieldTheme light = ExampleTextFieldTheme(
    color: _$ExampleTextFieldTheme.color[0],
    cursorColor: _$ExampleTextFieldTheme.cursorColor[0],
    errorColor: _$ExampleTextFieldTheme.errorColor[0],
    textColor: _$ExampleTextFieldTheme.textColor[0],
  );

  static final ExampleTextFieldTheme dark = ExampleTextFieldTheme(
    color: _$ExampleTextFieldTheme.color[1],
    cursorColor: _$ExampleTextFieldTheme.cursorColor[1],
    errorColor: _$ExampleTextFieldTheme.errorColor[1],
    textColor: _$ExampleTextFieldTheme.textColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ExampleTextFieldTheme copyWith({
    Color? color,
    Color? cursorColor,
    Color? errorColor,
    Color? textColor,
  }) {
    return ExampleTextFieldTheme(
      color: color ?? this.color,
      cursorColor: cursorColor ?? this.cursorColor,
      errorColor: errorColor ?? this.errorColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  ExampleTextFieldTheme lerp(
      ThemeExtension<ExampleTextFieldTheme>? other, double t) {
    if (other is! ExampleTextFieldTheme) return this;
    return ExampleTextFieldTheme(
      color: Color.lerp(color, other.color, t)!,
      cursorColor: Color.lerp(cursorColor, other.cursorColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ExampleTextFieldTheme'))
      ..add(DiagnosticsProperty('color', color))
      ..add(DiagnosticsProperty('cursorColor', cursorColor))
      ..add(DiagnosticsProperty('errorColor', errorColor))
      ..add(DiagnosticsProperty('textColor', textColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExampleTextFieldTheme &&
            const DeepCollectionEquality().equals(color, other.color) &&
            const DeepCollectionEquality()
                .equals(cursorColor, other.cursorColor) &&
            const DeepCollectionEquality()
                .equals(errorColor, other.errorColor) &&
            const DeepCollectionEquality().equals(textColor, other.textColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        const DeepCollectionEquality().hash(color),
        const DeepCollectionEquality().hash(cursorColor),
        const DeepCollectionEquality().hash(errorColor),
        const DeepCollectionEquality().hash(textColor));
  }
}

extension ExampleTextFieldThemeBuildContext on BuildContext {
  ExampleTextFieldTheme get exampleTextFieldTheme =>
      Theme.of(this).extension<ExampleTextFieldTheme>()!;
}

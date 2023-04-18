// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'primary_button_theme.dart';

// **************************************************************************
// TailorGenerator
// **************************************************************************

class ExamplePrimaryButtonTheme
    extends ThemeExtension<ExamplePrimaryButtonTheme>
    with DiagnosticableTreeMixin {
  const ExamplePrimaryButtonTheme({
    required this.backgroundColor,
    required this.borderRadius,
    required this.textStyle,
  });

  final Color backgroundColor;
  final BorderRadius borderRadius;
  final TextStyle textStyle;

  static final ExamplePrimaryButtonTheme light = ExamplePrimaryButtonTheme(
    backgroundColor: _$ExamplePrimaryButtonTheme.backgroundColor[0],
    borderRadius: _$ExamplePrimaryButtonTheme.borderRadius[0],
    textStyle: _$ExamplePrimaryButtonTheme.textStyle[0],
  );

  static final ExamplePrimaryButtonTheme dark = ExamplePrimaryButtonTheme(
    backgroundColor: _$ExamplePrimaryButtonTheme.backgroundColor[1],
    borderRadius: _$ExamplePrimaryButtonTheme.borderRadius[1],
    textStyle: _$ExamplePrimaryButtonTheme.textStyle[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ExamplePrimaryButtonTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
  }) {
    return ExamplePrimaryButtonTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  ExamplePrimaryButtonTheme lerp(
      ThemeExtension<ExamplePrimaryButtonTheme>? other, double t) {
    if (other is! ExamplePrimaryButtonTheme) return this;
    return ExamplePrimaryButtonTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      borderRadius: t < 0.5 ? borderRadius : other.borderRadius,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ExamplePrimaryButtonTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('textStyle', textStyle));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExamplePrimaryButtonTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor) &&
            const DeepCollectionEquality()
                .equals(borderRadius, other.borderRadius) &&
            const DeepCollectionEquality().equals(textStyle, other.textStyle));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        const DeepCollectionEquality().hash(backgroundColor),
        const DeepCollectionEquality().hash(borderRadius),
        const DeepCollectionEquality().hash(textStyle));
  }
}

extension ExamplePrimaryButtonThemeBuildContext on BuildContext {
  ExamplePrimaryButtonTheme get examplePrimaryButtonTheme =>
      Theme.of(this).extension<ExamplePrimaryButtonTheme>()!;
}

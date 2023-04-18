// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'link_button_theme.dart';

// **************************************************************************
// TailorGenerator
// **************************************************************************

class ExampleLinkButtonTheme extends ThemeExtension<ExampleLinkButtonTheme>
    with DiagnosticableTreeMixin {
  const ExampleLinkButtonTheme({
    required this.textStyle,
  });

  final TextStyle textStyle;

  static final ExampleLinkButtonTheme light = ExampleLinkButtonTheme(
    textStyle: _$ExampleLinkButtonTheme.textStyle[0],
  );

  static final ExampleLinkButtonTheme dark = ExampleLinkButtonTheme(
    textStyle: _$ExampleLinkButtonTheme.textStyle[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ExampleLinkButtonTheme copyWith({
    TextStyle? textStyle,
  }) {
    return ExampleLinkButtonTheme(
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  ExampleLinkButtonTheme lerp(
      ThemeExtension<ExampleLinkButtonTheme>? other, double t) {
    if (other is! ExampleLinkButtonTheme) return this;
    return ExampleLinkButtonTheme(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ExampleLinkButtonTheme'))
      ..add(DiagnosticsProperty('textStyle', textStyle));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExampleLinkButtonTheme &&
            const DeepCollectionEquality().equals(textStyle, other.textStyle));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(textStyle));
  }
}

extension ExampleLinkButtonThemeBuildContext on BuildContext {
  ExampleLinkButtonTheme get exampleLinkButtonTheme =>
      Theme.of(this).extension<ExampleLinkButtonTheme>()!;
}

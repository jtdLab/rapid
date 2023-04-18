// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ExampleColorTheme extends ThemeExtension<ExampleColorTheme>
    with DiagnosticableTreeMixin {
  const ExampleColorTheme({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;

  static final ExampleColorTheme light = ExampleColorTheme(
    primary: _$ExampleColorTheme.primary[0],
    secondary: _$ExampleColorTheme.secondary[0],
  );

  static final ExampleColorTheme dark = ExampleColorTheme(
    primary: _$ExampleColorTheme.primary[1],
    secondary: _$ExampleColorTheme.secondary[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ExampleColorTheme copyWith({
    Color? primary,
    Color? secondary,
  }) {
    return ExampleColorTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  ExampleColorTheme lerp(ThemeExtension<ExampleColorTheme>? other, double t) {
    if (other is! ExampleColorTheme) return this;
    return ExampleColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ExampleColorTheme'))
      ..add(DiagnosticsProperty('primary', primary))
      ..add(DiagnosticsProperty('secondary', secondary));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExampleColorTheme &&
            const DeepCollectionEquality().equals(primary, other.primary) &&
            const DeepCollectionEquality().equals(secondary, other.secondary));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        const DeepCollectionEquality().hash(primary),
        const DeepCollectionEquality().hash(secondary));
  }
}

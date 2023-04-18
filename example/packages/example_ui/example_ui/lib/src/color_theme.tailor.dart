// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// TailorGenerator
// **************************************************************************

class ExampleColorTheme extends ThemeExtension<ExampleColorTheme>
    with DiagnosticableTreeMixin {
  const ExampleColorTheme({
    required this.background,
    required this.error,
    required this.grey,
    required this.primary,
    required this.quaternary,
    required this.secondary,
    required this.tertiary,
  });

  final Color background;
  final Color error;
  final Color grey;
  final Color primary;
  final Color quaternary;
  final Color secondary;
  final Color tertiary;

  static final ExampleColorTheme light = ExampleColorTheme(
    background: _$ExampleColorTheme.background[0],
    error: _$ExampleColorTheme.error[0],
    grey: _$ExampleColorTheme.grey[0],
    primary: _$ExampleColorTheme.primary[0],
    quaternary: _$ExampleColorTheme.quaternary[0],
    secondary: _$ExampleColorTheme.secondary[0],
    tertiary: _$ExampleColorTheme.tertiary[0],
  );

  static final ExampleColorTheme dark = ExampleColorTheme(
    background: _$ExampleColorTheme.background[1],
    error: _$ExampleColorTheme.error[1],
    grey: _$ExampleColorTheme.grey[1],
    primary: _$ExampleColorTheme.primary[1],
    quaternary: _$ExampleColorTheme.quaternary[1],
    secondary: _$ExampleColorTheme.secondary[1],
    tertiary: _$ExampleColorTheme.tertiary[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ExampleColorTheme copyWith({
    Color? background,
    Color? error,
    Color? grey,
    Color? primary,
    Color? quaternary,
    Color? secondary,
    Color? tertiary,
  }) {
    return ExampleColorTheme(
      background: background ?? this.background,
      error: error ?? this.error,
      grey: grey ?? this.grey,
      primary: primary ?? this.primary,
      quaternary: quaternary ?? this.quaternary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
    );
  }

  @override
  ExampleColorTheme lerp(
      ThemeExtension<ExampleColorTheme>? other, double t) {
    if (other is! ExampleColorTheme) return this;
    return ExampleColorTheme(
      background: Color.lerp(background, other.background, t)!,
      error: Color.lerp(error, other.error, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      quaternary: Color.lerp(quaternary, other.quaternary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ExampleColorTheme'))
      ..add(DiagnosticsProperty('background', background))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('grey', grey))
      ..add(DiagnosticsProperty('primary', primary))
      ..add(DiagnosticsProperty('quaternary', quaternary))
      ..add(DiagnosticsProperty('secondary', secondary))
      ..add(DiagnosticsProperty('tertiary', tertiary));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExampleColorTheme &&
            const DeepCollectionEquality()
                .equals(background, other.background) &&
            const DeepCollectionEquality().equals(error, other.error) &&
            const DeepCollectionEquality().equals(grey, other.grey) &&
            const DeepCollectionEquality().equals(primary, other.primary) &&
            const DeepCollectionEquality()
                .equals(quaternary, other.quaternary) &&
            const DeepCollectionEquality().equals(secondary, other.secondary) &&
            const DeepCollectionEquality().equals(tertiary, other.tertiary));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        const DeepCollectionEquality().hash(background),
        const DeepCollectionEquality().hash(error),
        const DeepCollectionEquality().hash(grey),
        const DeepCollectionEquality().hash(primary),
        const DeepCollectionEquality().hash(quaternary),
        const DeepCollectionEquality().hash(secondary),
        const DeepCollectionEquality().hash(tertiary));
  }
}

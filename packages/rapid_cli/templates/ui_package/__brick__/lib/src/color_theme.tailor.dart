// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class {{project_name.pascalCase()}}ColorTheme extends ThemeExtension<{{project_name.pascalCase()}}ColorTheme>
    with DiagnosticableTreeMixin {
  const {{project_name.pascalCase()}}ColorTheme({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;

  static final {{project_name.pascalCase()}}ColorTheme light = {{project_name.pascalCase()}}ColorTheme(
    primary: _${{project_name.pascalCase()}}ColorTheme.primary[0],
    secondary: _${{project_name.pascalCase()}}ColorTheme.secondary[0],
  );

  static final {{project_name.pascalCase()}}ColorTheme dark = {{project_name.pascalCase()}}ColorTheme(
    primary: _${{project_name.pascalCase()}}ColorTheme.primary[1],
    secondary: _${{project_name.pascalCase()}}ColorTheme.secondary[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  {{project_name.pascalCase()}}ColorTheme copyWith({
    Color? primary,
    Color? secondary,
  }) {
    return {{project_name.pascalCase()}}ColorTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  {{project_name.pascalCase()}}ColorTheme lerp(ThemeExtension<{{project_name.pascalCase()}}ColorTheme>? other, double t) {
    if (other is! {{project_name.pascalCase()}}ColorTheme) return this;
    return {{project_name.pascalCase()}}ColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '{{project_name.pascalCase()}}ColorTheme'))
      ..add(DiagnosticsProperty('primary', primary))
      ..add(DiagnosticsProperty('secondary', secondary));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is {{project_name.pascalCase()}}ColorTheme &&
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

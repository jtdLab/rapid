// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectWindowsColorTheme extends ThemeExtension<ProjectWindowsColorTheme>
    with DiagnosticableTreeMixin {
  const ProjectWindowsColorTheme({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;

  static final ProjectWindowsColorTheme light = ProjectWindowsColorTheme(
    primary: _$ProjectWindowsColorTheme.primary[0],
    secondary: _$ProjectWindowsColorTheme.secondary[0],
  );

  static final ProjectWindowsColorTheme dark = ProjectWindowsColorTheme(
    primary: _$ProjectWindowsColorTheme.primary[1],
    secondary: _$ProjectWindowsColorTheme.secondary[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectWindowsColorTheme copyWith({
    Color? primary,
    Color? secondary,
  }) {
    return ProjectWindowsColorTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  ProjectWindowsColorTheme lerp(
      ThemeExtension<ProjectWindowsColorTheme>? other, double t) {
    if (other is! ProjectWindowsColorTheme) return this;
    return ProjectWindowsColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProjectWindowsColorTheme'))
      ..add(DiagnosticsProperty('primary', primary))
      ..add(DiagnosticsProperty('secondary', secondary));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectWindowsColorTheme &&
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

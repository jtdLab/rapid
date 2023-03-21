// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectLinuxColorTheme extends ThemeExtension<ProjectLinuxColorTheme>
    with DiagnosticableTreeMixin {
  const ProjectLinuxColorTheme({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;

  static final ProjectLinuxColorTheme light = ProjectLinuxColorTheme(
    primary: _$ProjectLinuxColorTheme.primary[0],
    secondary: _$ProjectLinuxColorTheme.secondary[0],
  );

  static final ProjectLinuxColorTheme dark = ProjectLinuxColorTheme(
    primary: _$ProjectLinuxColorTheme.primary[1],
    secondary: _$ProjectLinuxColorTheme.secondary[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectLinuxColorTheme copyWith({
    Color? primary,
    Color? secondary,
  }) {
    return ProjectLinuxColorTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  ProjectLinuxColorTheme lerp(
      ThemeExtension<ProjectLinuxColorTheme>? other, double t) {
    if (other is! ProjectLinuxColorTheme) return this;
    return ProjectLinuxColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProjectLinuxColorTheme'))
      ..add(DiagnosticsProperty('primary', primary))
      ..add(DiagnosticsProperty('secondary', secondary));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectLinuxColorTheme &&
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

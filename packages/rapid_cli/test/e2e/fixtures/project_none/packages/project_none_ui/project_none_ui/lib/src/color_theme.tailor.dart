// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectNoneColorTheme extends ThemeExtension<ProjectNoneColorTheme>
    with DiagnosticableTreeMixin {
  const ProjectNoneColorTheme({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;

  static final ProjectNoneColorTheme light = ProjectNoneColorTheme(
    primary: _$ProjectNoneColorTheme.primary[0],
    secondary: _$ProjectNoneColorTheme.secondary[0],
  );

  static final ProjectNoneColorTheme dark = ProjectNoneColorTheme(
    primary: _$ProjectNoneColorTheme.primary[1],
    secondary: _$ProjectNoneColorTheme.secondary[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectNoneColorTheme copyWith({
    Color? primary,
    Color? secondary,
  }) {
    return ProjectNoneColorTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  ProjectNoneColorTheme lerp(
      ThemeExtension<ProjectNoneColorTheme>? other, double t) {
    if (other is! ProjectNoneColorTheme) return this;
    return ProjectNoneColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProjectNoneColorTheme'))
      ..add(DiagnosticsProperty('primary', primary))
      ..add(DiagnosticsProperty('secondary', secondary));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectNoneColorTheme &&
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

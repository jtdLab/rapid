// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectMacosColorTheme extends ThemeExtension<ProjectMacosColorTheme> {
  const ProjectMacosColorTheme({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;

  static final ProjectMacosColorTheme light = ProjectMacosColorTheme(
    primary: _$ProjectMacosColorTheme.primary[0],
    secondary: _$ProjectMacosColorTheme.secondary[0],
  );

  static final ProjectMacosColorTheme dark = ProjectMacosColorTheme(
    primary: _$ProjectMacosColorTheme.primary[1],
    secondary: _$ProjectMacosColorTheme.secondary[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectMacosColorTheme copyWith({
    Color? primary,
    Color? secondary,
  }) {
    return ProjectMacosColorTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  ProjectMacosColorTheme lerp(
      ThemeExtension<ProjectMacosColorTheme>? other, double t) {
    if (other is! ProjectMacosColorTheme) return this;
    return ProjectMacosColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectMacosColorTheme &&
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

extension ProjectMacosColorThemeBuildContextProps on BuildContext {
  ProjectMacosColorTheme get _lolJonasColorTheme =>
      Theme.of(this).extension<ProjectMacosColorTheme>()!;
  Color get primary => _lolJonasColorTheme.primary;
  Color get secondary => _lolJonasColorTheme.secondary;
}

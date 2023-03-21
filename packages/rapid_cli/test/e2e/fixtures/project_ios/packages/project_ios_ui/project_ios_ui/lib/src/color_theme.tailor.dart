// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectIosColorTheme extends ThemeExtension<ProjectIosColorTheme> {
  const ProjectIosColorTheme({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;

  static final ProjectIosColorTheme light = ProjectIosColorTheme(
    primary: _$ProjectIosColorTheme.primary[0],
    secondary: _$ProjectIosColorTheme.secondary[0],
  );

  static final ProjectIosColorTheme dark = ProjectIosColorTheme(
    primary: _$ProjectIosColorTheme.primary[1],
    secondary: _$ProjectIosColorTheme.secondary[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectIosColorTheme copyWith({
    Color? primary,
    Color? secondary,
  }) {
    return ProjectIosColorTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  ProjectIosColorTheme lerp(
      ThemeExtension<ProjectIosColorTheme>? other, double t) {
    if (other is! ProjectIosColorTheme) return this;
    return ProjectIosColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectIosColorTheme &&
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

extension ProjectIosColorThemeBuildContextProps on BuildContext {
  ProjectIosColorTheme get _projectIosColorTheme =>
      Theme.of(this).extension<ProjectIosColorTheme>()!;
  Color get primary => _projectIosColorTheme.primary;
  Color get secondary => _projectIosColorTheme.secondary;
}

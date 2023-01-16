// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectNoneColorTheme extends ThemeExtension<ProjectNoneColorTheme> {
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

extension ProjectNoneColorThemeBuildContextProps on BuildContext {
  ProjectNoneColorTheme get _lolJonasColorTheme =>
      Theme.of(this).extension<ProjectNoneColorTheme>()!;
  Color get primary => _lolJonasColorTheme.primary;
  Color get secondary => _lolJonasColorTheme.secondary;
}

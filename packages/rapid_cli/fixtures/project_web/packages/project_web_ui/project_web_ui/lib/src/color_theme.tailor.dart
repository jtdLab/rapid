// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectWebColorTheme extends ThemeExtension<ProjectWebColorTheme> {
  const ProjectWebColorTheme({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;

  static final ProjectWebColorTheme light = ProjectWebColorTheme(
    primary: _$ProjectWebColorTheme.primary[0],
    secondary: _$ProjectWebColorTheme.secondary[0],
  );

  static final ProjectWebColorTheme dark = ProjectWebColorTheme(
    primary: _$ProjectWebColorTheme.primary[1],
    secondary: _$ProjectWebColorTheme.secondary[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectWebColorTheme copyWith({
    Color? primary,
    Color? secondary,
  }) {
    return ProjectWebColorTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  ProjectWebColorTheme lerp(
      ThemeExtension<ProjectWebColorTheme>? other, double t) {
    if (other is! ProjectWebColorTheme) return this;
    return ProjectWebColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectWebColorTheme &&
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

extension ProjectWebColorThemeBuildContextProps on BuildContext {
  ProjectWebColorTheme get _lolJonasColorTheme =>
      Theme.of(this).extension<ProjectWebColorTheme>()!;
  Color get primary => _lolJonasColorTheme.primary;
  Color get secondary => _lolJonasColorTheme.secondary;
}

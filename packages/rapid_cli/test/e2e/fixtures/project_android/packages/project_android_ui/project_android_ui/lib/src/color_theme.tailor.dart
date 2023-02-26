// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'color_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectAndroidColorTheme
    extends ThemeExtension<ProjectAndroidColorTheme> {
  const ProjectAndroidColorTheme({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;

  static final ProjectAndroidColorTheme light = ProjectAndroidColorTheme(
    primary: _$ProjectAndroidColorTheme.primary[0],
    secondary: _$ProjectAndroidColorTheme.secondary[0],
  );

  static final ProjectAndroidColorTheme dark = ProjectAndroidColorTheme(
    primary: _$ProjectAndroidColorTheme.primary[1],
    secondary: _$ProjectAndroidColorTheme.secondary[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectAndroidColorTheme copyWith({
    Color? primary,
    Color? secondary,
  }) {
    return ProjectAndroidColorTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  ProjectAndroidColorTheme lerp(
      ThemeExtension<ProjectAndroidColorTheme>? other, double t) {
    if (other is! ProjectAndroidColorTheme) return this;
    return ProjectAndroidColorTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectAndroidColorTheme &&
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

extension ProjectAndroidColorThemeBuildContextProps on BuildContext {
  ProjectAndroidColorTheme get _projectAndroidColorTheme =>
      Theme.of(this).extension<ProjectAndroidColorTheme>()!;
  Color get primary => _projectAndroidColorTheme.primary;
  Color get secondary => _projectAndroidColorTheme.secondary;
}

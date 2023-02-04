// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectAndroidScaffoldTheme
    extends ThemeExtension<ProjectAndroidScaffoldTheme> {
  const ProjectAndroidScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final ProjectAndroidScaffoldTheme light = ProjectAndroidScaffoldTheme(
    backgroundColor: _$ProjectAndroidScaffoldTheme.backgroundColor[0],
  );

  static final ProjectAndroidScaffoldTheme dark = ProjectAndroidScaffoldTheme(
    backgroundColor: _$ProjectAndroidScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectAndroidScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return ProjectAndroidScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  ProjectAndroidScaffoldTheme lerp(
      ThemeExtension<ProjectAndroidScaffoldTheme>? other, double t) {
    if (other is! ProjectAndroidScaffoldTheme) return this;
    return ProjectAndroidScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectAndroidScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

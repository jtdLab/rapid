// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectLinuxScaffoldTheme
    extends ThemeExtension<ProjectLinuxScaffoldTheme> {
  const ProjectLinuxScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final ProjectLinuxScaffoldTheme light = ProjectLinuxScaffoldTheme(
    backgroundColor: _$ProjectLinuxScaffoldTheme.backgroundColor[0],
  );

  static final ProjectLinuxScaffoldTheme dark = ProjectLinuxScaffoldTheme(
    backgroundColor: _$ProjectLinuxScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectLinuxScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return ProjectLinuxScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  ProjectLinuxScaffoldTheme lerp(
      ThemeExtension<ProjectLinuxScaffoldTheme>? other, double t) {
    if (other is! ProjectLinuxScaffoldTheme) return this;
    return ProjectLinuxScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectLinuxScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

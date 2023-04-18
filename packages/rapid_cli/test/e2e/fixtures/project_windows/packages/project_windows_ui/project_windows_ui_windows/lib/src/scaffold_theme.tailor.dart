// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectWindowsScaffoldTheme
    extends ThemeExtension<ProjectWindowsScaffoldTheme>
    with DiagnosticableTreeMixin {
  const ProjectWindowsScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final ProjectWindowsScaffoldTheme light = ProjectWindowsScaffoldTheme(
    backgroundColor: _$ProjectWindowsScaffoldTheme.backgroundColor[0],
  );

  static final ProjectWindowsScaffoldTheme dark = ProjectWindowsScaffoldTheme(
    backgroundColor: _$ProjectWindowsScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectWindowsScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return ProjectWindowsScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  ProjectWindowsScaffoldTheme lerp(
      ThemeExtension<ProjectWindowsScaffoldTheme>? other, double t) {
    if (other is! ProjectWindowsScaffoldTheme) return this;
    return ProjectWindowsScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProjectWindowsScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectWindowsScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension ProjectWindowsScaffoldThemeBuildContext on BuildContext {
  ProjectWindowsScaffoldTheme get projectWindowsScaffoldTheme =>
      Theme.of(this).extension<ProjectWindowsScaffoldTheme>()!;
}

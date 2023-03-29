// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectWebScaffoldTheme extends ThemeExtension<ProjectWebScaffoldTheme>
    with DiagnosticableTreeMixin {
  const ProjectWebScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final ProjectWebScaffoldTheme light = ProjectWebScaffoldTheme(
    backgroundColor: _$ProjectWebScaffoldTheme.backgroundColor[0],
  );

  static final ProjectWebScaffoldTheme dark = ProjectWebScaffoldTheme(
    backgroundColor: _$ProjectWebScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectWebScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return ProjectWebScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  ProjectWebScaffoldTheme lerp(
      ThemeExtension<ProjectWebScaffoldTheme>? other, double t) {
    if (other is! ProjectWebScaffoldTheme) return this;
    return ProjectWebScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProjectWebScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectWebScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension ProjectWebScaffoldThemeBuildContext on BuildContext {
  ProjectWebScaffoldTheme get projectWebScaffoldTheme =>
      Theme.of(this).extension<ProjectWebScaffoldTheme>()!;
}

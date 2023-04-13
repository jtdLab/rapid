// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectMacosScaffoldTheme
    extends ThemeExtension<ProjectMacosScaffoldTheme>
    with DiagnosticableTreeMixin {
  const ProjectMacosScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final ProjectMacosScaffoldTheme light = ProjectMacosScaffoldTheme(
    backgroundColor: _$ProjectMacosScaffoldTheme.backgroundColor[0],
  );

  static final ProjectMacosScaffoldTheme dark = ProjectMacosScaffoldTheme(
    backgroundColor: _$ProjectMacosScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectMacosScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return ProjectMacosScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  ProjectMacosScaffoldTheme lerp(
      ThemeExtension<ProjectMacosScaffoldTheme>? other, double t) {
    if (other is! ProjectMacosScaffoldTheme) return this;
    return ProjectMacosScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProjectMacosScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectMacosScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension ProjectMacosScaffoldThemeBuildContext on BuildContext {
  ProjectMacosScaffoldTheme get projectMacosScaffoldTheme =>
      Theme.of(this).extension<ProjectMacosScaffoldTheme>()!;
}

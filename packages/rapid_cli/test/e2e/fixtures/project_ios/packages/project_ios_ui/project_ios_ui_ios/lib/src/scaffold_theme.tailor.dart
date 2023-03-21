// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ProjectIosScaffoldTheme extends ThemeExtension<ProjectIosScaffoldTheme>
    with DiagnosticableTreeMixin {
  const ProjectIosScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final ProjectIosScaffoldTheme light = ProjectIosScaffoldTheme(
    backgroundColor: _$ProjectIosScaffoldTheme.backgroundColor[0],
  );

  static final ProjectIosScaffoldTheme dark = ProjectIosScaffoldTheme(
    backgroundColor: _$ProjectIosScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ProjectIosScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return ProjectIosScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  ProjectIosScaffoldTheme lerp(
      ThemeExtension<ProjectIosScaffoldTheme>? other, double t) {
    if (other is! ProjectIosScaffoldTheme) return this;
    return ProjectIosScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProjectIosScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectIosScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension ProjectIosScaffoldThemeBuildContext on BuildContext {
  ProjectIosScaffoldTheme get projectIosScaffoldTheme =>
      Theme.of(this).extension<ProjectIosScaffoldTheme>()!;
}

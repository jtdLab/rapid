// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class ExampleScaffoldTheme extends ThemeExtension<ExampleScaffoldTheme>
    with DiagnosticableTreeMixin {
  const ExampleScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final ExampleScaffoldTheme light = ExampleScaffoldTheme(
    backgroundColor: _$ExampleScaffoldTheme.backgroundColor[0],
  );

  static final ExampleScaffoldTheme dark = ExampleScaffoldTheme(
    backgroundColor: _$ExampleScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ExampleScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return ExampleScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  ExampleScaffoldTheme lerp(
      ThemeExtension<ExampleScaffoldTheme>? other, double t) {
    if (other is! ExampleScaffoldTheme) return this;
    return ExampleScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ExampleScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExampleScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension ExampleScaffoldThemeBuildContext on BuildContext {
  ExampleScaffoldTheme get exampleScaffoldTheme =>
      Theme.of(this).extension<ExampleScaffoldTheme>()!;
}

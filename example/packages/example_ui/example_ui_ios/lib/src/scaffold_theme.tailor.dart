// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// TailorGenerator
// **************************************************************************

class ExampleScaffoldTheme extends ThemeExtension<ExampleScaffoldTheme>
    with DiagnosticableTreeMixin {
  const ExampleScaffoldTheme({
    required this.backgroundColor,
    required this.padding,
  });

  final Color backgroundColor;
  final EdgeInsets padding;

  static final ExampleScaffoldTheme light = ExampleScaffoldTheme(
    backgroundColor: _$ExampleScaffoldTheme.backgroundColor[0],
    padding: _$ExampleScaffoldTheme.padding[0],
  );

  static final ExampleScaffoldTheme dark = ExampleScaffoldTheme(
    backgroundColor: _$ExampleScaffoldTheme.backgroundColor[1],
    padding: _$ExampleScaffoldTheme.padding[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  ExampleScaffoldTheme copyWith({
    Color? backgroundColor,
    EdgeInsets? padding,
  }) {
    return ExampleScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
    );
  }

  @override
  ExampleScaffoldTheme lerp(
      ThemeExtension<ExampleScaffoldTheme>? other, double t) {
    if (other is! ExampleScaffoldTheme) return this;
    return ExampleScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      padding: t < 0.5 ? padding : other.padding,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ExampleScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty('padding', padding));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExampleScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor) &&
            const DeepCollectionEquality().equals(padding, other.padding));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        const DeepCollectionEquality().hash(backgroundColor),
        const DeepCollectionEquality().hash(padding));
  }
}

extension ExampleScaffoldThemeBuildContext on BuildContext {
  ExampleScaffoldTheme get exampleScaffoldTheme =>
      Theme.of(this).extension<ExampleScaffoldTheme>()!;
}

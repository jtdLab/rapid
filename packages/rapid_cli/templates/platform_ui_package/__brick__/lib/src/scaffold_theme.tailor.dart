{{#android}}// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class {{project_name.pascalCase()}}ScaffoldTheme extends ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>
    with DiagnosticableTreeMixin {
  const {{project_name.pascalCase()}}ScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final {{project_name.pascalCase()}}ScaffoldTheme light = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[0],
  );

  static final {{project_name.pascalCase()}}ScaffoldTheme dark = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  {{project_name.pascalCase()}}ScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  {{project_name.pascalCase()}}ScaffoldTheme lerp(
      ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>? other, double t) {
    if (other is! {{project_name.pascalCase()}}ScaffoldTheme) return this;
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '{{project_name.pascalCase()}}ScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is {{project_name.pascalCase()}}ScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension {{project_name.pascalCase()}}ScaffoldThemeBuildContext on BuildContext {
  {{project_name.pascalCase()}}ScaffoldTheme get {{project_name.camelCase()}}ScaffoldTheme =>
      Theme.of(this).extension<{{project_name.pascalCase()}}ScaffoldTheme>()!;
}
{{/android}}{{#ios}}
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class {{project_name.pascalCase()}}ScaffoldTheme extends ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>
    with DiagnosticableTreeMixin {
  const {{project_name.pascalCase()}}ScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final {{project_name.pascalCase()}}ScaffoldTheme light = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[0],
  );

  static final {{project_name.pascalCase()}}ScaffoldTheme dark = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  {{project_name.pascalCase()}}ScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  {{project_name.pascalCase()}}ScaffoldTheme lerp(
      ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>? other, double t) {
    if (other is! {{project_name.pascalCase()}}ScaffoldTheme) return this;
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '{{project_name.pascalCase()}}ScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is {{project_name.pascalCase()}}ScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension {{project_name.pascalCase()}}ScaffoldThemeBuildContext on BuildContext {
  {{project_name.pascalCase()}}ScaffoldTheme get {{project_name.camelCase()}}ScaffoldTheme =>
      Theme.of(this).extension<{{project_name.pascalCase()}}ScaffoldTheme>()!;
}
{{/ios}}{{#linux}}
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class {{project_name.pascalCase()}}ScaffoldTheme extends ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>
    with DiagnosticableTreeMixin {
  const {{project_name.pascalCase()}}ScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final {{project_name.pascalCase()}}ScaffoldTheme light = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[0],
  );

  static final {{project_name.pascalCase()}}ScaffoldTheme dark = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  {{project_name.pascalCase()}}ScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  {{project_name.pascalCase()}}ScaffoldTheme lerp(
      ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>? other, double t) {
    if (other is! {{project_name.pascalCase()}}ScaffoldTheme) return this;
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '{{project_name.pascalCase()}}ScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is {{project_name.pascalCase()}}ScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension {{project_name.pascalCase()}}ScaffoldThemeBuildContext on BuildContext {
  {{project_name.pascalCase()}}ScaffoldTheme get {{project_name.camelCase()}}ScaffoldTheme =>
      Theme.of(this).extension<{{project_name.pascalCase()}}ScaffoldTheme>()!;
}
{{/linux}}{{#macos}}
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class {{project_name.pascalCase()}}ScaffoldTheme extends ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>
    with DiagnosticableTreeMixin {
  const {{project_name.pascalCase()}}ScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final {{project_name.pascalCase()}}ScaffoldTheme light = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[0],
  );

  static final {{project_name.pascalCase()}}ScaffoldTheme dark = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  {{project_name.pascalCase()}}ScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  {{project_name.pascalCase()}}ScaffoldTheme lerp(
      ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>? other, double t) {
    if (other is! {{project_name.pascalCase()}}ScaffoldTheme) return this;
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '{{project_name.pascalCase()}}ScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is {{project_name.pascalCase()}}ScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension {{project_name.pascalCase()}}ScaffoldThemeBuildContext on BuildContext {
  {{project_name.pascalCase()}}ScaffoldTheme get {{project_name.camelCase()}}ScaffoldTheme =>
      Theme.of(this).extension<{{project_name.pascalCase()}}ScaffoldTheme>()!;
}
{{/macos}}{{#web}}
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class {{project_name.pascalCase()}}ScaffoldTheme extends ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>
    with DiagnosticableTreeMixin {
  const {{project_name.pascalCase()}}ScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final {{project_name.pascalCase()}}ScaffoldTheme light = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[0],
  );

  static final {{project_name.pascalCase()}}ScaffoldTheme dark = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  {{project_name.pascalCase()}}ScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  {{project_name.pascalCase()}}ScaffoldTheme lerp(
      ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>? other, double t) {
    if (other is! {{project_name.pascalCase()}}ScaffoldTheme) return this;
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '{{project_name.pascalCase()}}ScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is {{project_name.pascalCase()}}ScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension {{project_name.pascalCase()}}ScaffoldThemeBuildContext on BuildContext {
  {{project_name.pascalCase()}}ScaffoldTheme get {{project_name.camelCase()}}ScaffoldTheme =>
      Theme.of(this).extension<{{project_name.pascalCase()}}ScaffoldTheme>()!;
}
{{/web}}{{#windows}}
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class {{project_name.pascalCase()}}ScaffoldTheme extends ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>
    with DiagnosticableTreeMixin {
  const {{project_name.pascalCase()}}ScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final {{project_name.pascalCase()}}ScaffoldTheme light = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[0],
  );

  static final {{project_name.pascalCase()}}ScaffoldTheme dark = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  {{project_name.pascalCase()}}ScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  {{project_name.pascalCase()}}ScaffoldTheme lerp(
      ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>? other, double t) {
    if (other is! {{project_name.pascalCase()}}ScaffoldTheme) return this;
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '{{project_name.pascalCase()}}ScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is {{project_name.pascalCase()}}ScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension {{project_name.pascalCase()}}ScaffoldThemeBuildContext on BuildContext {
  {{project_name.pascalCase()}}ScaffoldTheme get {{project_name.camelCase()}}ScaffoldTheme =>
      Theme.of(this).extension<{{project_name.pascalCase()}}ScaffoldTheme>()!;
}
{{/windows}}{{#mobile}}// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'scaffold_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class {{project_name.pascalCase()}}ScaffoldTheme extends ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>
    with DiagnosticableTreeMixin {
  const {{project_name.pascalCase()}}ScaffoldTheme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final {{project_name.pascalCase()}}ScaffoldTheme light = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[0],
  );

  static final {{project_name.pascalCase()}}ScaffoldTheme dark = {{project_name.pascalCase()}}ScaffoldTheme(
    backgroundColor: _${{project_name.pascalCase()}}ScaffoldTheme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  {{project_name.pascalCase()}}ScaffoldTheme copyWith({
    Color? backgroundColor,
  }) {
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  {{project_name.pascalCase()}}ScaffoldTheme lerp(
      ThemeExtension<{{project_name.pascalCase()}}ScaffoldTheme>? other, double t) {
    if (other is! {{project_name.pascalCase()}}ScaffoldTheme) return this;
    return {{project_name.pascalCase()}}ScaffoldTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '{{project_name.pascalCase()}}ScaffoldTheme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is {{project_name.pascalCase()}}ScaffoldTheme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension {{project_name.pascalCase()}}ScaffoldThemeBuildContext on BuildContext {
  {{project_name.pascalCase()}}ScaffoldTheme get {{project_name.camelCase()}}ScaffoldTheme =>
      Theme.of(this).extension<{{project_name.pascalCase()}}ScaffoldTheme>()!;
}
{{/mobile}}
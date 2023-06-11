// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element, unnecessary_cast

part of '{{name.snakeCase()}}_theme.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

class {{project_name.pascalCase()}}{{name.pascalCase()}}Theme extends ThemeExtension<{{project_name.pascalCase()}}{{name.pascalCase()}}Theme>
    with DiagnosticableTreeMixin {
  const {{project_name.pascalCase()}}{{name.pascalCase()}}Theme({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  static final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme light = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme(
    backgroundColor: _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme.backgroundColor[0],
  );

  static final {{project_name.pascalCase()}}{{name.pascalCase()}}Theme dark = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme(
    backgroundColor: _${{project_name.pascalCase()}}{{name.pascalCase()}}Theme.backgroundColor[1],
  );

  static final themes = [
    light,
    dark,
  ];

  @override
  {{project_name.pascalCase()}}{{name.pascalCase()}}Theme copyWith({
    Color? backgroundColor,
  }) {
    return {{project_name.pascalCase()}}{{name.pascalCase()}}Theme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  {{project_name.pascalCase()}}{{name.pascalCase()}}Theme lerp(
      covariant ThemeExtension<{{project_name.pascalCase()}}{{name.pascalCase()}}Theme>? other, double t) {
    if (other is! {{project_name.pascalCase()}}{{name.pascalCase()}}Theme) return this as {{project_name.pascalCase()}}{{name.pascalCase()}}Theme;
    return {{project_name.pascalCase()}}{{name.pascalCase()}}Theme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '{{project_name.pascalCase()}}{{name.pascalCase()}}Theme'))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is {{project_name.pascalCase()}}{{name.pascalCase()}}Theme &&
            const DeepCollectionEquality()
                .equals(backgroundColor, other.backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(backgroundColor),
    );
  }
}

extension {{project_name.pascalCase()}}{{name.pascalCase()}}ThemeBuildContext on BuildContext {
  {{project_name.pascalCase()}}{{name.pascalCase()}}Theme get {{project_name.camelCase()}}{{name.pascalCase()}}Theme =>
      Theme.of(this).extension<{{project_name.pascalCase()}}{{name.pascalCase()}}Theme>()!;
}

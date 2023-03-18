// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of '{{name.snakeCase()}}_theme.dart';

// **************************************************************************
// ThemeTailorGenerator
// **************************************************************************

class {{project_name.pascalCase()}}{{name.pascalCase()}}Theme extends ThemeExtension<{{project_name.pascalCase()}}{{name.pascalCase()}}Theme> {
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
      ThemeExtension<{{project_name.pascalCase()}}{{name.pascalCase()}}Theme>? other, double t) {
    if (other is! {{project_name.pascalCase()}}{{name.pascalCase()}}Theme) return this;
    return {{project_name.pascalCase()}}{{name.pascalCase()}}Theme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
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
        runtimeType, const DeepCollectionEquality().hash(backgroundColor));
  }
}

extension {{project_name.pascalCase()}}{{name.pascalCase()}}ThemeBuildContextProps on BuildContext {
  {{project_name.pascalCase()}}{{name.pascalCase()}}Theme get _testOp{{name.pascalCase()}}Theme =>
      Theme.of(this).extension<{{project_name.pascalCase()}}{{name.pascalCase()}}Theme>()!;
  Color get backgroundColor => _testOp{{name.pascalCase()}}Theme.backgroundColor;
}

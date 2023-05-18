part of '{{name.snakeCase()}}_cubit.dart';

@freezed
sealed class {{name.pascalCase()}}State with _${{name.pascalCase()}}State {
  const factory {{name.pascalCase()}}State.initial() = {{name.pascalCase()}}Initial;
}

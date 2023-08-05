part of '{{name.snakeCase()}}_bloc.dart';

@freezed
sealed class {{name.pascalCase()}}Event with _${{name.pascalCase()}}Event {
  const factory {{name.pascalCase()}}Event.started() = {{name.pascalCase()}}Started;
}

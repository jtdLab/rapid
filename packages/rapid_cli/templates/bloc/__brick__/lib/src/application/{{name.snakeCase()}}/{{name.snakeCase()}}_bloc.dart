import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name}}_di/{{project_name}}_di.dart';

part '{{name.snakeCase()}}_bloc.freezed.dart';
part '{{name.snakeCase()}}_event.dart';
part '{{name.snakeCase()}}_state.dart';

@{{platform}}
@injectable
class {{name.pascalCase()}}Bloc extends Bloc<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
  {{name.pascalCase()}}Bloc()
      : super(
          // Set initial state
          const {{name.pascalCase()}}State.initial(),
        ) {
    // Register handlers
    on<_Started>(
      (event, emit) async => _handleStarted(event, emit),
    );
  }

  /// Handle incoming [_Started] event.
  void _handleStarted(
    _Started event,
    Emitter<{{name.pascalCase()}}State> emit,
  ) {
    // TODO: implement
    throw UnimplementedError();
  }
}

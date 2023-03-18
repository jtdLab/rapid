import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:{{project_name}}_di/{{project_name}}_di.dart';

part '{{name.snakeCase()}}_cubit.freezed.dart';
part '{{name.snakeCase()}}_state.dart';

@{{platform}}
@injectable
class {{name.pascalCase()}}Cubit extends Cubit<{{name.pascalCase()}}State> {
  {{name.pascalCase()}}Cubit()
      : super(
          // Set initial state
          const {{name.pascalCase()}}State.initial(),
        );

  void started() {
    // TODO: implement
    throw UnimplementedError();
  }
}

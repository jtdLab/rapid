import 'package:bloc/bloc.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';

class {{project_name.pascalCase()}}BlocObserver extends BlocObserver {
  {{project_name.pascalCase()}}BlocObserver(this.logger);

  final {{project_name.pascalCase()}}Logger logger;

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    logger.debug('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.debug(
      'onEvent -- ${bloc.runtimeType}\n'
      '\n'
      '$event',
    );
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.debug(
      'onChange -- ${bloc.runtimeType}\n'
      '\n'
      'currentState: ${change.currentState}\n'
      'nextState: ${change.nextState}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.debug(
      'onError -- ${bloc.runtimeType}\n'
      '\n'
      '$error',
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    logger.debug('onClose -- ${bloc.runtimeType}');
  }
}

import 'package:bloc/bloc.dart';
import 'package:project_none_logging/project_none_logging.dart';

class ProjectNoneBlocObserver extends BlocObserver {
  final ProjectNoneLogger logger;

  ProjectNoneBlocObserver(this.logger);

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    logger.debug('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.debug(
      'onEvent -- ${bloc.runtimeType}\n'
      '\n'
      '$event',
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.debug(
      'onChange -- ${bloc.runtimeType}\n'
      '\n'
      'currentState: ${change.currentState}\n'
      'nextState: ${change.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.debug(
      'onError -- ${bloc.runtimeType}\n'
      '\n'
      '$error',
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    logger.debug('onClose -- ${bloc.runtimeType}');
  }
}

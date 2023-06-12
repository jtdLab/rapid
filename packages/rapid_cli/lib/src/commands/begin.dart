part of 'runner.dart';

mixin _BeginMixin on _Rapid {
  Future<void> begin() async {
    logger.command('rapid begin');

    if (tool.loadGroup().isActive) {
      _logAndThrow(RapidBeginException._activeGroup());
    }

    tool.activateCommandGroup();

    logger.newLine();
    logger.success('Success $checkLabel');
  }
}

class RapidBeginException extends RapidException {
  RapidBeginException._(super.message);

  factory RapidBeginException._activeGroup() {
    return RapidBeginException._(
      'There is already an active group. '
      'Call "rapid end" to complete it.',
    );
  }

  @override
  String toString() {
    return 'RapidBeginException: $message';
  }
}

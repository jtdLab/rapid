part of 'runner.dart';

mixin _BeginMixin on _Rapid {
  Future<void> begin() async {
    logger.command('rapid begin');

    final dotRapidTool = p.join('.rapid_tool');

    final rapidGroupActive = File(p.join(dotRapidTool, 'group-active'));

    final rapidNeedBootstrap = File(p.join(dotRapidTool, 'need-bootstrap'));

    final rapidNeedCodeGen = File(p.join(dotRapidTool, 'need-code-gen'));

    if (!rapidGroupActive.existsSync()) {
      rapidGroupActive.createSync(recursive: true);
    }

    if (!rapidNeedBootstrap.existsSync()) {
      rapidNeedBootstrap.createSync(recursive: true);
    }

    if (!rapidNeedCodeGen.existsSync()) {
      rapidNeedCodeGen.createSync(recursive: true);
    }

    final groupActive = rapidGroupActive.readAsStringSync() == 'true';
    if (groupActive) {
      _logAndThrow(
        RapidBeginException._activeGroup(),
      );
    }

    rapidGroupActive.writeAsStringSync('true');

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

part of 'runner.dart';

mixin _EndMixin on _Rapid {
  Future<void> end() async {
    logger.command('rapid end');

    final dotRapidTool = '.rapid_tool';

    final rapidGroupActive = File(p.join(dotRapidTool, 'group-active'));

    final rapidNeedBootstrap = File(p.join(dotRapidTool, 'need-bootstrap'));

    final rapidNeedCodeGen = File(p.join(dotRapidTool, 'need-code-gen'));

    if (!rapidGroupActive.existsSync() ||
        !rapidNeedBootstrap.existsSync() ||
        !rapidNeedCodeGen.existsSync()) {
      _logAndThrow(
        RapidEndException._noActiveGroup(),
      );
    }

    final groupActive = rapidGroupActive.readAsStringSync() == 'true';
    if (!groupActive) {
      _logAndThrow(
        RapidEndException._noActiveGroup(),
      );
    }

    // TODO uncomment
/*     final packagesToBootstrap =
        rapidNeedBootstrap.readAsStringSync().split(',').toSet().toList();
    await melosBootstrap(cwd: '.', scope: packagesToBootstrap);

    final packagesToCodeGen =
        rapidNeedCodeGen.readAsStringSync().split(',').toSet().toList();
    for (final packageToCodeGen in packagesToCodeGen) {
      await flutterPubGet(packageToCodeGen);
      await flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        packageToCodeGen,
      );
    } */

    rapidGroupActive.writeAsStringSync('false');
    rapidNeedBootstrap.writeAsStringSync('');
    rapidNeedCodeGen.writeAsStringSync('');

    logger.newLine();
    logger.success('Success $checkLabel');
  }
}

class RapidEndException extends RapidException {
  RapidEndException._(super.message);

  factory RapidEndException._noActiveGroup() {
    return RapidEndException._(
      'There is no active group. '
      'Did you call "rapid begin" before?',
    );
  }

  @override
  String toString() {
    return 'RapidEndException: $message';
  }
}

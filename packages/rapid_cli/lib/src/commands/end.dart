part of 'runner.dart';

mixin _EndMixin on _Rapid {
  Future<void> end() async {
    logger.command('rapid end');

    if (!tool.loadGroup().isActive) {
      _logAndThrow(RapidEndException._noActiveGroup());
    }

    tool.deactivateCommandGroup();

    final group = tool.loadGroup();

    if (group.packagesToBootstrap.isNotEmpty) {
      await bootstrap(packages: group.packagesToBootstrap);
    }
    if (group.packagesToCodeGen.isNotEmpty) {
      await codeGen(packages: group.packagesToCodeGen);
    }

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

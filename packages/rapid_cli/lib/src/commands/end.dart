part of 'runner.dart';

mixin _EndMixin on _Rapid {
  Future<void> end() async {
    if (!tool.loadGroup().isActive) {
      throw NoActiveGroupException._();
    }

    tool.deactivateCommandGroup();

    final group = tool.loadGroup();
    if (group.packagesToBootstrap.isNotEmpty) {
      await melosBootstrapTask(scope: group.packagesToBootstrap);
    }

    if (group.packagesToCodeGen.isNotEmpty) {
      await codeGenTaskGroup(packages: group.packagesToCodeGen);
    }

    logger
      ..newLine()
      ..commandSuccess('Completed Command Group!');
  }
}

class NoActiveGroupException extends RapidException {
  NoActiveGroupException._()
      : super(
          'There is no active group. '
          'Did you call "rapid begin" before?',
        );
}

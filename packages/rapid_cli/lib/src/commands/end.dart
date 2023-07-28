part of 'runner.dart';

mixin _EndMixin on _Rapid {
  Future<void> end() async {
    final group = tool.loadGroup();
    if (!group.isActive) {
      throw NoActiveGroupException._();
    }

    logger.newLine();

    tool.deactivateCommandGroup();

    if (group.packagesToBootstrap.isNotEmpty) {
      await melosBootstrapTask(scope: group.packagesToBootstrap);
      logger.newLine();
    }

    if (group.packagesToCodeGen.isNotEmpty) {
      await flutterPubRunBuildRunnerBuildDeleteConflictingOutputsTaskGroup(
        packages: group.packagesToCodeGen,
      );
      logger.newLine();
    }

    logger.commandSuccess('Completed Command Group!');
  }
}

class NoActiveGroupException extends RapidException {
  NoActiveGroupException._()
      : super(
          'There is no active group. '
          'Did you call "rapid begin" before?',
        );
}

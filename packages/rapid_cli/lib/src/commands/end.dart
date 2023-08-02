part of 'runner.dart';

mixin _EndMixin on _Rapid {
  Future<void> end() async {
    final group = tool.loadGroup();
    if (!group.isActive) {
      throw NoActiveGroupException._();
    }

    logger.newLine();

    tool.deactivateCommandGroup();

    final packagesToBootstrap = group.packagesToBootstrap;
    if (packagesToBootstrap.isNotEmpty) {
      final scope = project
          .packages()
          .where((e) => packagesToBootstrap.contains(e.packageName))
          .toList();
      await melosBootstrapTask(scope: scope);
      logger.newLine();
    }

    final packagesToCodeGen = group.packagesToCodeGen;
    if (packagesToCodeGen.isNotEmpty) {
      final packages = project
          .packages()
          .where((e) => packagesToCodeGen.contains(e.packageName))
          .toList();
      await flutterPubRunBuildRunnerBuildDeleteConflictingOutputsTaskGroup(
        packages: packages,
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

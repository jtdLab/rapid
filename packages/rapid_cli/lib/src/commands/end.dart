part of 'runner.dart';

mixin _EndMixin on _Rapid {
  Future<void> end() async {
    if (!tool.loadGroup().isActive) {
      throw NoActiveGroupException._();
    }

    tool.deactivateCommandGroup();

    final group = tool.loadGroup();
    if (group.packagesToBootstrap.isNotEmpty) {
      await task(
        'Bootstrapping packages',
        () async => bootstrap(packages: group.packagesToBootstrap),
      );
    }
    if (group.packagesToCodeGen.isNotEmpty) {
      taskGroup(
        description: 'Running code generation',
        tasks: group.packagesToCodeGen
            .map(
              (package) => (
                package.packageName,
                () async => codeGen(package: package),
              ),
            )
            .toList(),
      );
    }

    logger
      ..newLine()
      ..commandSuccess('Completed Command Group!');
  }
}

class NoActiveGroupException extends RapidException {
  NoActiveGroupException._();

  @override
  String toString() {
    return 'There is no active group. '
        'Did you call "rapid begin" before?';
  }
}

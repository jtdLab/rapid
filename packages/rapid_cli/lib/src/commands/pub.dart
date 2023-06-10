part of 'runner.dart';

// TODO: throw exception on error

mixin _PubMixin on _Rapid {
  Future<void> pubAdd({
    required String packageName,
    required List<String> packages,
  }) async {
    logger
      ..command('rapid pub add')
      ..newLine();

    late DartPackage package;
    try {
      package =
          project.packages.firstWhere((e) => e.packageName() == packageName);
    } catch (_) {
      // TODO
      throw Error();
    }

    final localPackagesToAdd = packages
        .where((e) => !e.trim().startsWith('dev') && e.trim().endsWith(':'))
        .toList();
    final localDevPackagesToAdd = packages
        .where((e) => e.trim().startsWith('dev') && e.trim().endsWith(':'))
        .toList();
    final publicPackagesToAdd = packages
        .where((e) => !e.trim().startsWith('dev') && !e.trim().endsWith(':'))
        .toList();
    final publicDevPackagesToAdd = packages
        .where((e) => e.trim().startsWith('dev') && !e.trim().endsWith(':'))
        .toList();

    if (publicPackagesToAdd.isNotEmpty) {
      await flutterPubAdd(
        package,
        dependenciesToAdd: publicPackagesToAdd,
      );
    }
    if (publicDevPackagesToAdd.isNotEmpty) {
      await flutterPubAdd(
        package,
        dependenciesToAdd: publicDevPackagesToAdd,
      );
    }

    for (final localPackage in localPackagesToAdd) {
      final name = localPackage.trim().split(':').first;
      package.pubspecFile.setDependency(name);
    }
    for (final localDevPackage in localDevPackagesToAdd) {
      final name = localDevPackage.trim().split(':')[1];
      package.pubspecFile.setDependency(name, dev: true);
    }

    final dependingPackages =
        project.packages.where((e) => e.pubspecFile.hasDependency(packageName));

    await bootstrap(
      packages: [
        package,
        ...dependingPackages,
      ],
    );

    logger
      ..newLine()
      ..success('Success $checkLabel');
  }

  Future<void> pubGet({
    required String packageName,
  }) async {
    logger
      ..command('rapid pub get')
      ..newLine();

    late DartPackage package;
    try {
      package =
          project.packages.firstWhere((e) => e.packageName() == packageName);
    } catch (_) {
      // TODO
      throw Error();
    }

    List<DartPackage> packagesToBootstrap(List<DartPackage> initial) {
      final remaining = project.packages
        ..removeWhere((e) =>
            initial.map((e) => e.packageName()).contains(e.packageName()));

      final newPkgs = remaining
          .where(
            (rem) => initial.any(
              (i) => rem.pubspecFile.hasDependency(i.packageName()),
            ),
          )
          .toList();

      if (newPkgs.isEmpty) {
        return initial;
      } else {
        return packagesToBootstrap(
          initial + newPkgs,
        );
      }
    }

    final result = await flutterPubGetDryRun(package);
    if (result.wouldChangeDependencies) {
      await bootstrap(
        packages: packagesToBootstrap(
          project.packages
              .where((e) => e.pubspecFile.hasDependency(package.packageName()))
              .toList(),
        ),
      );
    }

    logger
      ..newLine()
      ..success('Success $checkLabel');
  }

  Future<void> pubRemove({
    required String packageName,
    required List<String> packages,
  }) async {
    logger
      ..command('rapid pub remove')
      ..newLine();

    late DartPackage package;
    try {
      package =
          project.packages.firstWhere((e) => e.packageName() == packageName);
    } catch (_) {
      // TODO
      throw Error();
    }

    await flutterPubRemove(package, packagesToRemove: packages);

    final dependingPackages =
        project.packages.where((e) => e.pubspecFile.hasDependency(packageName));

    await bootstrap(
      packages: [
        package,
        ...dependingPackages,
      ],
    );

    logger
      ..newLine()
      ..success('Success $checkLabel');
  }
}

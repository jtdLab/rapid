part of 'runner.dart';

// TODO: throw exception on error

mixin _PubMixin on _Rapid {
  Future<void> pubAdd({
    required String? packageName,
    required List<String> packages,
  }) async {
    logger.newLine();

    final package = _findCurrentPackage(packageName);

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
        package: package,
        dependenciesToAdd: publicPackagesToAdd,
      );
    }
    if (publicDevPackagesToAdd.isNotEmpty) {
      await flutterPubAdd(
        package: package,
        dependenciesToAdd: publicDevPackagesToAdd,
      );
    }

    for (final localPackage in localPackagesToAdd) {
      final name = localPackage.trim().split(':').first;
      package.pubSpecFile.setDependency(
        updatedDependency:
            MapEntry(name, HostedReference(VersionConstraint.empty)),
      );
    }
    for (final localDevPackage in localDevPackagesToAdd) {
      final name = localDevPackage.trim().split(':')[1];
      package.pubSpecFile.setDependency(
        updatedDependency:
            MapEntry(name, HostedReference(VersionConstraint.empty)),
        dev: true,
      );
    }

    final dependingPackages = project
        .packages()
        .where((e) => e.pubSpecFile.hasDependency(name: package.packageName));

    await bootstrap(
      packages: [
        package,
        ...dependingPackages,
      ],
    );

    logger
      ..newLine()
      ..commandSuccess('Added Dependencies!');
  }

  Future<void> pubGet({
    required String? packageName,
  }) async {
    logger.newLine();

    final package = _findCurrentPackage(packageName);

    List<DartPackage> packagesToBootstrap(List<DartPackage> initial) {
      final remaining = project.packages()
        ..removeWhere(
            (e) => initial.map((e) => e.packageName).contains(e.packageName));

      final newPkgs = remaining
          .where(
            (rem) => initial.any(
              (i) => rem.pubSpecFile.hasDependency(name: i.packageName),
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

    final result = await flutterPubGet(package: package, dryRun: true);
    if (result.wouldChangeDependencies) {
      await bootstrap(
        packages: packagesToBootstrap(
          project
              .packages()
              .where(
                (e) => e.pubSpecFile.hasDependency(name: package.packageName),
              )
              .toList(),
        ),
      );
    }

    logger
      ..newLine()
      ..commandSuccess('Got Dependencies!');
  }

  Future<void> pubRemove({
    required String? packageName,
    required List<String> packages,
  }) async {
    logger.newLine();

    final package = _findCurrentPackage(packageName);

    await flutterPubRemove(package: package, packagesToRemove: packages);

    final dependingPackages = project
        .packages()
        .where((e) => e.pubSpecFile.hasDependency(name: package.packageName));

    await bootstrap(
      packages: [
        package,
        ...dependingPackages,
      ],
    );

    logger
      ..newLine()
      ..commandSuccess('Removed Dependencies!');
  }

  DartPackage _findCurrentPackage(String? packageName) {
    if (packageName != null) {
      try {
        return project.findByPackageName(packageName);
      } catch (_) {
        throw Error(); // TODO
      }
    } else {
      try {
        return project.findByCwd();
      } catch (_) {
        throw Error(); // TODO
      }
    }
  }
}

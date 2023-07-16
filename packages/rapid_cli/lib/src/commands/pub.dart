part of 'runner.dart';

mixin _PubMixin on _Rapid {
  Future<void> pubAdd({
    required String? packageName,
    required List<String> packages,
  }) async {
    logger.newLine();

    final package = _findCurrentPackage(packageName);

    // These packages can be handles by `dart pub add` directly
    final packagesWithNonEmptyConstraint =
        packages.map((e) => e.trim()).where((e) => !e.endsWith(':')).toList();
    if (packagesWithNonEmptyConstraint.isNotEmpty) {
      await flutterPubAddTask(
        package: package,
        dependenciesToAdd: packagesWithNonEmptyConstraint,
      );
    }

    // These packages must be handled manually
    final packagesWithEmptyConstraint =
        packages.map((e) => e.trim()).where((e) => e.endsWith(':')).toList();
    for (final packageWithEmptyConstraint in packagesWithEmptyConstraint) {
      final dev = packageWithEmptyConstraint.startsWith('dev');
      package.pubSpecFile.setDependency(
        name: dev
            ? packageWithEmptyConstraint.split(':')[1]
            : packageWithEmptyConstraint.split(':').first,
        dependency: HostedReference(VersionConstraint.empty),
        dev: dev,
      );
    }

    await melosBootstrapTask(scope: project.dependentPackages(package));

    logger
      ..newLine()
      ..commandSuccess('Added Dependencies!');
  }

  Future<void> pubGet({
    required String? packageName,
  }) async {
    logger.newLine();

    final package = _findCurrentPackage(packageName);

    final result = await flutterPubGet(package: package, dryRun: true);
    if (result.wouldChangeDependencies) {
      await melosBootstrapTask(scope: project.dependentPackages(package));
      logger.newLine();
    }

    logger.commandSuccess('Got Dependencies!');
  }

  Future<void> pubRemove({
    required String? packageName,
    required List<String> packages,
  }) async {
    logger.newLine();

    final package = _findCurrentPackage(packageName);

    await flutterPubRemoveTask(package: package, packagesToRemove: packages);

    await melosBootstrapTask(scope: project.dependentPackages(package));

    logger
      ..newLine()
      ..commandSuccess('Removed Dependencies!');
  }

  DartPackage _findCurrentPackage(String? packageName) {
    if (packageName != null) {
      try {
        return project.findByPackageName(packageName);
      } catch (_) {
        throw PackageNotFoundException._(packageName);
      }
    } else {
      try {
        return project.findByCwd();
      } catch (_) {
        throw PackageAtCwdNotFoundException._(Directory.current.path);
      }
    }
  }
}

class PackageNotFoundException extends RapidException {
  PackageNotFoundException._(String packageName)
      : super(
          'Could not find a dart package with $packageName that is part of a Rapid project.',
        );
}

class PackageAtCwdNotFoundException extends RapidException {
  PackageAtCwdNotFoundException._(String cwdPath)
      : super(
          'Could not find a dart package at $cwdPath that is part of a Rapid project.',
        );
}

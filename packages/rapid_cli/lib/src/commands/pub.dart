part of 'runner.dart';

mixin _PubMixin on _Rapid {
  Future<void> pubAdd({
    required String? packageName,
    required List<String> packages,
  }) async {
    logger.newLine();

    final package = _findCurrentPackage(packageName);

    // TODO cleaner
    final publicPackagesToAdd =
        packages.map((e) => e.trim()).where((e) => !e.endsWith(':')).toList();
    final localPackagesToAdd =
        packages.map((e) => e.trim()).where((e) => e.endsWith(':')).toList();

    if (publicPackagesToAdd.isNotEmpty) {
      await flutterPubAdd(
        package: package,
        dependenciesToAdd: publicPackagesToAdd,
      );
    }

    for (final localPackage in localPackagesToAdd) {
      final dev = localPackage.startsWith('dev');

      package.pubSpecFile.setDependency(
        name: dev
            ? localPackage.trim().split(':')[1]
            : localPackage.trim().split(':').first,
        dependency: HostedReference(VersionConstraint.empty),
        dev: dev,
      );
    }

    await bootstrap(
      packages: [
        package,
        ...project.dependentPackages(package),
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

    final result = await flutterPubGet(package: package, dryRun: true);
    if (result.wouldChangeDependencies) {
      await bootstrap(
        packages: project.dependentPackages(package),
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

    await bootstrap(
      packages: [
        package,
        ...project.dependentPackages(package),
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
  PackageNotFoundException._(this.packageName);

  final String packageName;

  @override
  String toString() {
    return 'Could not find a dart package with $packageName that is part of a Rapid project.';
  }
}

class PackageAtCwdNotFoundException extends RapidException {
  PackageAtCwdNotFoundException._(this.cwdPath);

  final String cwdPath;

  @override
  String toString() {
    return 'Could not find a dart package at $cwdPath that is part of a Rapid project.';
  }
}

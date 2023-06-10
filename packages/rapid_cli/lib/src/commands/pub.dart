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

    throw UnimplementedError();
    /*   // TODO check pubspec exists

    if (packageName == null) {
      final pubspec = PubspecFile();
      try {
        packageName = pubspec.readName();
      } catch (e) {
        throw UsageException(
          'This command must either be called from within a package or with a explicit package via the "package" argument.',
          usage,
        );
      }
    }
    final projectPackages = <DartPackage>[
      project.diPackage,
      ...project.domainDirectory.domainPackages(),
      ...project.infrastructureDirectory.infrastructurePackages(),
      project.loggingPackage,
      project.uiPackage,
      for (final platform in Platform.values
          .where((platform) => project.platformIsActivated(platform))) ...[
        project.platformDirectory(platform: platform).rootPackage,
        project.platformDirectory(platform: platform).navigationPackage,
        ...project
            .platformDirectory(platform: platform)
            .featuresDirectory
            .featurePackages(),
        project.platformUiPackage(platform: platform),
      ],
    ];
    // TODO good
    if (!projectPackages.map((e) => e.packageName()).contains(packageName)) {
      // TODO
      throw RapidException();
      //throw RapidException('Package $packageName not found.');
    }

    final unparsedPackages = _packages;

    logger.commandTitle('Adding Dependencies to "$packageName" ...');

    final localPackagesToAdd = unparsedPackages
        .where((e) => !e.trim().startsWith('dev') && e.trim().endsWith(':'))
        .toList();
    final localDevPackagesToAdd = unparsedPackages
        .where((e) => e.trim().startsWith('dev') && e.trim().endsWith(':'))
        .toList();
    final publicPackagesToAdd = unparsedPackages
        .where((e) => !e.trim().startsWith('dev') && !e.trim().endsWith(':'))
        .toList();
    final publicDevPackagesToAdd = unparsedPackages
        .where((e) => e.trim().startsWith('dev') && !e.trim().endsWith(':'))
        .toList();

    final package =
        projectPackages.firstWhere((e) => e.packageName() == packageName);
    if (publicPackagesToAdd.isNotEmpty) {
      await flutterPubAdd(
        cwd: package.path,
        packages: publicPackagesToAdd,
      );
    }
    if (publicDevPackagesToAdd.isNotEmpty) {
      await flutterPubAdd(
        cwd: package.path,
        packages: publicDevPackagesToAdd,
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
        projectPackages.where((e) => e.pubspecFile.hasDependency(packageName!));

    await bootstrap(
      packages: [
        package,
        ...dependingPackages,
      ],
    );

    logger.commandSuccess(
      'Added ${unparsedPackages.length == 1 ? unparsedPackages.first : unparsedPackages.join(', ')} to $packageName!',
    );

    return ExitCode.success.code; */
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

    throw UnimplementedError();
    /*  // TODO check pubspec exists

    if (packageName == null) {
      final pubspec = PubspecFile();
      try {
        packageName = pubspec.readName();
      } catch (e) {
        throw UsageException(
          'This command must either be called from within a package or with a explicit package via the "package" argument.',
          usage,
        );
      }
    }
    final packages = _packages;
    final projectPackages = <DartPackage>[
      project.diPackage,
      ...project.domainDirectory.domainPackages(),
      ...project.infrastructureDirectory.infrastructurePackages(),
      project.loggingPackage,
      project.uiPackage,
      for (final platform in Platform.values
          .where((platform) => project.platformIsActivated(platform))) ...[
        project.platformDirectory(platform: platform).rootPackage,
        project.platformDirectory(platform: platform).navigationPackage,
        ...project
            .platformDirectory(platform: platform)
            .featuresDirectory
            .featurePackages(),
        project.platformUiPackage(platform: platform),
      ],
    ];

    // TODO good ?
    if (!projectPackages.map((e) => e.packageName()).contains(packageName)) {
      // TODO
      throw RapidException();
      // throw RapidException('Package $packageName not found.');
    }

    logger.commandTitle('Removing Dependencies from "$packageName" ...');

    final package =
        projectPackages.firstWhere((e) => e.packageName() == packageName);

    await flutterPubRemove(
      cwd: package.path,
      packages: packages,
    );

    final dependingPackages =
        projectPackages.where((e) => e.pubspecFile.hasDependency(packageName!));

    await bootstrap(
      packages: [
        package,
        ...dependingPackages,
      ],
    );

    logger.commandSuccess('Removed ${packages.join(', ')} from $packageName!');

    return ExitCode.success.code; */
  }
}

import 'dart:io';

import 'package:bundles/src/common.dart';
import 'package:bundles/src/io.dart';
import 'package:path/path.dart' as p;

final RegExp _dartRegex = RegExp(r'( +)sdk: ">=\d+\.\d+\.\d+\s<\d+\.\d+\.\d+"');
final RegExp _flutterRegex = RegExp(r'( +)flutter: ">=\d+\.\d+\.\d+"');
RegExp _packageRegex(String name) =>
    RegExp(r'( +)' '$name' r': \^\d+\.\d+\.\d+');

Future<void> updatePackageTemplates() async {
  print('Updating package templates...');
  await _updatePubspecYamlFiles();
  await _updatePubspecOverridesFiles();
}

Future<void> _updatePubspecYamlFiles() async {
  for (final template in templates.whereType<PackageTemplate>()) {
    final pubspecFile = File(p.join(template.path, '__brick__/pubspec.yaml'));
    var content = pubspecFile.readAsStringSync();
    // TODO reuse this
    content = content.replaceAllMapped(
      _dartRegex,
      (match) {
        final spaces = match[1]!;
        return '$spaces${dart.toYaml()}';
      },
    );
    content = content.replaceAllMapped(
      _flutterRegex,
      (match) {
        final spaces = match[1]!;
        return '$spaces${flutter.toYaml()}';
      },
    );
    for (final package in packages) {
      content = content.replaceAllMapped(
        _packageRegex(package.name),
        (match) {
          final spaces = match[1]!;
          return '$spaces${package.toYaml()}';
        },
      );
    }

    pubspecFile.writeAsStringSync(content);
  }
}

Future<void> _updatePubspecOverridesFiles() async {
  const projectName = 'xlx';
  const featName = 'home_page';
  final tempDir = getTempDir();

  await _generateRapidLikeProject(
    projectName: projectName,
    featName: featName,
    dir: tempDir,
  );
  await _applyPlaceholders(
    projectName: projectName,
    featName: featName,
    dir: tempDir,
  );
  await _updatePackageTemplates(
    projectName: projectName,
    featName: featName,
    dir: tempDir,
  );
}

Future<void> _generateRapidLikeProject({
  required String projectName,
  required String featName,
  required Directory dir,
}) async {
  await run(
    'mason',
    ['get'],
    workingDirectory: 'templates',
  );

  for (final platform in platforms) {
    await platformUiPackage.masonMake(projectName, dir, platform: platform);
    await platformRootPackage.masonMake(projectName, dir, platform: platform);
    await platformNavigationPackage.masonMake(
      projectName,
      dir,
      platform: platform,
    );
    await platformAppFeaturePackage.masonMake(
      projectName,
      dir,
      platform: platform,
    );
    await platformFeaturePackage.masonMake(
      projectName,
      dir,
      platform: platform,
      name: featName,
    );
  }
  await uiPackage.masonMake(projectName, dir);
  await diPackage.masonMake(projectName, dir);
  await loggingPackage.masonMake(projectName, dir);
  await domainPackage.masonMake(projectName, dir);
  await infrastructurePackage.masonMake(projectName, dir);

  final melosFile = File(p.join(dir.path, 'melos.yaml'));
  melosFile.createSync(recursive: true);
  melosFile.writeAsStringSync('''
name: $projectName

packages:
  - packages/**

command:
  bootstrap:
    # https://github.com/dart-lang/pub/issues/3404)
    runPubGetInParallel: false

ide:
  intellij: false''');
  final pubspecFile = File(p.join(dir.path, 'pubspec.yaml'));
  pubspecFile.createSync(recursive: true);
  pubspecFile.writeAsStringSync('''
name: rapid_workspace

environment:
  ${dart.toYaml()}
  
dev_dependencies:
  ${packages.firstWhere((e) => e.name == 'melos').toYaml()}''');

  final files = dir.listSync(recursive: true);
  for (final file in files) {
    final fileName = p.basename(file.path);
    if (fileName == 'pubspec_overrides.yaml') {
      file.deleteSync(recursive: true);
    }
  }

  final pubGetResult =
      await run('flutter', ['pub', 'get'], workingDirectory: dir.path);
  print(pubGetResult.stdout);
  print(pubGetResult.stderr);
  final melosResult =
      await run('melos', ['bootstrap'], workingDirectory: dir.path);
  print(melosResult.stdout);
  print(melosResult.stderr);
}

Future<void> _applyPlaceholders({
  required String projectName,
  required String featName,
  required Directory dir,
}) async {
  final pubspecOverridesYamlFiles = [
    for (final platform in platforms) ...[
      platformUiPackage.outputPath(projectName, platform: platform),
      platformRootPackage.outputPath(projectName, platform: platform),
      platformNavigationPackage.outputPath(projectName, platform: platform),
      platformAppFeaturePackage.outputPath(projectName, platform: platform),
      platformFeaturePackage.outputPath(
        projectName,
        platform: platform,
        name: featName,
      ),
    ],
    uiPackage.outputPath(projectName),
    diPackage.outputPath(projectName),
    loggingPackage.outputPath(projectName),
    domainPackage.outputPath(projectName),
    infrastructurePackage.outputPath(projectName),
  ]
      .map((e) => File(p.join(dir.path, e, 'pubspec_overrides.yaml')))
      .toList()
      .where((e) => e.existsSync());

  for (final file in pubspecOverridesYamlFiles) {
    var content = file.readAsStringSync();
    content = content.replaceAll(projectName, '{{project_name}}');
    // exclude platfrom root package
    if (!platforms
        .map(
          (platform) => p.dirname(file.path).endsWith(
                platformRootPackage.outputPath(projectName, platform: platform),
              ),
        )
        .any((e) => e)) {
      content = content.replaceAll(featName, '{{name}}');
    }

    file.writeAsStringSync(content);
  }
}

// TODO this method can be simplified
Future<void> _updatePackageTemplates({
  required String projectName,
  required String featName,
  required Directory dir,
}) async {
  final plaformNamedPackageTemplates =
      templates.whereType<PlatformNamedPackageTemplate>();

  for (final template in plaformNamedPackageTemplates) {
    for (var i = 0; i < platforms.length; i++) {
      final platform = platforms[i];
      final srcPubspecOverridesYamlFile = File(
        p.join(
          dir.path,
          template.outputPath(projectName, platform: platform, name: featName),
          'pubspec_overrides.yaml',
        ),
      );
      final pubspecOverridesYamlFile = File(
        p.join(template.path, '__brick__', 'pubspec_overrides.yaml'),
      );

      if (i == 0) {
        if (srcPubspecOverridesYamlFile.existsSync()) {
          pubspecOverridesYamlFile.writeAsStringSync('');
        }
      }

      if (srcPubspecOverridesYamlFile.existsSync()) {
        pubspecOverridesYamlFile.writeAsStringSync(
          '{{#$platform}}${srcPubspecOverridesYamlFile.readAsStringSync()}{{/$platform}}',
          mode: FileMode.append,
        );
      }
    }
  }

  final plaformPackageTemplates =
      templates.whereType<PlatformPackageTemplate>();

  for (final template in plaformPackageTemplates) {
    for (var i = 0; i < platforms.length; i++) {
      final platform = platforms[i];
      final srcPubspecOverridesYamlFile = File(
        p.join(
          dir.path,
          template.outputPath(projectName, platform: platform),
          'pubspec_overrides.yaml',
        ),
      );
      final pubspecOverridesYamlFile = File(
        p.join(template.path, '__brick__', 'pubspec_overrides.yaml'),
      );

      if (i == 0) {
        if (srcPubspecOverridesYamlFile.existsSync()) {
          pubspecOverridesYamlFile.writeAsStringSync('');
        }
      }

      if (srcPubspecOverridesYamlFile.existsSync()) {
        pubspecOverridesYamlFile.writeAsStringSync(
          '{{#$platform}}${srcPubspecOverridesYamlFile.readAsStringSync()}{{/$platform}}',
          mode: FileMode.append,
        );
      }
    }
  }

  final packageTemplates = templates.whereType<PackageTemplate>().where((e) =>
      !plaformPackageTemplates.contains(e) &&
      !plaformNamedPackageTemplates.contains(e));

  for (final template in packageTemplates) {
    final srcPubspecOverridesYamlFile = File(
      p.join(
        dir.path,
        template.outputPath(projectName),
        'pubspec_overrides.yaml',
      ),
    );
    final pubspecOverridesYamlFile = File(
      p.join(template.path, '__brick__', 'pubspec_overrides.yaml'),
    );

    if (srcPubspecOverridesYamlFile.existsSync()) {
      pubspecOverridesYamlFile.writeAsStringSync(
        srcPubspecOverridesYamlFile.readAsStringSync(),
      );
    }
  }
}

extension on PackageTemplate {
  String outputPath(String projectName) {
    switch (name) {
      case 'di_package':
        return 'packages/$projectName/${projectName}_di';
      case 'domain_package':
        return 'packages/$projectName/${projectName}_domain/${projectName}_domain';
      case 'infrastructure_package':
        return 'packages/$projectName/${projectName}_infrastructure/${projectName}_infrastructure';
      case 'logging_package':
        return 'packages/$projectName/${projectName}_logging';
      case 'project':
        return '';
      case 'ui_package':
        return 'packages/${projectName}_ui/${projectName}_ui';

      default:
        throw Exception('Could not find outputPath for $name');
    }
  }

  List<String> defaultArgs(String projectName) {
    final flags = [
      '--project_name',
      projectName,
    ];

    switch (name) {
      case 'di_package':
        return [
          ...flags,
        ];
      case 'domain_package':
        return [
          ...flags,
          '--has_name',
          'false',
          '--name',
          '""',
        ];
      case 'infrastructure_package':
        return [
          ...flags,
          '--has_name',
          'false',
          '--name',
          '""',
        ];
      case 'logging_package':
        return [
          ...flags,
        ];
      case 'ui_package':
        return [
          ...flags,
        ];

      default:
        throw Exception('Could not find defaultArgs for $name');
    }
  }

  Future<void> masonMake(String projectName, Directory dir) async {
    final result = await run(
      'mason',
      [
        'make',
        this.name,
        '--on-conflict overwrite',
        '-o',
        p.join(dir.path, outputPath(projectName)),
        ...defaultArgs(projectName),
      ],
      workingDirectory: 'templates',
    );

    if (exitCode != 0) {
      print(result.stderr);
    }
  }
}

extension on PlatformPackageTemplate {
  /// The path where the template would be generated in a real project.
  String outputPath(String projectName, {required String platform}) {
    switch (name) {
      case 'platform_app_feature_package':
        return 'packages/$projectName/${projectName}_$platform/${projectName}_${platform}_features/${projectName}_${platform}_app';
      case 'platform_navigation_package':
        return 'packages/${projectName}/${projectName}_${platform}/${projectName}_${platform}_navigation';
      case 'platform_root_package':
        return 'packages/${projectName}/${projectName}_${platform}/${projectName}_${platform}';
      case 'platform_ui_package':
        return 'packages/${projectName}_ui/${projectName}_ui_${platform}';

      default:
        throw Exception('Could not find outputPath for $name');
    }
  }

  List<String> defaultArgs(String projectName, {required String platform}) {
    final flags = [
      '--project_name',
      projectName,
      '--android',
      '${platform == 'android'}',
      '--ios',
      '${platform == 'ios'}',
      '--linux',
      '${platform == 'linux'}',
      '--macos',
      '${platform == 'macos'}',
      '--web',
      '${platform == 'web'}',
      '--windows',
      '${platform == 'windows'}',
      '--mobile',
      '${platform == 'mobile'}'
    ];

    switch (name) {
      case 'platform_app_feature_package':
        return [
          ...flags,
          '--example',
          'false',
          '--default_language',
          'de',
        ];
      case 'platform_navigation_package':
        return [
          ...flags,
        ];
      case 'platform_root_package':
        return [
          ...flags,
          '--description',
          'swag',
        ];
      case 'platform_ui_package':
        return [
          ...flags,
          '--example',
          'false',
        ];

      default:
        throw Exception('Could not find defaultArgs for $name');
    }
  }

  Future<void> masonMake(
    String projectName,
    Directory dir, {
    required String platform,
  }) async {
    final result = await run(
      'mason',
      [
        'make',
        this.name,
        '--on-conflict overwrite',
        '-o',
        p.join(dir.path, outputPath(projectName, platform: platform)),
        ...defaultArgs(projectName, platform: platform),
      ],
      workingDirectory: 'templates',
    );

    if (exitCode != 0) {
      print(result.stderr);
    }
  }
}

extension on PlatformNamedPackageTemplate {
  /// The path where the template would be generated in a real project.
  String outputPath(
    String projectName, {
    required String platform,
    required String name,
  }) {
    switch (this.name) {
      case 'platform_feature_package':
        return 'packages/$projectName/${projectName}_$platform/${projectName}_${platform}_features/${projectName}_${platform}_$name';

      default:
        throw Exception('Could not find outputPath for ${this.name}');
    }
  }

  List<String> defaultArgs(
    String projectName, {
    required String platform,
    required String name,
  }) {
    final flags = [
      '--project_name',
      projectName,
      '--android',
      '${platform == 'android'}',
      '--ios',
      '${platform == 'ios'}',
      '--linux',
      '${platform == 'linux'}',
      '--macos',
      '${platform == 'macos'}',
      '--web',
      '${platform == 'web'}',
      '--windows',
      '${platform == 'windows'}',
      '--mobile',
      '${platform == 'mobile'}'
    ];

    switch (this.name) {
      case 'platform_feature_package':
        return [
          ...flags,
          '--name',
          "$name",
          '--description',
          'swag',
          '--example',
          'false',
          '--default_language',
          'de',
          '--routable',
          'false',
          '--route_name',
          'none'
        ];

      default:
        throw Exception('Could not find defaultArgs for ${this.name}');
    }
  }

  Future<void> masonMake(
    String projectName,
    Directory dir, {
    required String platform,
    required String name,
  }) async {
    final result = await run(
      'mason',
      [
        'make',
        this.name,
        '--on-conflict overwrite',
        '-o',
        "${p.join(dir.path, outputPath(projectName, platform: platform, name: name))}",
        ...defaultArgs(projectName, platform: platform, name: name),
      ],
      workingDirectory: 'templates',
    );

    if (exitCode != 0) {
      print(result.stderr);
    }
  }
}

import 'dart:io';

import 'package:bundles/src/io.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import 'common.dart';

const _descriptionPlaceholder = 'XXDESCXX';
const _orgNamePlaceholder = 'xxx.xxx.xxx';
const _projectNamePlaceholder = 'xlx_xlx';

Future<void> updatePlatformNativeDirectoryTemplates() async {
  print('Updating PlatformNativeDirectory templates...');

  final tempDir = getTempDir('foo');
  await _generateFlutterProject(dir: tempDir);
  _applyPlaceholders(dir: tempDir);
  for (final platform in platforms.where((e) => e != 'mobile')) {
    _updatePlatformNativeDirectoryTemplate(dir: tempDir, platform: platform);
  }
}

Future<void> _generateFlutterProject({
  required Directory dir,
}) async {
  print('Generating Flutter project in ${dir.path}...');

  await run(
    'flutter',
    [
      'create',
      '${dir.path}',
      '--description',
      _descriptionPlaceholder,
      '--org',
      _orgNamePlaceholder,
      '--project-name',
      _projectNamePlaceholder,
      '--platforms',
      'android,ios,linux,macos,web,windows',
    ],
  );

  // remove generated files
  await run(
    'git',
    ['init'],
    workingDirectory: dir.path,
  );
  await run(
    'git',
    ['clean', '-dfX'],
    workingDirectory: dir.path,
  );
}

void _applyPlaceholders({
  required Directory dir,
}) {
  print('Applying placeholders...');

  // all files
  final placeholders = [
    (_descriptionPlaceholder, '{{description}}'),
    (_orgNamePlaceholder, '{{org_name}}'),
    (_projectNamePlaceholder, '{{project_name}}'),
    (_projectNamePlaceholder.pathCase, '{{project_name.pathCase()}}'),
    (_projectNamePlaceholder.titleCase, '{{project_name.titleCase()}}'),
    (_projectNamePlaceholder.pascalCase, '{{project_name.pascalCase()}}'),
    (_projectNamePlaceholder.camelCase, '{{project_name.camelCase()}}')
  ];
  final files =
      dir.listSync(recursive: true).whereType<File>().where((e) => !e.isBinary);
  for (final file in files) {
    var content = file.readAsStringSync();
    for (final placeholder in placeholders) {
      content = content.replaceAll(placeholder.$1, placeholder.$2);
    }
    file.writeAsStringSync(content);
  }

  // ios/Runner/Info.plist
  final infoPlistFile = File(p.join(dir.path, 'ios', 'Runner', 'Info.plist'));
  final lines = infoPlistFile.readAsLinesSync();
  lines.insert(4, '''
	<key>CFBundleLocalizations</key>
    <array>
{{#languages}}        <string>{{language_code}}{{#has_script_code}}-{{script_code}}{{/has_script_code}}{{#has_country_code}}-{{country_code}}{{/has_country_code}}</string>
{{/languages}}    </array>''');
  infoPlistFile.writeAsStringSync(lines.join('\n'));

  // android/app/src/main/kotlin
  final mainActivityKtFile = File(
    p.join(
      dir.path,
      'android/app/src/main/kotlin/${_orgNamePlaceholder.pathCase}/$_projectNamePlaceholder/MainActivity.kt',
    ),
  );
  final newMainActivityKtFile = File(
    p.join(
      dir.path,
      'android/app/src/main/kotlin/{{org_name.pathCase()}}/{{project_name}}/MainActivity.kt',
    ),
  );
  newMainActivityKtFile.createSync(recursive: true);
  mainActivityKtFile.renameSync(newMainActivityKtFile.path);
  Directory(
    p.join(
      dir.path,
      'android/app/src/main/kotlin/${_orgNamePlaceholder.split('.').first}',
    ),
  ).deleteSync(recursive: true);
}

void _updatePlatformNativeDirectoryTemplate({
  required Directory dir,
  required String platform,
}) {
  print('Updating ${platform}_native_directory templates...');

  final brickDir = Directory(
    'templates/platform_root_package/${platform}_native_directory/__brick__',
  );
  brickDir.deleteSync(recursive: true);
  brickDir.create();
  copyPathSync(p.join(dir.path, platform), brickDir.path);
  final gitignoreFile = File(p.join(dir.path, '${platform}/.gitignore'));
  if (gitignoreFile.existsSync()) {
    gitignoreFile.copySync(
      p.join(brickDir.path, '.gitignore'),
    );
  }

  // TODO: https://github.com/jtdLab/rapid/issues/96
  if (platform == 'macos') {
    for (final file in brickDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((e) => !e.isBinary)) {
      final content = file.readAsStringSync();
      file.writeAsStringSync(content
          .replaceAll('10.14.6', '10.14')
          .replaceAll('10.14', '10.14.6'));
    }

    final podFile = File(p.join(brickDir.path, 'Podfile'));
    if (podFile.existsSync()) {
      podFile.deleteSync(recursive: true);
    }
    podFile
      ..createSync(recursive: true)
      ..writeAsStringSync(_podFileContent);
  }
}

extension on File {
  bool get isBinary {
    final extension = p.extension(path);
    return extension == '.ico' || extension == '.png';
  }
}

const _podFileContent = '''
platform :osx, '10.14.6'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'ephemeral', 'Flutter-Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure \\"flutter pub get\\" is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Flutter-Generated.xcconfig, then run \\"flutter pub get\\""
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_macos_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_macos_pods File.dirname(File.realpath(__FILE__))
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_macos_build_settings(target)
  end
end
''';

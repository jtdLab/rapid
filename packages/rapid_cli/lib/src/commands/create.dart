part of 'runner.dart';

mixin _CreateMixin on _Rapid {
  Future<void> create({
    required String projectName,
    required String outputDir,
    required String description,
    required String orgName,
    required String language,
    required bool android,
    required bool ios,
    required bool linux,
    required bool macos,
    required bool mobile,
    required bool web,
    required bool windows,
  }) async {
    project = RapidProject(
      config: RapidProjectConfig(
        path: outputDir,
        name: projectName,
      ),
    );

    if (project.exists() && !project.isEmpty) {
      _logAndThrow(
        RapidCreateException._outputDirNotEmpty(outputDir),
      );
    }

    logger
      ..command('rapid create')
      ..newLine();

    await task(
      'Generating project files',
      () async => project.create(
        projectName: projectName,
        description: description,
        orgName: orgName,
        language: language,
        platforms: {
          if (android) Platform.android,
          if (ios) Platform.ios,
          if (linux) Platform.linux,
          if (macos) Platform.macos,
          if (web) Platform.web,
          if (windows) Platform.windows,
          if (mobile) Platform.mobile,
        },
      ),
    );

    // TODO show a hint if more than 2 platforms are selcted
    // Multiple platforms: This can take some time!

    await flutterPubGet([
      project,
      ...project.packages,
    ]);

    await flutterGenl10n(project.featurePackages);

    await dartFormatFix(project);

    if (android || mobile) {
      await flutterConfigEnableAndroid(project);
    }
    if (ios || mobile) {
      await flutterConfigEnableIos(project);
    }
    if (linux) {
      await flutterConfigEnableLinux(project);
    }
    if (macos) {
      await flutterConfigEnableMacos(project);
    }
    if (web) {
      await flutterConfigEnableWeb(project);
    }
    if (windows) {
      await flutterConfigEnableWindows(project);
    }

    // TODO: https://github.com/jtdLab/rapid/issues/96
    if (macos) {
      final rootPackage =
          project.platformDirectory(platform: Platform.macos).rootPackage;
      final macosDir = Directory(p.join(rootPackage.path, 'macos'));

      for (final file in macosDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((e) => !e.isBinary)) {
        final content = file.readAsStringSync();
        file.writeAsStringSync(
          content
              .replaceAll('10.14', '10.15.7.7')
              .replaceAll('10.14.6', '10.15.7.7'),
        );
      }

      final podFile = File(p.join(macosDir.path, 'Podfile'));
      podFile.writeAsStringSync(r'''
platform :osx, '10.15.7.7'

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
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure \"flutter pub get\" is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Flutter-Generated.xcconfig, then run \"flutter pub get\""
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
    target.build_configurations.each do |config|
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.15.7.7'
    end
  end
end''');
    }

    // TODO log better summary + refs to doc
    logger
      ..newLine()
      ..success('Success $checkLabel');
  }
}

extension on File {
  bool get isBinary {
    final extension = p.extension(path);
    return extension == '.ico' || extension == '.png';
  }
}

class RapidCreateException extends RapidException {
  RapidCreateException._(super.message);

  factory RapidCreateException._outputDirNotEmpty(String outputDir) {
    return RapidCreateException._(
      'The output directory "$outputDir" must be empty.',
    );
  }

  @override
  String toString() {
    return 'RapidCreateException: $message';
  }
}

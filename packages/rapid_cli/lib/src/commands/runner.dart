import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart' show StringCaseExtensions;
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/command_runner/util/platform_feature_packages_x.dart';
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/exception.dart';
import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project_config.dart';
import 'package:rapid_cli/src/utils.dart';

part 'activate.dart';
part 'begin.dart';
part 'create.dart';
part 'deactivate.dart';
part 'doctor.dart';
part 'domain.dart';
part 'end.dart';
part 'infrastructure.dart';
part 'platform.dart';
part 'pub.dart';
part 'ui.dart';

class Rapid extends _Rapid
    with
        _ActivateMixin,
        _BeginMixin,
        _CreateMixin,
        _DeactivateMixin,
        _DoctorMixin,
        _DomainMixin,
        _EndMixin,
        _InfrastructureMixin,
        _PlatformMixin,
        _PubMixin,
        _UiMixin {
  Rapid({
    RapidProject? project,
    required this.logger,
  }) : _project = project;

  @override
  final RapidLogger logger;
  @override
  RapidProject get project {
    if (_project != null) {
      return _project!;
    }

    throw UnsupportedError('No project resolved.');
  }

  @override
  set project(RapidProject project) {
    if (_project == null) {
      _project = project;
    } else {
      throw UnsupportedError('Project already resolved.');
    }
  }

  RapidProject? _project;
}

abstract class _Rapid {
  RapidLogger get logger;
  RapidProject get project;
  set project(RapidProject project);

  // TODO: is this the correct place to do this.
  // Consider moving this and execution of commands and grouping into workspace or package
  String get dotRapidTool => p.join(project.path, '.rapid_tool');

  String get dotRapidGroupActive => p.join(dotRapidTool, 'group-active');

  String get dotRapidNeedBootstrap => p.join(dotRapidTool, 'need-bootstrap');

  String get dotRapidNeedCodeGen => p.join(dotRapidTool, 'need-code-gen');

  /// Wheter the command is running as a part of a Rapid command group.
  bool get groupActive {
    final file = File(dotRapidGroupActive);
    if (file.existsSync()) {
      return file.readAsStringSync() == 'true';
    }

    return false;
  }

  FutureOr<T> task<T>(
    String description,
    FutureOr<T> Function() task, {
    bool showTiming = true,
  }) async {
    final generateProgress = logger.progress(description);
    final result = await task();
    generateProgress.finish(showTiming: showTiming);
    return result;
  }

  Future<void> bootstrap({
    required List<DartPackage> packages,
  }) async {
    if (groupActive) {
      final packageNames = packages.map((e) => e.packageName());
      final file = File(dotRapidNeedBootstrap);
      if (file.readAsStringSync().isEmpty) {
        file.writeAsStringSync(packageNames.join(','), mode: FileMode.append);
      } else {
        file.writeAsStringSync(
          ',${packageNames.join(',')}',
          mode: FileMode.append,
        );
      }
    } else {
      final command = [
        'melos',
        'bootstrap',
        '--scope',
        packages.map((e) => e.packageName()).join(','),
      ];
      await task(
        'Running "${command.join(' ')}"',
        () async => _startCommandInPackage(
          command,
          package: project,
        ),
      );
    }
  }

  Future<void> codeGen({
    required List<DartPackage> packages,
  }) async {
    if (groupActive) {
      final packagePaths = packages.map((e) => e.path);
      final file = File(dotRapidNeedCodeGen);
      if (file.readAsStringSync().isEmpty) {
        file.writeAsStringSync(packagePaths.join(','), mode: FileMode.append);
      } else {
        file.writeAsStringSync(
          ',${packagePaths.join(',')}',
          mode: FileMode.append,
        );
      }
    } else {
      await flutterPubGet(packages);
      await flutterPubRubBuildRunnerBuildDeleteConflictingOutputs(packages);
    }
  }

  Future<void> flutterPubGet(List<DartPackage> packages) async {
    return _commandTask(
      ['flutter', 'pub', 'get'],
      packages: packages,
    );
  }

  Future<FlutterPubGetDryRunResult> flutterPubGetDryRun(
    DartPackage package,
  ) async {
    final result = await _runCommandInPackage(
      ['flutter', 'pub', 'get', '--dry-run'],
      package: package,
    );

    return FlutterPubGetDryRunResult(
      !(result.stdout as String).contains('No dependencies would change.'),
    );
  }

  Future<void> flutterGenl10n(List<PlatformFeaturePackage> packages) async {
    return _commandTask(
      ['flutter', 'gen-l10n'],
      packages: packages,
      parallelism: 1,
    );
  }

  Future<void> dartFormatFix(DartPackage package) async {
    return _commandTask(
      ['dart', 'format', '.', '--fix'],
      packages: [package],
      parallelism: 1,
    );
  }

  Future<void> flutterConfigEnableAndroid(RapidProject project) async {
    return _commandTask(
      ['flutter', 'config', '--enable-android'],
      packages: [project],
      parallelism: 1,
    );
  }

  Future<void> flutterConfigEnableIos(RapidProject project) async {
    return _commandTask(
      ['flutter', 'config', '--enable-ios'],
      packages: [project],
      parallelism: 1,
    );
  }

  Future<void> flutterConfigEnableLinux(RapidProject project) async {
    return _commandTask(
      ['flutter', 'config', '--enable-linux-desktop'],
      packages: [project],
      parallelism: 1,
    );
  }

  Future<void> flutterConfigEnableMacos(RapidProject project) async {
    return _commandTask(
      ['flutter', 'config', '--enable-macos-desktop'],
      packages: [project],
      parallelism: 1,
    );
  }

  Future<void> flutterConfigEnableWeb(RapidProject project) async {
    return _commandTask(
      ['flutter', 'config', '--enable-web'],
      packages: [project],
      parallelism: 1,
    );
  }

  Future<void> flutterConfigEnableWindows(RapidProject project) async {
    return _commandTask(
      ['flutter', 'config', '--enable-windows-desktop'],
      packages: [project],
      parallelism: 1,
    );
  }

  Future<void> flutterPubRubBuildRunnerBuildDeleteConflictingOutputs(
    List<DartPackage> packages,
  ) async {
    return _commandTask(
      [
        'flutter',
        'pub',
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs'
      ],
      packages: packages,
    );
  }

  Future<void> _commandTask(
    List<String> cmd, {
    required List<DartPackage> packages,
    int? parallelism,
  }) async {
    if (packages.isEmpty) return;
    await task(
      'Running "${cmd.join(' ')}"',
      () async {
        await Stream.fromIterable(packages).parallel(
          (package) async {
            try {
              await _startCommandInPackage(cmd, package: package);

              logger
                  .child(package.packageName(), prefix: '$checkLabel ')
                  .child(p.relative(package.path, from: project.path));
            } on RapidRunCommandException catch (e) {
              logger
                  .child(package.packageName(), prefix: '$xMarkLabel ')
                  .child(p.relative(package.path, from: project.path));

              logger.stdout(e.stdout);
              logger.stderr(e.stderr);
              logger.newLine();

              rethrow;
            }
          },
          parallelism: parallelism,
        ).drain<void>();
        logger.newLine();
      },
    );
  }

  Future<void> _startCommandInPackage(
    List<String> cmd, {
    required DartPackage package,
  }) async {
    final stdout = <String>[];
    final stderr = <String>[];
    final process = await startCommand(cmd, workingDirectory: package.path);
    process.stdout
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .listen((msg) {
      stdout.add(msg);
      logger.trace(msg);
    });
    process.stderr
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .listen((msg) {
      stderr.add(msg);
      logger.trace(msg);
    });
    final exitCode = await process.exitCode;

    if (exitCode != 0) {
      throw RapidRunCommandException(
        package,
        cmd,
        stdout: stdout.join('\n'),
        stderr: stderr.join('\n'),
      );
    }
  }

  Future<ProcessResult> _runCommandInPackage(
    List<String> cmd, {
    required DartPackage package,
  }) =>
      runCommand(cmd, workingDirectory: package.path);

  void _logAndThrow<E extends RapidException>(E exception) {
    try {
      throw exception;
    } on E catch (e) {
      logger.error(e.message);
      rethrow;
    }
  }
}

// TODO better name
class RapidRunCommandException {
  final DartPackage package;
  final List<String> command;
  final String stdout;
  final String stderr;

  RapidRunCommandException(
    this.package,
    this.command, {
    required this.stdout,
    required this.stderr,
  });

  @override
  String toString() {
    return 'RapidRunCommandException: Failed to run "${command.join(' ')}" in ${package.packageName()}.';
  }
}

final class FlutterPubGetDryRunResult {
  final bool wouldChangeDependencies;

  FlutterPubGetDryRunResult(this.wouldChangeDependencies);
}

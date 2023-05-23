import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO impl cleaner

mixin GroupableMixin on RapidCommandWithProject {
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
}

mixin BootstrapMixin on GroupableMixin {
  @protected
  MelosBootstrapCommand get melosBootstrap;

  Future<void> bootstrap({
    required List<DartPackage> packages,
    required Logger logger,
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
      await melosBootstrap(
        cwd: project.path,
        logger: logger,
        scope: packages.map((e) => e.packageName()).toList(),
      );
    }
  }
}

mixin CodeGenMixin on GroupableMixin {
  @protected
  FlutterPubGetCommand get flutterPubGet;

  @protected
  FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      get flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  Future<void> codeGen({
    required List<DartPackage> packages,
    required Logger logger,
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
      for (final package in packages) {
        await flutterPubGet(cwd: package.path, logger: logger);
        await flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
          cwd: package.path,
          logger: logger,
        );
      }
    }
  }
}

/// {@template rapid_command}
/// Base class for all Rapid commands.
/// {@endtemplate}
abstract class RapidCommand extends Command<int> with OverridableArgResults {
  /// {@macro rapid_command}
  RapidCommand({
    Logger? logger,
  }) : logger = logger ?? Logger();

  final Logger logger;
}

abstract class RapidCommandWithProject extends RapidCommand {
  RapidCommandWithProject({
    super.logger,
  });

  Project get project;
}

abstract class RapidRootCommand extends RapidCommandWithProject {
  RapidRootCommand({
    super.logger,
    Project? project,
  }) : _project = project;

  final Project? _project;

  @override
  Project get project {
    if (_project != null) {
      return _project!;
    }
    _checkIfProjectRoot();
    return Project();
  }

  void _checkIfProjectRoot() {
    final melosFile = File('melos.yaml');
    if (!melosFile.existsSync()) {
      throw RapidException(
        'This command must be called from the root of a Rapid project.',
      );
    }
  }
}

abstract class RapidNonRootCommand extends RapidCommandWithProject {
  RapidNonRootCommand({
    super.logger,
    Project? project,
  }) : _project = project;

  final Project? _project;

  @override
  Project get project =>
      _project ?? Project(path: _findProjectRoot(Directory.current).path);

  Directory _findProjectRoot(Directory dir) {
    final melosFile = File(p.join(dir.path, 'melos.yaml'));
    if (melosFile.existsSync()) {
      return dir;
    }

    final parent = dir.parent;
    if (dir.path == parent.path) {
      throw RapidException(
        'Could not find Rapid project root.'
        'Did you call this command from within a Rapid project?',
      );
    }

    return _findProjectRoot(parent);
  }
}

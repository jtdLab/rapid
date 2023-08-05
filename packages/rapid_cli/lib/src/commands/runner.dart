import 'dart:async';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../cli.dart';
import '../exception.dart';
import '../io.dart';
import '../logging.dart';
import '../mason.dart';
import '../project/language.dart';
import '../project/project.dart';
import '../project_config.dart';
import '../tool.dart';
import '../utils.dart';

part 'activate.dart';
part 'begin.dart';
part 'create.dart';
part 'deactivate.dart';
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
        _DomainMixin,
        _EndMixin,
        _InfrastructureMixin,
        _PlatformMixin,
        _PubMixin,
        _UiMixin {
  Rapid({
    RapidProject? project,
    RapidTool? tool,
    required this.logger,
  })  : _project = project,
        _tool = tool;

  @override
  final RapidLogger logger;

  RapidProject? _project;

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

  /// Override this to test create command.
  @visibleForTesting
  RapidProject Function({required RapidProjectConfig config})?
      projectBuilderOverrides;

  @override
  RapidProject Function({required RapidProjectConfig config})
      get projectBuilder =>
          projectBuilderOverrides ??
          ({required RapidProjectConfig config}) =>
              RapidProject.fromConfig(config);

  final RapidTool? _tool;

  @override
  RapidTool get tool => _tool ?? RapidTool(path: project.path);
}

abstract class _Rapid {
  RapidLogger get logger;
  RapidProject get project;
  set project(RapidProject project);
  RapidProject Function({required RapidProjectConfig config})
      get projectBuilder;
  RapidTool get tool;

  Future<T> task<T>(
    String description,
    FutureOr<T> Function() task,
  ) async {
    final progress = logger.progress(description);
    try {
      final result = await task();
      progress.complete();
      return result;
    } catch (e) {
      progress.fail();
      rethrow;
    }
  }

  /// parallelism = 1 indicates sequentiell execution
  Future<void> taskGroup({
    String? description,
    required List<(String description, FutureOr<void> Function() task)> tasks,
    int? parallelism,
  }) async {
    if (parallelism == 1) {
      if (description != null) {
        logger.info(description);
      }
      for (final task in tasks) {
        await this.task(task.$1, task.$2);
      }
    } else {
      final group = logger.progressGroup(description);
      await Stream.fromIterable(tasks).parallel(
        (t) async {
          final progress = group.progress(t.$1);
          try {
            final result = await t.$2();
            progress.complete();
            return result;
          } catch (e) {
            progress.fail();
            rethrow;
          }
        },
        parallelism: parallelism,
      ).drain<void>();
    }
  }

  Future<void> dartFormatFixTask() async => task(
        'Running "dart format . --fix" in project',
        () async => dartFormatFix(project: project),
      );

  Future<void> flutterPubAddTask({
    required List<String> dependenciesToAdd,
    required DartPackage package,
  }) async {
    if (dependenciesToAdd.isEmpty) return;
    await task(
        'Running "flutter pub add ${dependenciesToAdd.join(' ')}" in ${package.packageName}',
        () async {
      try {
        await flutterPubAdd(
          package: package,
          dependenciesToAdd: dependenciesToAdd,
        );
      } catch (_) {
        // TODO(jtdLab): https://github.com/dart-lang/sdk/issues/52895
        await flutterPubGet(package: package);
      }
    });
  }

  Future<void> flutterGenl10nTask({required DartPackage package}) async => task(
        'Running "flutter gen-l10n" in ${package.packageName}',
        () async => flutterGenl10n(package: package),
      );

  Future<void> flutterPubGetTaskGroup({
    required List<DartPackage> packages,
  }) async {
    if (packages.isEmpty) return;
    await taskGroup(
      tasks: packages
          .map(
            (package) => (
              'Running "flutter pub get" in ${package.packageName}',
              () async => flutterPubGet(package: package)
            ),
          )
          .toList(),
    );
  }

  Future<void> flutterPubGetTask({
    required DartPackage package,
  }) async {
    if (tool.loadGroup().isActive) {
      tool.markAsNeedCodeGen(package: package);
    } else {
      await task(
        'Running "flutter pub get" in ${package.packageName}',
        () async => flutterPubGet(package: package),
      );
    }
  }

  Future<void> flutterPubRemoveTask({
    required List<String> packagesToRemove,
    required DartPackage package,
  }) async {
    if (packagesToRemove.isEmpty) return;
    await task(
      'Running "flutter pub remove ${packagesToRemove.join(' ')}" in ${package.packageName}',
      () async => flutterPubRemove(
        package: package,
        packagesToRemove: packagesToRemove,
      ),
    );
  }

  Future<void> flutterPubRunBuildRunnerBuildDeleteConflictingOutputsTask({
    required DartPackage package,
  }) async {
    if (tool.loadGroup().isActive) {
      tool.markAsNeedCodeGen(package: package);
    } else {
      await task(
        'Running code generation in ${package.packageName}',
        () async {
          await flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
            package: package,
          );
        },
      );
    }
  }

  Future<void> flutterPubRunBuildRunnerBuildDeleteConflictingOutputsTaskGroup({
    required List<DartPackage> packages,
  }) async {
    if (packages.isEmpty) return;

    if (tool.loadGroup().isActive) {
      for (final package in packages) {
        tool.markAsNeedCodeGen(package: package);
      }
    } else {
      await taskGroup(
        tasks: packages
            .map(
              (package) => (
                'Running code generation in ${package.packageName}',
                () async {
                  await flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
                    package: package,
                  );
                }
              ),
            )
            .toList(),
      );
    }
  }

  Future<void> melosBootstrapTask({
    required List<DartPackage> scope,
  }) async {
    if (scope.isEmpty) return;

    if (tool.loadGroup().isActive) {
      tool.markAsNeedBootstrap(packages: scope);
    } else {
      await task(
        'Running "melos bootstrap --scope ${scope.map((e) => e.packageName).join(',')}"',
        () async => melosBootstrap(scope: scope, project: project),
      );
    }
  }
}

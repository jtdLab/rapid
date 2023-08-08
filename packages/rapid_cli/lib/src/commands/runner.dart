import 'dart:async';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import '../cli.dart';
import '../exception.dart';
import '../io/io.dart' hide Platform;
import '../logging.dart';
import '../mason.dart';
import '../native_platform.dart';
import '../project/language.dart';
import '../project/platform.dart';
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

/// The central object holding all functionality that rapid_cli offers.
///
/// Each leaf command forwards its incoming arguments to this object.
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
  /// Create a new [Rapid] instance.
  Rapid({
    required this.logger,
    RapidProject? project,
    RapidTool? tool,
  })  : _project = project,
        _tool = tool;

  @override
  final RapidLogger logger;

  RapidProject? _project;

  @override
  RapidProject get project {
    assert(_project != null, 'No project resolved.');
    return _project!;
  }

  @override
  set project(RapidProject project) {
    assert(_project == null, 'Project already resolved.');
    _project = project;
  }

  /// Override this to test create command.
  @visibleForTesting
  RapidProject Function({required RapidProjectConfig config})?
      projectBuilderOverrides;

  // TODO(jtdLab): get this covered
  // coverage:ignore-start
  @override
  RapidProject Function({required RapidProjectConfig config})
      get projectBuilder =>
          projectBuilderOverrides ??
          // ignore: unnecessary_lambdas
          ({required config}) => RapidProject.fromConfig(config);
  // coverage:ignore-end

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

  /// Runs a single [task] and handles progress logging and cancellation on
  /// eventual failure.
  ///
  /// The [description] is a short description of the task being executed.
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
      // TODO(jtdLab): get this covered
      progress.fail(); // coverage:ignore-line
      rethrow;
    }
  }

  /// Executes a group of [tasks] and handles progress logging and cancellation
  /// on eventual failure.
  ///
  /// The task group will be terminated with the first failing task or after
  /// all [tasks] completed successfully.
  ///
  /// The [tasks] parameter is a list of tuples containing the description and a
  /// function representing the task to be executed. Each task function should
  /// return `void` or a `Future<void>`.
  ///
  /// The [description] is an optional parameter that provides a short
  /// description of the task group being executed.
  ///
  /// The [parallelism] parameter controls the maximum number of tasks that can
  /// run concurrently. Setting [parallelism] to 1 ensures
  /// sequential execution of tasks, meaning one task runs after the other
  /// completes. A value greater than 1 allows multiple tasks to run
  /// concurrently, limited by the provided [parallelism] value.
  /// If [parallelism] is set to `null` it falls back to the number of
  /// processors of the host platform.
  Future<void> taskGroup({
    required List<(String description, FutureOr<void> Function() task)> tasks,
    String? description,
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
            // TODO(jtdLab): get this covered
            progress.fail(); // coverage:ignore-line
            rethrow;
          }
        },
        parallelism: parallelism,
      ).drain<void>();
    }
  }

  /// Runs a task executing [dartFormatFix] in [project].
  Future<void> dartFormatFixTask() async => task(
        'Running "dart format . --fix" in project',
        () async => dartFormatFix(project: project),
      );

  /// Runs a task executing [dartPubAdd] with [dependenciesToAdd] in [package].
  Future<void> dartPubAddTask({
    required List<String> dependenciesToAdd,
    required DartPackage package,
  }) async {
    if (dependenciesToAdd.isEmpty) return;
    await task(
        'Running "dart pub add ${dependenciesToAdd.join(' ')}" '
        'in ${package.packageName}', () async {
      try {
        await dartPubAdd(
          package: package,
          dependenciesToAdd: dependenciesToAdd,
        );
      } catch (_) {
        // TODO(jtdLab): https://github.com/dart-lang/sdk/issues/52895
        // leads to pub add failing if empty version deps already in a
        // pubspec.yaml where pub add is called on.
        await dartPubGet(package: package);
      }
    });
  }

  /// Runs a task executing [flutterGenl10n] in [package].
  Future<void> flutterGenl10nTask({required DartPackage package}) async => task(
        'Running "flutter gen-l10n" in ${package.packageName}',
        () async => flutterGenl10n(package: package),
      );

  /// Runs a task group executing [dartPubGet] in each package of [packages].
  Future<void> dartPubGetTaskGroup({
    required List<DartPackage> packages,
  }) async {
    if (packages.isEmpty) return;
    await taskGroup(
      tasks: packages
          .map(
            (package) => (
              'Running "dart pub get" in ${package.packageName}',
              () async => dartPubGet(package: package)
            ),
          )
          .toList(),
    );
  }

  /// Runs a task executing [dartPubGet] in [package].
  Future<void> dartPubGetTask({required DartPackage package}) async {
    if (tool.loadGroup().isActive) {
      tool.markAsNeedCodeGen(package: package);
    } else {
      await task(
        'Running "dart pub get" in ${package.packageName}',
        () async => dartPubGet(package: package),
      );
    }
  }

  /// Runs a task executing [dartPubRemove] with [packagesToRemove]
  /// in [package].
  Future<void> dartPubRemoveTask({
    required List<String> packagesToRemove,
    required DartPackage package,
  }) async {
    if (packagesToRemove.isEmpty) return;
    await task(
      'Running "dart pub remove ${packagesToRemove.join(' ')}" '
      'in ${package.packageName}',
      () async => dartPubRemove(
        package: package,
        packagesToRemove: packagesToRemove,
      ),
    );
  }

  /// Runs a task executing [dartRunBuildRunnerBuildDeleteConflictingOutputs]
  /// in [package].
  ///
  /// If a command group is active [package] is marked as need code generation
  /// instead.
  Future<void> dartRunBuildRunnerBuildDeleteConflictingOutputsTask({
    required DartPackage package,
  }) async {
    if (tool.loadGroup().isActive) {
      tool.markAsNeedCodeGen(package: package);
    } else {
      await task(
        'Running code generation in ${package.packageName}',
        () async {
          await dartRunBuildRunnerBuildDeleteConflictingOutputs(
            package: package,
          );
        },
      );
    }
  }

  /// Runs a task group executing
  /// [dartRunBuildRunnerBuildDeleteConflictingOutputs] in each package
  /// of [packages].
  ///
  /// If a command group is active each package in [packages] is marked as need
  /// code generation instead.
  Future<void> dartRunBuildRunnerBuildDeleteConflictingOutputsTaskGroup({
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
                  await dartRunBuildRunnerBuildDeleteConflictingOutputs(
                    package: package,
                  );
                }
              ),
            )
            .toList(),
      );
    }
  }

  /// Runs a task executing [melosBootstrap] with [scope] in [project].
  ///
  /// If a command group is active the packages in [scope] are marked as
  /// need bootstrap instead.
  Future<void> melosBootstrapTask({
    required List<DartPackage> scope,
  }) async {
    if (scope.isEmpty) return;

    if (tool.loadGroup().isActive) {
      tool.markAsNeedBootstrap(packages: scope);
    } else {
      await task(
        'Running "melos bootstrap --scope '
        '${scope.map((e) => e.packageName).join(',')}"',
        () async => melosBootstrap(scope: scope, project: project),
      );
    }
  }
}

import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/utils.dart';

import 'io.dart';
import 'project/project.dart';

class RapidTool {
  RapidTool({
    required this.project,
  });

  final RapidProject project;

  String get _dotRapidTool => p.join(project.path, '.rapid_tool');

  File get _groupJson => File(p.join(_dotRapidTool, 'group.json'));

  CommandGroup loadGroup() {
    if (!_groupJson.existsSync()) {
      return CommandGroup._(
        project: project,
        isActive: false,
        packagesToBootstrap: [],
        packagesToCodeGen: [],
      );
    }

    return CommandGroup.fromJson(
      project,
      jsonDecode(_groupJson.readAsStringSync()),
    );
  }

  void _writeGroup(CommandGroup group) {
    if (!_groupJson.existsSync()) {
      _groupJson.createSync(recursive: true);
    }
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    _groupJson.writeAsStringSync(encoder.convert(group));
  }

  void activateCommandGroup() {
    _writeGroup(
      CommandGroup._(
        project: project,
        isActive: true,
        packagesToBootstrap: [],
        packagesToCodeGen: [],
      ),
    );
  }

  void deactivateCommandGroup() {
    final group = loadGroup();

    _writeGroup(
      CommandGroup._(
        project: project,
        isActive: false,
        packagesToBootstrap: group.packagesToBootstrap,
        packagesToCodeGen: group.packagesToCodeGen,
      ),
    );
  }

  /// Marks [packages] so `melos bootstrap` is run on them when the command group is ended.
  void markAsNeedBootstrap({required List<DartPackage> packages}) {
    final group = loadGroup();
    final packagesToBootstrap = <DartPackage>[];
    for (final package in [...group.packagesToBootstrap, ...packages]) {
      if (!packagesToBootstrap.any((e) => e.path == package.path)) {
        packagesToBootstrap.add(package);
      }
    }

    _writeGroup(
      CommandGroup._(
        project: project,
        isActive: group.isActive,
        packagesToBootstrap: packagesToBootstrap,
        packagesToCodeGen: group.packagesToCodeGen,
      ),
    );
  }

  /// Marks [package] so `flutter pub run build_runner build --delete-conflicting-outputs`
  /// is run on it when the command group is ended.
  void markAsNeedCodeGen({required DartPackage package}) {
    final group = loadGroup();

    final packagesToCodeGen = <DartPackage>[];
    for (final package in [...group.packagesToCodeGen, package]) {
      if (!packagesToCodeGen.any((e) => e.path == package.path)) {
        packagesToCodeGen.add(package);
      }
    }

    _writeGroup(
      CommandGroup._(
        project: project,
        isActive: group.isActive,
        packagesToBootstrap: group.packagesToBootstrap,
        packagesToCodeGen: packagesToCodeGen,
      ),
    );
  }
}

class CommandGroup {
  final RapidProject project;
  final bool isActive;
  final List<DartPackage> packagesToBootstrap;
  final List<DartPackage> packagesToCodeGen;

  CommandGroup._({
    required this.project,
    required this.isActive,
    required this.packagesToBootstrap,
    required this.packagesToCodeGen,
  });

  factory CommandGroup.fromJson(
    RapidProject project,
    Map<String, dynamic> json,
  ) {
    return CommandGroup._(
      project: project,
      isActive: json['isActive'],
      packagesToBootstrap: project
          .packages()
       
          .where(
            (e) => json['packagesToBootstrap'].contains(e.packageName),
          )
          .toList(),
      packagesToCodeGen: project
          .packages()
          .where(
            (e) => json['packagesToCodeGen'].contains(e.packageName),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'isActive': isActive,
        'packagesToBootstrap':
            packagesToBootstrap.map((e) => e.packageName).toList(),
        'packagesToCodeGen':
            packagesToCodeGen.map((e) => e.packageName).toList(),
      };
}

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import 'io/io.dart';

class RapidTool {
  RapidTool({
    required this.path,
  });

  final String path;

  String get _dotRapidTool => p.join(path, '.rapid_tool');

  File get _groupJson => File(p.join(_dotRapidTool, 'group.json'));

  CommandGroup loadGroup() {
    if (!_groupJson.existsSync()) {
      return const CommandGroup(
        isActive: false,
        packagesToBootstrap: {},
        packagesToCodeGen: {},
      );
    }

    final json =
        jsonDecode(_groupJson.readAsStringSync()) as Map<String, dynamic>;
    return CommandGroup.fromJson(json);
  }

  void _saveGroup(CommandGroup group) {
    if (!_groupJson.existsSync()) {
      _groupJson.createSync(recursive: true);
    }
    const encoder = JsonEncoder.withIndent('  ');
    _groupJson.writeAsStringSync(encoder.convert(group));
  }

  void activateCommandGroup() {
    _saveGroup(
      const CommandGroup(
        isActive: true,
        packagesToBootstrap: {},
        packagesToCodeGen: {},
      ),
    );
  }

  void deactivateCommandGroup() {
    final group = loadGroup();
    _saveGroup(group.copyWith(isActive: false));
  }

  /// Marks [packages] so `melos bootstrap` is run on them when the command group is ended.
  void markAsNeedBootstrap({required List<DartPackage> packages}) {
    final group = loadGroup();
    final packagesToBootstrap = group.packagesToBootstrap;

    for (final package in packages) {
      packagesToBootstrap.add(package.packageName);
    }

    _saveGroup(
      group.copyWith(
        packagesToBootstrap: packagesToBootstrap..sorted().toSet(),
      ),
    );
  }

  /// Marks [package] so `flutter pub run build_runner build --delete-conflicting-outputs`
  /// is run on it when the command group is ended.
  void markAsNeedCodeGen({required DartPackage package}) {
    final group = loadGroup();

    final packagesToCodeGen = group.packagesToCodeGen;
    packagesToCodeGen.add(package.packageName);

    _saveGroup(
      group.copyWith(
        packagesToCodeGen: packagesToCodeGen..sorted().toSet(),
      ),
    );
  }
}

@immutable
class CommandGroup {
  const CommandGroup({
    required this.isActive,
    required this.packagesToBootstrap,
    required this.packagesToCodeGen,
  });

  factory CommandGroup.fromJson(Map<String, dynamic> json) {
    return CommandGroup(
      isActive: json['isActive'] as bool,
      packagesToBootstrap:
          (json['packagesToBootstrap'] as List<dynamic>).cast<String>().toSet(),
      packagesToCodeGen:
          (json['packagesToCodeGen'] as List<dynamic>).cast<String>().toSet(),
    );
  }
  final bool isActive;
  final Set<String> packagesToBootstrap;
  final Set<String> packagesToCodeGen;

  CommandGroup copyWith({
    bool? isActive,
    Set<String>? packagesToBootstrap,
    Set<String>? packagesToCodeGen,
  }) {
    return CommandGroup(
      isActive: isActive ?? this.isActive,
      packagesToBootstrap: packagesToBootstrap ?? this.packagesToBootstrap,
      packagesToCodeGen: packagesToCodeGen ?? this.packagesToCodeGen,
    );
  }

  Map<String, dynamic> toJson() => {
        'isActive': isActive,
        'packagesToBootstrap': packagesToBootstrap.toList(),
        'packagesToCodeGen': packagesToCodeGen.toList(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final setEquals = const DeepCollectionEquality().equals;

    return other is CommandGroup &&
        other.isActive == isActive &&
        setEquals(other.packagesToBootstrap, packagesToBootstrap) &&
        setEquals(other.packagesToCodeGen, packagesToCodeGen);
  }

  @override
  int get hashCode => Object.hashAllUnordered(
        [isActive, ...packagesToBootstrap, ...packagesToCodeGen],
      );
}

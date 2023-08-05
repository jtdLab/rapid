import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/io/io.dart';
import 'package:rapid_cli/src/tool.dart';
import 'package:test/test.dart';

import 'mock_env.dart';
import 'mocks.dart';

RapidTool _getRapidTool({
  String? path,
}) {
  return RapidTool(
    path: path ?? 'path/to/tool',
  );
}

void main() {
  group('RapidTool', () {
    group('loadGroup', () {
      test(
        'returns command group stored in group.json',
        withMockFs(() {
          File(p.join('tool_path', '.rapid_tool', 'group.json'))
            ..createSync(recursive: true)
            ..writeAsStringSync(
              jsonEncode({
                'isActive': true,
                'packagesToBootstrap': ['package_a', 'package_b'],
                'packagesToCodeGen': ['package_c', 'package_d'],
              }),
            );
          final tool = _getRapidTool(path: 'tool_path');

          final commandGroup = tool.loadGroup();

          expect(
            commandGroup,
            CommandGroup(
              isActive: true,
              packagesToBootstrap: {'package_a', 'package_b'},
              packagesToCodeGen: {'package_c', 'package_d'},
            ),
          );
        }),
      );

      test(
        'returns empty command group if group.json is missing',
        withMockFs(() {
          final tool = _getRapidTool();

          final commandGroup = tool.loadGroup();

          expect(
            commandGroup,
            CommandGroup(
              isActive: false,
              packagesToBootstrap: {},
              packagesToCodeGen: {},
            ),
          );
        }),
      );
    });

    group('activateCommandGroup', () {
      test(
        'stores active but empty command group in group.json',
        withMockFs(() {
          final tool = _getRapidTool(path: 'tool_path');

          tool.activateCommandGroup();

          expect(
            tool.loadGroup(),
            CommandGroup(
              isActive: true,
              packagesToBootstrap: {},
              packagesToCodeGen: {},
            ),
          );
        }),
      );

      test(
        'overwrites existing command group',
        withMockFs(() {
          File(p.join('tool_path', '.rapid_tool', 'group.json'))
            ..createSync(recursive: true)
            ..writeAsStringSync(
              jsonEncode({
                'isActive': true,
                'packagesToBootstrap': ['package_a', 'package_b'],
                'packagesToCodeGen': ['package_c', 'package_d'],
              }),
            );
          final tool = _getRapidTool();

          final commandGroup = tool.loadGroup();

          expect(
            commandGroup,
            CommandGroup(
              isActive: false,
              packagesToBootstrap: {},
              packagesToCodeGen: {},
            ),
          );
        }),
      );
    });

    group('deactivateCommandGroup', () {
      test(
        'sets the isActive property of the current command group to false',
        withMockFs(() {
          File(p.join('tool_path', '.rapid_tool', 'group.json'))
            ..createSync(recursive: true)
            ..writeAsStringSync(
              jsonEncode({
                'isActive': true,
                'packagesToBootstrap': [],
                'packagesToCodeGen': [],
              }),
            );
          final tool = _getRapidTool(path: 'tool_path');

          tool.deactivateCommandGroup();

          expect(
            tool.loadGroup(),
            CommandGroup(
              isActive: false,
              packagesToBootstrap: {},
              packagesToCodeGen: {},
            ),
          );
        }),
      );
    });

    group('markAsNeedBootstrap', () {
      test(
        'updates packagesToBootstrap properly ',
        withMockFs(() {
          File(p.join('tool_path', '.rapid_tool', 'group.json'))
            ..createSync(recursive: true)
            ..writeAsStringSync(
              jsonEncode({
                'isActive': true,
                'packagesToBootstrap': ['package_b'],
                'packagesToCodeGen': [],
              }),
            );
          final tool = _getRapidTool(path: 'tool_path');

          tool.markAsNeedBootstrap(packages: [
            FakeDartPackage(packageName: 'package_a'),
            FakeDartPackage(packageName: 'package_c'),
          ]);

          expect(
            tool.loadGroup(),
            CommandGroup(
              isActive: true,
              packagesToBootstrap: {'package_a', 'package_b', 'package_c'},
              packagesToCodeGen: {},
            ),
          );
        }),
      );
    });

    group('markAsNeedCodeGen', () {
      test(
        'updates packagesToCodeGen properly ',
        withMockFs(() {
          File(p.join('tool_path', '.rapid_tool', 'group.json'))
            ..createSync(recursive: true)
            ..writeAsStringSync(
              jsonEncode({
                'isActive': true,
                'packagesToBootstrap': [],
                'packagesToCodeGen': ['package_b'],
              }),
            );
          final tool = _getRapidTool(path: 'tool_path');

          tool.markAsNeedCodeGen(
            package: FakeDartPackage(packageName: 'package_a'),
          );

          expect(
            tool.loadGroup(),
            CommandGroup(
              isActive: true,
              packagesToBootstrap: {},
              packagesToCodeGen: {'package_a', 'package_b'},
            ),
          );
        }),
      );
    });
  });

  group('CommandGroup', () {
    test('.fromJson', () {
      final json = {
        'isActive': true,
        'packagesToBootstrap': ['package_a', 'package_b'],
        'packagesToCodeGen': ['package_c', 'package_d'],
      };

      final commandGroup = CommandGroup.fromJson(json);

      expect(
        commandGroup,
        CommandGroup(
          isActive: true,
          packagesToBootstrap: {'package_a', 'package_b'},
          packagesToCodeGen: {'package_c', 'package_d'},
        ),
      );
    });

    group('copyWith', () {
      test('isActive', () {
        final commandGroup = CommandGroup(
          isActive: false,
          packagesToBootstrap: {'package_a', 'package_b'},
          packagesToCodeGen: {'package_b', 'package_c'},
        );

        expect(
          commandGroup.copyWith(isActive: true),
          CommandGroup(
            isActive: true,
            packagesToBootstrap: {'package_a', 'package_b'},
            packagesToCodeGen: {'package_b', 'package_c'},
          ),
        );
      });

      test('packagesToBootstrap', () {
        final commandGroup = CommandGroup(
          isActive: false,
          packagesToBootstrap: {'package_a', 'package_b'},
          packagesToCodeGen: {'package_b', 'package_c'},
        );

        expect(
          commandGroup.copyWith(packagesToBootstrap: {}),
          CommandGroup(
            isActive: false,
            packagesToBootstrap: {},
            packagesToCodeGen: {'package_b', 'package_c'},
          ),
        );
      });

      test('packagesToCodeGen', () {
        final commandGroup = CommandGroup(
          isActive: false,
          packagesToBootstrap: {'package_a', 'package_b'},
          packagesToCodeGen: {'package_b', 'package_c'},
        );

        expect(
          commandGroup.copyWith(packagesToCodeGen: {}),
          CommandGroup(
            isActive: false,
            packagesToBootstrap: {'package_a', 'package_b'},
            packagesToCodeGen: {},
          ),
        );
      });
    });

    test('toJson', () {
      final commandGroup = CommandGroup(
        isActive: true,
        packagesToBootstrap: {'package_a', 'package_b'},
        packagesToCodeGen: {'package_c', 'package_d'},
      );

      final json = {
        'isActive': true,
        'packagesToBootstrap': ['package_a', 'package_b'],
        'packagesToCodeGen': ['package_c', 'package_d'],
      };

      expect(commandGroup.toJson(), json);
    });
  });

  test('hashCode', () {
    final commandGroup1 = CommandGroup(
      isActive: false,
      packagesToBootstrap: {'package_a', 'package_b'},
      packagesToCodeGen: {'package_b', 'package_c'},
    );
    final commandGroup2 = CommandGroup(
      isActive: false,
      packagesToBootstrap: {'package_b', 'package_a'},
      packagesToCodeGen: {'package_c', 'package_b'},
    );
    final commandGroup3 = CommandGroup(
      isActive: true,
      packagesToBootstrap: {'package_a', 'package_b'},
      packagesToCodeGen: {'package_b', 'package_c'},
    );

    expect(commandGroup1.hashCode, commandGroup2.hashCode);
    expect(commandGroup1.hashCode, isNot(equals(commandGroup3.hashCode)));
    expect(commandGroup2.hashCode, isNot(equals(commandGroup3.hashCode)));
  });
}

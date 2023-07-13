import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

void main() {
  group('begin', () {
    test('throws GroupAlreadyActiveException when group is active', () async {
      final commandGroup = MockCommandGroup();
      when(() => commandGroup.isActive).thenReturn(true);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(commandGroup);
      final rapid = getRapid(tool: tool);

      expect(rapid.begin(), throwsA(isA<GroupAlreadyActiveException>()));
    });

    test('completes', () async {
      final commandGroup = MockCommandGroup();
      when(() => commandGroup.isActive).thenReturn(false);
      final tool = MockRapidTool();
      when(() => tool.loadGroup()).thenReturn(commandGroup);
      final logger = MockRapidLogger();
      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.begin();

      verify(() => tool.activateCommandGroup()).called(1);
      verify(() => logger.newLine()).called(1);
      verify(() => logger.commandSuccess('Started Command Group!')).called(1);
    });
  });
}

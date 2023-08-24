import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

void main() {
  setUpAll(registerFallbackValues);

  group('begin', () {
    test('throws GroupAlreadyActiveException when group is active', () async {
      final commandGroup = MockCommandGroup();
      when(() => commandGroup.isActive).thenReturn(true);
      final tool = MockRapidTool();
      when(tool.loadGroup).thenReturn(commandGroup);
      final logger = MockRapidLogger();
      final rapid = getRapid(tool: tool, logger: logger);

      expect(rapid.begin(), throwsA(isA<GroupAlreadyActiveException>()));
      verifyNever(tool.activateCommandGroup);
      verifyNever(logger.newLine);
      verifyNever(() => logger.commandSuccess(any()));
    });

    test('begins a command group', () async {
      final commandGroup = MockCommandGroup();
      when(() => commandGroup.isActive).thenReturn(false);
      final tool = MockRapidTool();
      when(tool.loadGroup).thenReturn(commandGroup);
      final logger = MockRapidLogger();
      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.begin();

      verifyInOrder([
        tool.activateCommandGroup,
        logger.newLine,
        () => logger.commandSuccess('Started Command Group!'),
      ]);
    });
  });
}

import 'package:mocktail/mocktail.dart';

// ignore: one_member_abstracts
abstract class _LogCommand {
  void call(
    String message, {
    int level,
    Object? error,
    StackTrace? stackTrace,
  });
}

class MockLogCommand extends Mock implements _LogCommand {
  MockLogCommand() {
    when(
      () => call(
        any(),
        level: any(named: 'level'),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);
  }
}

class MockStackTrace extends Mock implements StackTrace {}

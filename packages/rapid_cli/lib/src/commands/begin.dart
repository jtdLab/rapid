part of 'runner.dart';

mixin _BeginMixin on _Rapid {
  Future<void> begin() async {
    if (tool.loadGroup().isActive) {
      throw GroupAlreadyActiveException._();
    }

    tool.activateCommandGroup();

    logger
      ..newLine()
      ..commandSuccess('Started Command Group!');
  }
}

/// An exception thrown when a command group is already active.
class GroupAlreadyActiveException extends RapidException {
  GroupAlreadyActiveException._()
      : super(
          'There is already an active group. '
          'Call "rapid end" to complete it first.',
        );
}

part of 'runner.dart';

mixin _DoctorMixin on _Rapid {
  Future<void> doctor() {
    logger
      ..command('rapid doctor')
      ..newLine();

    // TODO: implement
    throw UnimplementedError(
      'This feature will be supported in future versions',
    );
  }
}

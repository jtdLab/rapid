import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

void main() {
  group('Project', () {
    final cwd = Directory.current;

    late Project project;

    setUp(() {
      Directory.current = Directory.systemTemp.createTempSync().path;

      project = Project();
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('appPackage', () {
      // TODO
    });

    group('diPackage', () {
      // TODO
    });

    group('melosFile', () {
      // TODO
    });

    group('isActivated', () {
      // TODO
    });

    group('platformDirectory', () {
      // TODO
    });

    group('platformUiPackage', () {
      // TODO
    });
  });
}

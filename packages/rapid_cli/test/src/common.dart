import 'dart:async';
import 'dart:io' hide Platform;
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:platform/platform.dart' as io;
import 'package:rapid_cli/src/platform.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/utils.dart';

extension PlatformX on Platform {
  String get prettyName {
    switch (this) {
      case Platform.android:
        return 'Android';
      case Platform.ios:
        return 'iOS';
      case Platform.web:
        return 'Web';
      case Platform.linux:
        return 'Linux';
      case Platform.macos:
        return 'macOS';
      case Platform.windows:
        return 'Windows';
      case Platform.mobile:
        return 'Mobile';
    }
  }

  List<String> get aliases {
    switch (this) {
      case Platform.android:
        return ['a'];
      case Platform.ios:
        return ['i'];
      case Platform.web:
        return [];
      case Platform.linux:
        return ['l', 'lin'];
      case Platform.macos:
        return ['mac'];
      case Platform.windows:
        return ['win'];
      case Platform.mobile:
        return [];
    }
  }
}

String tempPath = p.join(Directory.current.path, '.dart_tool', 'test', 'tmp');

final random = Random();
Future<Directory> getTempDir() async {
  var name = random.nextInt(pow(2, 32) as int);
  var dir = Directory(p.join(tempPath, '${name}_tmp'));
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
  await dir.create(recursive: true);
  return dir;
}

dynamic Function() withTempDir(FutureOr<void> Function() fn) {
  // TODO this leads to core tests failing randomly
  return () async {
    final cwd = Directory.current;
    final dir = await getTempDir();

    Directory.current = dir;
    try {
      await fn();
    } catch (_) {
      rethrow;
    } finally {
      Directory.current = cwd;
      dir.deleteSync(recursive: true);
    }
  };
}

void Function() overridePrint(void Function(List<String>) fn) {
  return () {
    final printLogs = <String>[];
    final spec = ZoneSpecification(
      print: (_, __, ___, String msg) {
        printLogs.add(msg);
      },
    );

    final platform = io.FakePlatform(
      // TODO(jtdLab): this make testing command usages easier because fewer line breaks
      environment: {envKeyRapidTerminalWidth: '1000'},
    );

    return Zone.current.fork(
      specification: spec,
      zoneValues: {
        currentPlatformZoneKey: platform,
      },
    ).run<void>(() => fn(printLogs));
  };
}

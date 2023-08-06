import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:rapid_cli/src/cli.dart';
import 'package:rapid_cli/src/io/io.dart';
import 'package:rapid_cli/src/validation.dart';
import 'package:test/test.dart';

Matcher isUsageException({String? message}) {
  var matcher = isA<UsageException>();

  if (message != null) {
    matcher = matcher.having((e) => e.message, 'message', message);
  }

  return matcher;
}

Matcher throwsUsageException({String? message}) {
  return throwsA(isUsageException(message: message));
}

Matcher isRapidConfigException({String? message}) {
  var matcher = isA<RapidConfigException>();

  if (message != null) {
    matcher = matcher.having((e) => e.message, 'message', message);
  }

  return matcher;
}

Matcher throwsRapidConfigException({String? message}) {
  return throwsA(isRapidConfigException(message: message));
}

Matcher isCliException({
  String? message,
  String? workingDirectory,
}) {
  var matcher = isA<CliException>();

  if (message != null) {
    matcher = matcher.having((e) => e.message, 'message', message);
  }

  if (workingDirectory != null) {
    matcher = matcher.having(
      (e) => e.workingDirectory,
      'workingDirectory',
      workingDirectory,
    );
  }

  if (message != null && workingDirectory != null) {
    matcher = matcher.having(
      (e) => e.toString(),
      'toString',
      contains('$message at $workingDirectory'),
    );
  }

  return matcher;
}

Matcher throwsCliException({
  String? message,
  String? workingDirectory,
}) {
  return throwsA(
    isCliException(
      message: message,
      workingDirectory: workingDirectory,
    ),
  );
}

/// Returns a [Matcher] that checks whether a list of [FileSystemEntity]
/// matches the [expectedEntities] list in any order. It compares the file paths
/// of the entities for equality.
///
/// Example usage:
///
/// ```dart
/// expect(
///   [File('a'), Directory('b')],
///   entityEquals([File('a'), Directory('b')]),
/// ); // => true
///
/// expect(
///   [File('a'), Directory('b')],
///   entityEquals([Directory('b'), File('a')]),
/// ); // => true
///
/// expect(
///   [File('a'), Directory('a')],
///   entityEquals([Directory('b'), File('b')]),
/// ); // => false
/// ```
Matcher entityEquals(List<FileSystemEntity> expectedEntities) =>
    FileSystemEntitiesMatcher(expectedEntities);

class FileSystemEntitiesMatcher extends Matcher {
  FileSystemEntitiesMatcher(this.expectedEntities);
  final List<FileSystemEntity> expectedEntities;

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is! Iterable<FileSystemEntity>) {
      return false;
    }

    final actualEntities = item;
    final entityEquality = UnorderedIterableEquality<FileSystemEntity>(
      _FileSystemEntityEquality(),
    );

    return entityEquality.equals(actualEntities, expectedEntities);
  }

  @override
  Description describe(Description description) {
    return description.add('matches the expected file system entities');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is! Iterable<FileSystemEntity>) {
      return mismatchDescription.add('is not an Iterable<FileSystemEntity>');
    }

    final actualEntities = item;

    mismatchDescription.add('has mismatched file system entities:\n');
    mismatchDescription.add('Expected entities:\n');
    mismatchDescription
        .add(expectedEntities.map((e) => '- ${e.path}\n').join());
    mismatchDescription.add('Actual entities:\n');
    mismatchDescription.add(actualEntities.map((e) => '- ${e.path}\n').join());

    return mismatchDescription;
  }
}

class _FileSystemEntityEquality implements Equality<FileSystemEntity> {
  @override
  bool equals(FileSystemEntity a, FileSystemEntity b) {
    return a.path == b.path;
  }

  @override
  int hash(FileSystemEntity entity) {
    return entity.path.hashCode;
  }

  @override
  bool isValidKey(Object? o) => o is FileSystemEntity;
}

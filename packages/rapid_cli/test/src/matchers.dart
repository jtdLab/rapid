import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:rapid_cli/src/io.dart';
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

Matcher entityEquals(List<FileSystemEntity> expectedEntities) =>
    FileSystemEntitiesMatcher(expectedEntities);

class FileSystemEntitiesMatcher extends Matcher {
  final List<FileSystemEntity> expectedEntities;

  FileSystemEntitiesMatcher(this.expectedEntities);

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

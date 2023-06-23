import 'dart:async';
import 'dart:io';

import 'package:file/memory.dart';
import 'package:rapid_cli/src/platform.dart';

/// Runs [testBody] against an in-memory file system.
FutureOr<void> Function() withMockFs(FutureOr<void> Function() testBody) {
  return () => IOOverrides.runWithIOOverrides(testBody, MockFs());
}

/// Used to override file I/O with an in-memory file system for testing.
///
/// Usage:
///
/// ```dart main
/// test('My FS test', withMockFs(() {
///   File('foo').createSync(); // File created in memory
/// }));
/// ```
///
/// Alternatively, set [IOOverrides.global] to a [MockFs] instance in your
/// test's `setUp`, and to `null` in the `tearDown`.
class MockFs extends IOOverrides {
  final MemoryFileSystem fs = MemoryFileSystem(
    style: currentPlatform.isWindows
        ? FileSystemStyle.windows
        : FileSystemStyle.posix,
  );

  @override
  Directory createDirectory(String path) => fs.directory(path);

  @override
  File createFile(String path) => fs.file(path);

  @override
  Link createLink(String path) => fs.link(path);

  @override
  Stream<FileSystemEvent> fsWatch(String path, int events, bool recursive) =>
      fs.file(path).watch(events: events, recursive: recursive);

  @override
  bool fsWatchIsSupported() => fs.isWatchSupported;

  @override
  Future<FileSystemEntityType> fseGetType(String path, bool followLinks) =>
      fs.type(path, followLinks: followLinks);

  @override
  FileSystemEntityType fseGetTypeSync(String path, bool followLinks) =>
      fs.typeSync(path, followLinks: followLinks);

  @override
  Future<bool> fseIdentical(String path1, String path2) =>
      fs.identical(path1, path2);

  @override
  bool fseIdenticalSync(String path1, String path2) =>
      fs.identicalSync(path1, path2);

  @override
  Directory getCurrentDirectory() => fs.currentDirectory;

  @override
  Directory getSystemTempDirectory() => fs.systemTempDirectory;

  @override
  void setCurrentDirectory(String path) {
    fs.currentDirectory = path;
  }

  @override
  Future<FileStat> stat(String path) => fs.stat(path);

  @override
  FileStat statSync(String path) => fs.statSync(path);
}

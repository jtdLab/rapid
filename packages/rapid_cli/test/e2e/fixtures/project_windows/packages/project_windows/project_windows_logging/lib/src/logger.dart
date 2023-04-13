import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

/// The log level of an [ProjectWindowsLogger].
enum Level {
  verbose(0),
  debug(500),
  info(800),
  warning(900),
  error(1000),
  wtf(1200),
  nothing(2000);

  final int value;
  const Level(this.value);

  bool operator >=(Level level) => value >= level.value;
}

/// Signature of [log].
typedef LogCommand = void Function(
  String message, {
  int level,
  Object? error,
  StackTrace? stackTrace,
});

/// The logger of the application.
abstract class ProjectWindowsLogger {
  final Level level;

  @visibleForTesting
  LogCommand? logCommandOverrides;

  ProjectWindowsLogger(this.level);

  LogCommand get _logCommand => logCommandOverrides ?? log;

  /// Log a message at level [Level.verbose].
  void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (Level.verbose >= level) {
      _logCommand(
        '[verbose] $message',
        level: Level.verbose.value,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log a message at level [Level.debug].
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (Level.debug >= level) {
      _logCommand(
        '[debug] $message',
        level: Level.debug.value,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log a message at level [Level.info].
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (Level.info >= level) {
      _logCommand(
        '[info] $message',
        level: Level.info.value,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log a message at level [Level.warning].
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (Level.warning >= level) {
      _logCommand(
        '[warning] $message',
        level: Level.warning.value,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log a message at level [Level.error].
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (Level.error >= level) {
      _logCommand(
        '[error] $message',
        level: Level.error.value,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log a message at level [Level.wtf].
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (Level.wtf >= level) {
      _logCommand(
        '[wtf] $message',
        level: Level.wtf.value,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// In development mode we log debug level messages to
/// provide the developer a good overview of the application.
@dev
@LazySingleton(as: ProjectWindowsLogger)
class ProjectWindowsLoggerDevelopment extends ProjectWindowsLogger {
  ProjectWindowsLoggerDevelopment() : super(Level.debug);
}

/// In test mode we log everything to get a low level overview
/// of the application in a production-like environment.
@test
@LazySingleton(as: ProjectWindowsLogger)
class ProjectWindowsLoggerTest extends ProjectWindowsLogger {
  ProjectWindowsLoggerTest() : super(Level.verbose);
}

/// In production mode we log nothing for security reasons.
@prod
@LazySingleton(as: ProjectWindowsLogger)
class ProjectWindowsLoggerProduction extends ProjectWindowsLogger {
  ProjectWindowsLoggerProduction() : super(Level.debug);
}

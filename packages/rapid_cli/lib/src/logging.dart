import 'dart:async';
import 'dart:io' as io;

import 'package:ansi_styles/ansi_styles.dart';
import 'package:io/ansi.dart';
import 'package:mason/mason.dart' as mason;

export 'package:ansi_styles/ansi_styles.dart';
export 'package:io/ansi.dart';
export 'package:mason/mason.dart'
    show Level, ProgressOptions, ProgressAnimation, LogTheme;

// TODO: use masons Progress if https://github.com/felangel/mason/issues/711 is fixed

final successMessageColor = AnsiStyles.green;
final successStyle = AnsiStyles.bold;
final taskGroupTitleStyle = AnsiStyles.bold;
final paket = '📦';
final construction = '🚧';
final rocket = '🚀';
final tada = '🎉';

class RapidLogger with _DelegateLogger {
  RapidLogger({
    mason.LogTheme theme = const mason.LogTheme(),
    mason.Level level = mason.Level.info,
    mason.ProgressOptions progressOptions = const mason.ProgressOptions(),
  }) : _logger = mason.Logger(
          theme: theme,
          level: level,
          progressOptions: progressOptions,
        );

  @override
  final mason.Logger _logger;

  void newLine() => info('');

  void commandSuccess(String message) {
    info(successMessageColor(successStyle('✅ $message')));
  }

  ProgressGroup progressGroup([String? description]) =>
      ProgressGroup._(description, level, options: progressOptions);
}

// Implements a custom version of masons progress
// which fixes https://github.com/felangel/mason/issues/711.
// This is done to allow using the offical release of mason from
// pub.dev without the issues of #711 as long its not fixed there.
// Using the offical mason release is required when publishing rapid_cli
// to pub.dev as non pub dependencies are not allowed.
class Progress implements mason.Progress {
  Progress._(
    this._message,
    this._stdout,
    this._level, {
    mason.ProgressOptions options = const mason.ProgressOptions(),
  })  : _stopwatch = Stopwatch(),
        _options = options {
    _stopwatch
      ..reset()
      ..start();

    // The animation is only shown when it would be meaningful.
    // Do not animate if the stdio type is not a terminal.
    if (!_stdout.hasTerminal) {
      final frames = _options.animation.frames;
      final char = frames.isEmpty ? '' : frames.first;
      final prefix = char.isEmpty ? char : '${lightGreen.wrap(char)} ';
      _write('$prefix$_message...');
      return;
    }

    _timer = Timer.periodic(const Duration(milliseconds: 80), _onTick);
  }

  final mason.ProgressOptions _options;

  final io.Stdout _stdout;

  final mason.Level _level;

  final Stopwatch _stopwatch;

  Timer? _timer;

  String _message;

  int _index = 0;

  String? _prevMessage;

  /// End the progress and mark it as completed.
  @override
  void complete([String? update]) {
    _stopwatch.stop();
    _write(
      '''$_clearPrevMessage${lightGreen.wrap('✓')} ${update ?? _message} $_time\n''',
    );
    _timer?.cancel();
  }

  /// End the progress and mark it as failed.
  @override
  void fail([String? update]) {
    _timer?.cancel();
    _write('$_clearPrevMessage${red.wrap('✗')} ${update ?? _message} $_time\n');
    _stopwatch.stop();
  }

  /// Update the progress message.
  @override
  void update(String update) {
    _message = update;
    _onTick(_timer);
  }

  /// Cancel the progress and remove the previous message.
  @override
  void cancel() {
    _timer?.cancel();
    _write(_clearPrevMessage);
    _stopwatch.stop();
  }

  String get _clearPrevMessage {
    if (_stdout.hasTerminal) {
      final prevMessageLength = _strip(_prevMessage ?? '').length;
      final maxLineLength = _stdout.terminalColumns;
      final linesToClear = (prevMessageLength / maxLineLength).ceil();

      return <String>[
        for (var i = 0; i < linesToClear; i++) ...[
          '\u001b[2K', // clear current line
          if (i == linesToClear - 1) ...[
            '\r', // bring cursor to the start of the current line
          ] else ...[
            '\u001b[1A', // move cursor up one line
          ]
        ],
      ].join(); // for each line of previous message
    }

    return '\u001b[2K' // clear current line
        '\r'; // bring cursor to the start of the current line
  }

  final RegExp _stripRegex = RegExp(
    [
      r'[\u001B\u009B][[\]()#;?]*(?:(?:(?:[a-zA-Z\d]*(?:;[-a-zA-Z\d\/#&.:=?%@~_]*)*)?\u0007)',
      r'(?:(?:\d{1,4}(?:;\\d{0,4})*)?[\dA-PR-TZcf-ntqry=><~]))'
    ].join('|'),
  );

  /// Removes any ANSI styling from [input].
  String _strip(String input) {
    return input.replaceAll(_stripRegex, '');
  }

  void _onTick(Timer? _) {
    _index++;
    final frames = _options.animation.frames;
    final char = frames.isEmpty ? '' : frames[_index % frames.length];
    final prefix = char.isEmpty ? char : '${lightGreen.wrap(char)} ';

    _write('$_clearPrevMessage$prefix$_message... $_time');
  }

  void _write(String object) {
    if (_level.index > mason.Level.info.index) return;
    _prevMessage = object;
    _stdout.write(object);
  }

  String get _time {
    final elapsedTime = _stopwatch.elapsed.inMilliseconds;
    final displayInMilliseconds = elapsedTime < 100;
    final time = displayInMilliseconds ? elapsedTime : elapsedTime / 1000;
    final formattedTime =
        displayInMilliseconds ? '${time}ms' : '${time.toStringAsFixed(1)}s';
    return '${darkGray.wrap('($formattedTime)')}';
  }
}

/// Handles any number of [GroupableProgress] instances created with [progress].
/// and logs the current message of every instance as a combined message.
/// Whenever one of the child [GroupableProgress] instances emits a message
/// an update gets logged.
///
/// Progress 1: 'Hello (0.1s)'
/// -> log: 'Hello (0.1s)'
/// Progress 2: 'Cool (0.1s)'
/// -> log: 'Hello (0.1s)'
///         'Cool (0.1s)'
/// Progress 1: 'Hello (0.3s)'
/// -> log: 'Hello (0.3s)'
///         'Cool (0.1s)'
class ProgressGroup {
  ProgressGroup._(
    String? description,
    this._level, {
    mason.ProgressOptions options = const mason.ProgressOptions(),
  })  : _progresses = {},
        _options = options {
    if (description != null) {
      io.stdout.writeln(description);
    }
  }

  final mason.Level _level;

  final mason.ProgressOptions _options;

  final Map<GroupableProgress, String> _progresses;

  bool get _hasTerminal => _stdout.hasTerminal;

  final io.Stdout _stdout = io.stdout;

  GroupableProgress progress(String message) =>
      GroupableProgress._(message, this, _level, options: _options);

  void _writeProgress(String message, GroupableProgress progress) {
    if (_progresses.isNotEmpty) {
      _eraseLines(_progresses.length);
    }

    _progresses[progress] = message;
    final frame = '${_progresses.entries.map((e) => e.value).join('\n')}\n';
    _stdout.write(frame);
  }

  void _eraseLines(int n) {
    const ereaseLine = '\u001b[2K\r';
    const moveUp = '\u001b[1A';
    _stdout.write('$moveUp$ereaseLine' * n);
  }
}

/// Behaves similar to a [Progress] but does not
/// write to [io.stdout] but instead reports its messages to a [ProgressGroup]
/// which handles logging of [GroupableProgress] instances.
class GroupableProgress {
  GroupableProgress._(
    this._message,
    this._group,
    this._level, {
    mason.ProgressOptions options = const mason.ProgressOptions(),
  })  : _stopwatch = Stopwatch(),
        _options = options {
    _stopwatch
      ..reset()
      ..start();

    // The animation is only shown when it would be meaningful.
    // Do not animate if the stdio type is not a terminal.
    if (!_group._hasTerminal) {
      final frames = _options.animation.frames;
      final char = frames.isEmpty ? '' : frames.first;
      final prefix = char.isEmpty ? char : '${lightGreen.wrap(char)} ';
      _write('$prefix$_message...');
      return;
    }

    _timer = Timer.periodic(const Duration(milliseconds: 80), _onTick);
  }

  final mason.ProgressOptions _options;

  final ProgressGroup _group;

  final mason.Level _level;

  final Stopwatch _stopwatch;

  Timer? _timer;

  String _message;

  int _index = 0;

  /// End the progress and mark it as completed.
  void complete([String? update]) {
    _stopwatch.stop();
    _write(
      '''${lightGreen.wrap('✓')} ${update ?? _message} $_time''',
    );
    _timer?.cancel();
  }

  /// End the progress and mark it as failed.
  void fail([String? update]) {
    _timer?.cancel();
    _write('${red.wrap('✗')} ${update ?? _message} $_time');
    _stopwatch.stop();
  }

  /// Update the progress message.
  void update(String update) {
    _message = update;
    _onTick(_timer);
  }

  /// Cancel the progress and remove the previous message.
  void cancel() {
    _timer?.cancel();
    _stopwatch.stop();
  }

  void _onTick(Timer? _) {
    _index++;
    final frames = _options.animation.frames;
    final char = frames.isEmpty ? '' : frames[_index % frames.length];
    final prefix = char.isEmpty ? char : '${lightGreen.wrap(char)} ';

    _write('$prefix$_message... $_time');
  }

  void _write(String object) {
    if (_level.index > mason.Level.info.index) return;
    _group._writeProgress(object, this);
  }

  String get _time {
    final elapsedTime = _stopwatch.elapsed.inMilliseconds;
    final displayInMilliseconds = elapsedTime < 100;
    final time = displayInMilliseconds ? elapsedTime : elapsedTime / 1000;
    final formattedTime =
        displayInMilliseconds ? '${time}ms' : '${time.toStringAsFixed(1)}s';
    return '${darkGray.wrap('($formattedTime)')}';
  }
}

abstract mixin class _DelegateLogger implements mason.Logger {
  mason.Logger get _logger;

  final io.IOOverrides? _overrides = io.IOOverrides.current;
  io.Stdout get _stdout => _overrides?.stdout ?? io.stdout;

  @override
  mason.Level get level => _logger.level;

  @override
  set level(mason.Level level) => _logger.level = level;

  @override
  mason.ProgressOptions get progressOptions => _logger.progressOptions;

  @override
  set progressOptions(mason.ProgressOptions progressOptions) =>
      _logger.progressOptions = progressOptions;

  @override
  void alert(
    String? message, {
    String? Function(String?)? style,
  }) =>
      _logger.alert(message, style: style);

  @override
  List<T> chooseAny<T extends Object?>(
    String? message, {
    required List<T> choices,
    List<T>? defaultValues,
    String Function(T choice)? display,
  }) =>
      _logger.chooseAny<T>(
        message,
        choices: choices,
        defaultValues: defaultValues,
        display: display,
      );

  @override
  T chooseOne<T extends Object?>(
    String? message, {
    required List<T> choices,
    T? defaultValue,
    String Function(T choice)? display,
  }) =>
      _logger.chooseOne<T>(
        message,
        choices: choices,
        defaultValue: defaultValue,
        display: display,
      );

  @override
  bool confirm(
    String? message, {
    bool defaultValue = false,
  }) =>
      _logger.confirm(message, defaultValue: defaultValue);

  @override
  void delayed(String? message) => _logger.delayed(message);

  @override
  void detail(
    String? message, {
    String? Function(String?)? style,
  }) =>
      _logger.detail(message, style: style);

  @override
  void err(
    String? message, {
    String? Function(String?)? style,
  }) =>
      _logger.err(message, style: style);

  @override
  void flush([void Function(String? p1)? print]) => _logger.flush(print);

  @override
  void info(
    String? message, {
    String? Function(String?)? style,
  }) =>
      _logger.info(message, style: style);

  @override
  Progress progress(String message, {mason.ProgressOptions? options}) =>
      Progress._(message, _stdout, level);

  @override
  String prompt(String? message, {Object? defaultValue, bool hidden = false}) =>
      _logger.prompt(
        message,
        defaultValue: defaultValue,
        hidden: hidden,
      );

  @override
  void success(
    String? message, {
    String? Function(String?)? style,
  }) =>
      _logger.success(message, style: style);

  @override
  void warn(
    String? message, {
    String tag = 'WARN',
    String? Function(String?)? style,
  }) =>
      _logger.warn(message, tag: tag, style: style);

  @override
  void write(String? message) => _logger.write(message);

  @override
  List<String> promptAny(String? message, {String separator = ','}) =>
      _logger.promptAny(message, separator: separator);

  @override
  mason.LogTheme get theme => _logger.theme;
}

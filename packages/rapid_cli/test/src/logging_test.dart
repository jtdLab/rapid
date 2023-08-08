import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:mason_logger/src/io.dart' show ControlCharacter, KeyStroke;
// ignore: depend_on_referenced_packages
import 'package:mason_logger/src/stdin_overrides.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/io/io.dart';
import 'package:rapid_cli/src/logging.dart';
import 'package:test/test.dart';

import 'mocks.dart';

void main() {
  group('RapidLogger', () {
    late Stdout stdout;
    late Stdin stdin;
    late Stdout stderr;

    setUp(() {
      stdout = MockStdout();
      stdin = MockStdin();
      stderr = MockStdout();

      when(() => stdout.supportsAnsiEscapes).thenReturn(true);
      when(() => stdout.terminalColumns).thenReturn(80);
    });

    group('newLine', () {
      test('writes empty line to stdout', () {
        IOOverrides.runZoned(
          () {
            RapidLogger().newLine();
            verify(() => stdout.writeln()).called(1);
          },
          stdout: () => stdout,
        );
      });

      test('does not write to stdout when Level > info', () {
        IOOverrides.runZoned(
          () {
            RapidLogger(level: Level.critical).newLine();
            verifyNever(() => stdout.writeln());
          },
          stdout: () => stdout,
        );
      });
    });

    group('commandSuccess', () {
      test('writes command success message to stdout', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().commandSuccess(message);
            verify(
              () => stdout.writeln(
                successMessageColor(successStyle('✅ $message')),
              ),
            ).called(1);
          },
          stdout: () => stdout,
        );
      });

      test('does not write to stdout when Level > info', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger(level: Level.critical).commandSuccess(message);
            verifyNever(
              () => stdout.writeln(
                successMessageColor(successStyle('✅ $message')),
              ),
            );
          },
          stdout: () => stdout,
        );
      });
    });

    group('theme', () {
      test('can be overridden at the logger level', () {
        final theme = LogTheme(
          info: (message) => '[message]: $message',
        );
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger(theme: theme).info(message);
            verify(() => stdout.writeln('[message]: $message')).called(1);
          },
          stdout: () => stdout,
        );
      });

      test('can be gotten at the logger level', () {
        final theme = LogTheme(
          info: (message) => '[message]: $message',
        );
        expect(RapidLogger(theme: theme).theme, theme);
      });

      test('can be overridden at the method level', () {
        String? style(String? message) => '[message]: $message';
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().info(message, style: style);
            verify(() => stdout.writeln('[message]: $message')).called(1);
          },
          stdout: () => stdout,
        );
      });

      test('is ignored when a method override is used.', () {
        final theme = LogTheme(
          info: (message) => '[message]: $message',
        );
        String? style(String? message) => '[info]: $message';
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger(theme: theme).info(message, style: style);
            verify(() => stdout.writeln('[info]: $message')).called(1);
            RapidLogger(theme: theme).info(message);
            verify(() => stdout.writeln('[message]: $message')).called(1);
          },
          stdout: () => stdout,
        );
      });
    });

    group('level', () {
      test('is mutable', () {
        final logger = RapidLogger();
        expect(logger.level, equals(Level.info));
        logger.level = Level.verbose;
        expect(logger.level, equals(Level.verbose));
      });
    });

    group('progressOptions', () {
      test('are set by default', () {
        expect(RapidLogger().progressOptions, equals(const ProgressOptions()));
      });

      test('can be injected via constructor', () {
        const customProgressOptions = ProgressOptions(
          animation: ProgressAnimation(frames: []),
        );
        expect(
          RapidLogger(progressOptions: customProgressOptions).progressOptions,
          equals(customProgressOptions),
        );
      });

      test('are mutable', () {
        final logger = RapidLogger();
        const customProgressOptions = ProgressOptions(
          animation: ProgressAnimation(frames: []),
        );
        expect(logger.progressOptions, equals(const ProgressOptions()));
        logger.progressOptions = customProgressOptions;
        expect(logger.progressOptions, equals(customProgressOptions));
      });
    });

    group('write', () {
      test('writes to stdout', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().write(message);
            verify(() => stdout.write(message)).called(1);
          },
          stdout: () => stdout,
        );
      });
    });

    group('info', () {
      test('writes line to stdout', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().info(message);
            verify(() => stdout.writeln(message)).called(1);
          },
          stdout: () => stdout,
        );
      });

      test('does not write to stdout when Level > info', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger(level: Level.critical).info(message);
            verifyNever(() => stdout.writeln(contains(message)));
          },
          stdout: () => stdout,
        );
      });
    });

    group('delayed', () {
      test('does not write to stdout', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().delayed(message);
            verifyNever(() => stdout.writeln(message));
          },
          stdout: () => stdout,
        );
      });
    });

    group('flush', () {
      test('writes to stdout', () {
        IOOverrides.runZoned(
          () {
            const messages = ['test', 'message', '!'];
            final logger = RapidLogger();
            for (final message in messages) {
              logger.delayed(message);
            }
            verifyNever(() => stdout.writeln(any()));

            logger.flush();

            for (final message in messages) {
              verify(() => stdout.writeln(message)).called(1);
            }
          },
          stdout: () => stdout,
        );
      });
    });

    group('err', () {
      test('writes line to stderr', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().err(message);
            verify(() => stderr.writeln(lightRed.wrap(message))).called(1);
          },
          stderr: () => stderr,
        );
      });

      test('does not write to stderr when Level > error', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger(level: Level.critical).err(message);
            verifyNever(() => stderr.writeln(lightRed.wrap(message)));
          },
          stderr: () => stderr,
        );
      });
    });

    group('alert', () {
      test('writes line to stderr', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().alert(message);
            verify(
              () => stderr.writeln(
                backgroundRed.wrap(styleBold.wrap(white.wrap(message))),
              ),
            ).called(1);
          },
          stderr: () => stderr,
        );
      });

      test('does not write to stderr when Level > critical', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger(level: Level.quiet).alert(message);
            verifyNever(
              () => stderr.writeln(
                backgroundRed.wrap(styleBold.wrap(white.wrap(message))),
              ),
            );
          },
          stderr: () => stderr,
        );
      });
    });

    group('detail', () {
      test('writes line to stdout', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger(level: Level.debug).detail(message);
            verify(() => stdout.writeln(darkGray.wrap(message))).called(1);
          },
          stdout: () => stdout,
        );
      });

      test('does not write to stdout when Level > debug', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().detail(message);
            verifyNever(() => stdout.writeln(darkGray.wrap(message)));
          },
          stdout: () => stdout,
        );
      });
    });

    group('warn', () {
      test('writes line to stderr', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().warn(message);
            verify(
              () {
                stderr.writeln(yellow.wrap(styleBold.wrap('[WARN] $message')));
              },
            ).called(1);
          },
          stderr: () => stderr,
        );
      });

      test('writes line to stderr with custom tag', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().warn(message, tag: '🚨');
            verify(
              () {
                stderr.writeln(yellow.wrap(styleBold.wrap('[🚨] $message')));
              },
            ).called(1);
          },
          stderr: () => stderr,
        );
      });

      test('writes line to stderr with empty tag', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().warn(message, tag: '');
            verify(
              () {
                stderr.writeln(yellow.wrap(styleBold.wrap(message)));
              },
            ).called(1);
          },
          stderr: () => stderr,
        );
      });

      test('does not write to stderr when Level > warning', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger(level: Level.error).warn(message);
            verifyNever(() {
              stderr.writeln(yellow.wrap(styleBold.wrap('[WARN] $message')));
            });
          },
          stderr: () => stderr,
        );
      });
    });

    group('success', () {
      test('writes line to stdout', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger().success(message);
            verify(() => stdout.writeln(lightGreen.wrap(message))).called(1);
          },
          stdout: () => stdout,
        );
      });

      test('does not write to stdout when Level > info', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            RapidLogger(level: Level.warning).success(message);
            verifyNever(() => stdout.writeln(lightGreen.wrap(message)));
          },
          stdout: () => stdout,
        );
      });
    });

    group('prompt', () {
      test('writes line to stdout and reads line from stdin', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            const response = 'test response';
            const prompt = '$message ';
            final promptWithResponse =
                '''\x1b[A\u001B[2K$message ${styleDim.wrap(lightCyan.wrap(response))}''';
            when(() => stdin.readLineSync()).thenReturn(response);
            final actual = RapidLogger().prompt(message);
            expect(actual, equals(response));
            verify(() => stdout.write(prompt)).called(1);
            verify(() => stdout.writeln(promptWithResponse)).called(1);
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });

      test('writes line to stdout and reads line from stdin with default', () {
        IOOverrides.runZoned(
          () {
            const defaultValue = 'Dash';
            const message = 'test message';
            const response = 'test response';
            final prompt = '$message ${darkGray.wrap('($defaultValue)')} ';
            final promptWithResponse =
                '''\x1b[A\u001B[2K$prompt${styleDim.wrap(lightCyan.wrap(response))}''';
            when(() => stdin.readLineSync()).thenReturn(response);
            final actual =
                RapidLogger().prompt(message, defaultValue: defaultValue);
            expect(actual, equals(response));
            verify(() => stdout.write(prompt)).called(1);
            verify(() => stdout.writeln(promptWithResponse)).called(1);
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });

      test('writes line to stdout and reads line from stdin hidden', () {
        IOOverrides.runZoned(
          () {
            const defaultValue = 'Dash';
            const message = 'test message';
            const response = 'test response';
            final prompt = '$message ${darkGray.wrap('($defaultValue)')} ';
            final promptWithResponse =
                '''\x1b[A\u001B[2K$prompt${styleDim.wrap(lightCyan.wrap('******'))}''';
            final bytes = [
              116,
              101,
              115,
              116,
              32,
              127,
              32,
              114,
              101,
              115,
              112,
              111,
              110,
              115,
              101,
              13,
            ];
            when(() => stdin.readByteSync()).thenAnswer(
              (_) => bytes.removeAt(0),
            );
            final actual = RapidLogger().prompt(
              message,
              defaultValue: defaultValue,
              hidden: true,
            );
            expect(actual, equals(response));
            verify(() => stdout.write(prompt)).called(1);
            verify(() => stdout.writeln(promptWithResponse)).called(1);
            verify(() => stdout.writeln()).called(1);
            verifyNever(() => stdout.write(any()));
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });

      test('writes multi line to stdout and resets after response', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message\nwith more\nlines';
            final lines = message.split('\n').length - 1;
            const response = 'test response';
            const prompt = '$message ';
            final promptWithResponse =
                '''\x1b[A\u001B[2K\u001B[${lines}A$message ${styleDim.wrap(lightCyan.wrap(response))}''';
            when(() => stdin.readLineSync()).thenReturn(response);
            final actual = RapidLogger().prompt(message);
            expect(actual, equals(response));
            verify(() => stdout.write(prompt)).called(1);
            verify(() => stdout.writeln(promptWithResponse)).called(1);
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });
    });

    group('confirm', () {
      test('writes line to stdout and reads line from stdin (default no)', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            final prompt = 'test message ${darkGray.wrap('(y/N)')} ';
            final promptWithResponse =
                '''\x1b[A\u001B[2K$prompt${styleDim.wrap(lightCyan.wrap('No'))}''';
            when(() => stdin.readLineSync()).thenReturn('');
            final actual = RapidLogger().confirm(message);
            expect(actual, isFalse);
            verify(() => stdout.write(prompt)).called(1);
            verify(() => stdout.writeln(promptWithResponse)).called(1);
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });

      test('writes line to stdout and reads line from stdin (default yes)', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            final prompt = 'test message ${darkGray.wrap('(Y/n)')} ';
            final promptWithResponse =
                '''\x1b[A\u001B[2K$prompt${styleDim.wrap(lightCyan.wrap('Yes'))}''';
            when(() => stdin.readLineSync()).thenReturn('y');
            final actual = RapidLogger().confirm(message, defaultValue: true);
            expect(actual, isTrue);
            verify(() => stdout.write(prompt)).called(1);
            verify(() => stdout.writeln(promptWithResponse)).called(1);
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });

      test('handles all versions of yes correctly', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            final prompt = 'test message ${darkGray.wrap('(y/N)')} ';
            const yesWords = ['y', 'Y', 'Yes', 'yes', 'yeah', 'yea', 'yup'];
            for (final word in yesWords) {
              final promptWithResponse =
                  '''\x1b[A\u001B[2K$prompt${styleDim.wrap(lightCyan.wrap('Yes'))}''';
              when(() => stdin.readLineSync()).thenReturn(word);
              final actual = RapidLogger().confirm(message);
              expect(actual, isTrue);
              verify(() => stdout.write(prompt)).called(1);
              verify(() => stdout.writeln(promptWithResponse)).called(1);
            }
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });

      test('handles all versions of no correctly', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            final prompt = 'test message ${darkGray.wrap('(y/N)')} ';
            const noWords = ['n', 'N', 'No', 'no', 'nope', 'Nope', 'nopE'];
            for (final word in noWords) {
              final promptWithResponse =
                  '''\x1b[A\u001B[2K$prompt${styleDim.wrap(lightCyan.wrap('No'))}''';
              when(() => stdin.readLineSync()).thenReturn(word);
              final actual = RapidLogger().confirm(message);
              expect(actual, isFalse);
              verify(() => stdout.write(prompt)).called(1);
              verify(() => stdout.writeln(promptWithResponse)).called(1);
            }
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });

      test('returns default when response is neither yes/no (default no)', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            final prompt = 'test message ${darkGray.wrap('(y/N)')} ';
            final promptWithResponse =
                '''\x1b[A\u001B[2K$prompt${styleDim.wrap(lightCyan.wrap('No'))}''';
            when(() => stdin.readLineSync()).thenReturn('maybe');
            final actual = RapidLogger().confirm(message);
            expect(actual, isFalse);
            verify(() => stdout.write(prompt)).called(1);
            verify(() => stdout.writeln(promptWithResponse)).called(1);
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });

      test('returns default when response is neither yes/no (default yes)', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            final prompt = 'test message ${darkGray.wrap('(Y/n)')} ';
            final promptWithResponse =
                '''\x1b[A\u001B[2K$prompt${styleDim.wrap(lightCyan.wrap('Yes'))}''';
            when(() => stdin.readLineSync()).thenReturn('maybe');
            final actual = RapidLogger().confirm(message, defaultValue: true);
            expect(actual, isTrue);
            verify(() => stdout.write(prompt)).called(1);
            verify(() => stdout.writeln(promptWithResponse)).called(1);
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });

      test('returns default when a utf8 decoding error occurs', () {
        IOOverrides.runZoned(
          () {
            const message = 'test message';
            final prompt = 'test message ${darkGray.wrap('(y/N)')} ';
            final promptWithResponse =
                '''\x1b[A\u001B[2K$prompt${styleDim.wrap(lightCyan.wrap('No'))}''';
            when(
              () => stdin.readLineSync(),
            ).thenThrow(const FormatException('Missing extension byte'));
            final actual = RapidLogger().confirm(message);
            expect(actual, isFalse);
            verify(() => stdout.write(prompt)).called(1);
            verify(() => stdout.writeln(promptWithResponse)).called(1);
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });
    });

    group('progress', () {
      test('writes lines to stdout', () async {
        when(() => stdout.hasTerminal).thenReturn(true);
        await IOOverrides.runZoned(
          () async {
            const time = '(0.Xs)';
            const message = 'test message';
            final done = RapidLogger().progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 300));
            done.complete();
            verifyInOrder([
              () {
                stdout.write(
                  '''${lightGreen.wrap('\b${'\b' * (message.length + 4 + time.length)}⠙')} $message... ${darkGray.wrap('(0.1s)')}''',
                );
              },
              () {
                stdout.write(
                  '''${lightGreen.wrap('\b${'\b' * (message.length + 4 + time.length)}⠹')} $message... ${darkGray.wrap('(0.2s)')}''',
                );
              },
              () {
                stdout.write(
                  '''\b${'\b' * (message.length + 4 + time.length)}\u001b[2K${lightGreen.wrap('✓')} $message ${darkGray.wrap('(0.3s)')}\n''',
                );
              },
            ]);
          },
          stdout: () => stdout,
          stdin: () => stdin,
        );
      });
    });

    group('chooseAny', () {
      test(
          'enter/return selects the nothing '
          'when defaultValues is not specified.', () {
        final keyStrokes = [KeyStroke.control(ControlCharacter.ctrlJ)];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              final actual = RapidLogger().chooseAny(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, isEmpty);
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  ${lightCyan.wrap('a')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('enter/return selects the default values when specified.', () {
        final keyStrokes = [KeyStroke.control(ControlCharacter.ctrlJ)];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = ['b', 'c'];
              final actual = RapidLogger().chooseAny(
                message,
                choices: ['a', 'b', 'c'],
                defaultValues: ['b', 'c'],
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('b')}'),
                () => stdout.write(' '),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('c')}'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('space selects/deselects the values.', () {
        final keyStrokes = [
          KeyStroke.char(' '),
          KeyStroke.char(' '),
          KeyStroke.control(ControlCharacter.arrowDown),
          KeyStroke.char(' '),
          KeyStroke.control(ControlCharacter.arrowDown),
          KeyStroke.char(' '),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = ['b', 'c'];
              final actual = RapidLogger().chooseAny(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('a')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('b')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('b')}'),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('b')}'),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('c')}'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('down arrow selects next index', () {
        final keyStrokes = [
          KeyStroke.control(ControlCharacter.arrowDown),
          KeyStroke.control(ControlCharacter.ctrlM),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              final actual = RapidLogger().chooseAny(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, equals(isEmpty));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('j selects next index', () {
        final keyStrokes = [
          KeyStroke.char('j'),
          KeyStroke.control(ControlCharacter.ctrlM),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              final actual = RapidLogger().chooseAny(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, equals(isEmpty));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('up arrow wraps to end', () {
        final keyStrokes = [
          KeyStroke.control(ControlCharacter.arrowUp),
          KeyStroke.control(ControlCharacter.ctrlM),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              final actual = RapidLogger().chooseAny(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, isEmpty);
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  ${lightCyan.wrap('a')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('k wraps to end', () {
        final keyStrokes = [
          KeyStroke.char('k'),
          KeyStroke.control(ControlCharacter.ctrlM),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              final actual = RapidLogger().chooseAny(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, isEmpty);
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('down arrow wraps to beginning', () {
        final keyStrokes = [
          KeyStroke.control(ControlCharacter.arrowDown),
          KeyStroke.control(ControlCharacter.arrowDown),
          KeyStroke.control(ControlCharacter.arrowDown),
          KeyStroke.control(ControlCharacter.ctrlM),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              final actual = RapidLogger().chooseAny(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, isEmpty);
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('converts choices to a preferred display', () {
        final keyStrokes = [KeyStroke.control(ControlCharacter.ctrlM)];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              final actual = RapidLogger().chooseAny<Map<String, String>>(
                message,
                choices: [
                  {'key': 'a'},
                  {'key': 'b'},
                  {'key': 'c'},
                ],
                display: (data) => 'Key: ${data['key']}',
              );
              expect(actual, isEmpty);
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(' ◯  Key: a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  Key: b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  Key: c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('converts results to a preferred display', () {
        final keyStrokes = [KeyStroke.control(ControlCharacter.ctrlM)];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = ['a', 'c'];
              final actual = RapidLogger().chooseAny<String>(
                message,
                choices: ['a', 'b', 'c'],
                defaultValues: ['a', 'c'],
                display: (data) => 'Key: $data',
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b8'),
                () => stdout.write('\x1b[J'),
                () => stdout.write('$message '),
                () => stdout.writeln('[Key: a, Key: c]'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });
    });

    group('chooseOne', () {
      test(
          'enter selects the initial value '
          'when defaultValue is not specified.', () {
        final keyStrokes = [KeyStroke.control(ControlCharacter.ctrlM)];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = 'a';
              final actual = RapidLogger().chooseOne(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('a')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('enter selects the default value when specified.', () {
        final keyStrokes = [KeyStroke.control(ControlCharacter.ctrlM)];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = 'b';
              final actual = RapidLogger().chooseOne(
                message,
                choices: ['a', 'b', 'c'],
                defaultValue: 'b',
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('b')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('space selects the default value when specified.', () {
        final keyStrokes = [KeyStroke.char(' ')];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = 'b';
              when(() => stdin.readByteSync()).thenReturn(32);
              final actual = RapidLogger().chooseOne(
                message,
                choices: ['a', 'b', 'c'],
                defaultValue: 'b',
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('b')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('down arrow selects next index', () {
        final keyStrokes = [
          KeyStroke.control(ControlCharacter.arrowDown),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = 'b';
              final actual = RapidLogger().chooseOne(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('a')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('b')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('up arrow selects previous index', () {
        final keyStrokes = [
          KeyStroke.control(ControlCharacter.arrowUp),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = 'a';
              final actual = RapidLogger().chooseOne(
                message,
                choices: ['a', 'b', 'c'],
                defaultValue: 'b',
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('b')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('a')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('up arrow wraps to end', () {
        final keyStrokes = [
          KeyStroke.control(ControlCharacter.arrowUp),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = 'c';
              final actual = RapidLogger().chooseOne(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('a')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('c')}'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('down arrow wraps to beginning', () {
        final keyStrokes = [
          KeyStroke.control(ControlCharacter.arrowDown),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = 'a';
              final actual = RapidLogger().chooseOne(
                message,
                choices: ['a', 'b', 'c'],
                defaultValue: 'c',
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('c')}'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('a')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('j selects next index', () {
        final keyStrokes = [
          KeyStroke.char('j'),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = 'b';
              final actual = RapidLogger().chooseOne(
                message,
                choices: ['a', 'b', 'c'],
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('a')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('b')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('k selects previous index', () {
        final keyStrokes = [
          KeyStroke.char('k'),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = 'a';
              final actual = RapidLogger().chooseOne(
                message,
                choices: ['a', 'b', 'c'],
                defaultValue: 'b',
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(' '),
                () => stdout.write(' ◯  a'),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('b')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout
                    .write(' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('a')}'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('converts choices to a preferred display', () {
        final keyStrokes = [KeyStroke.control(ControlCharacter.ctrlJ)];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = {'key': 'a'};
              final actual = RapidLogger().chooseOne<Map<String, String>>(
                message,
                choices: [
                  {'key': 'a'},
                  {'key': 'b'},
                  {'key': 'c'},
                ],
                display: (data) => 'Key: ${data['key']}',
              );
              expect(actual, equals(expected));
              verifyInOrder([
                () => stdout.write('\x1b7'),
                () => stdout.write('\x1b[?25l'),
                () => stdout.writeln(message),
                () => stdout.write(green.wrap('❯')),
                () => stdout.write(
                      ' ${lightCyan.wrap('◉')}  ${lightCyan.wrap('Key: a')}',
                    ),
                () => stdout.write(' '),
                () => stdout.write(' ◯  Key: b'),
                () => stdout.write(' '),
                () => stdout.write(' ◯  Key: c'),
              ]);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });
    });

    group('promptAny', () {
      test('returns empty list', () {
        final keyStrokes = [KeyStroke.control(ControlCharacter.ctrlJ)];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = <String>[];
              final actual = RapidLogger().promptAny(message);
              expect(actual, equals(expected));
              verify(() => stdout.write('$message ')).called(1);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('returns list with 1 item ([dart])', () {
        final keyStrokes = [
          KeyStroke.char('d'),
          KeyStroke.char('a'),
          KeyStroke.char('r'),
          KeyStroke.char('t'),
          KeyStroke.control(ControlCharacter.ctrlJ)
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = <String>['dart'];
              final actual = RapidLogger().promptAny(message);
              expect(actual, equals(expected));
              verify(() => stdout.write('$message ')).called(1);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('returns list with 2 items ([dart, css])', () {
        final keyStrokes = [
          KeyStroke.char('d'),
          KeyStroke.char('a'),
          KeyStroke.char('r'),
          KeyStroke.char('t'),
          KeyStroke.char(','),
          KeyStroke.char('c'),
          KeyStroke.char('s'),
          KeyStroke.char('s'),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = ['dart', 'css'];
              final actual = RapidLogger().promptAny(message);
              expect(actual, equals(expected));
              verify(() => stdout.write('$message ')).called(1);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('ignores trailing delimter', () {
        final keyStrokes = [
          KeyStroke.char('d'),
          KeyStroke.char('a'),
          KeyStroke.char('r'),
          KeyStroke.char('t'),
          KeyStroke.char(','),
          KeyStroke.char('c'),
          KeyStroke.char('s'),
          KeyStroke.char('s'),
          KeyStroke.char(','),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = ['dart', 'css'];
              final actual = RapidLogger().promptAny(message);
              expect(actual, equals(expected));
              verify(() => stdout.write('$message ')).called(1);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('ignores other control characters', () {
        final keyStrokes = [
          KeyStroke.char('d'),
          KeyStroke.char('a'),
          KeyStroke.char('r'),
          KeyStroke.char('t'),
          KeyStroke.control(ControlCharacter.ctrlZ),
          KeyStroke.control(ControlCharacter.arrowLeft),
          KeyStroke.control(ControlCharacter.arrowLeft),
          KeyStroke.control(ControlCharacter.arrowRight),
          KeyStroke.char(','),
          KeyStroke.char('c'),
          KeyStroke.char('s'),
          KeyStroke.char('s'),
          KeyStroke.char(','),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = ['dart', 'css'];
              final actual = RapidLogger().promptAny(message);
              expect(actual, equals(expected));
              verify(() => stdout.write('$message ')).called(1);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('custom separator (;)', () {
        final keyStrokes = [
          KeyStroke.char('d'),
          KeyStroke.char('a'),
          KeyStroke.char('r'),
          KeyStroke.char('t'),
          KeyStroke.char(';'),
          KeyStroke.char('c'),
          KeyStroke.char('s'),
          KeyStroke.char('s'),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = ['dart', 'css'];
              final actual = RapidLogger().promptAny(message, separator: ';');
              expect(actual, equals(expected));
              verify(() => stdout.write('$message ')).called(1);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('custom separator (" ")', () {
        final keyStrokes = [
          KeyStroke.char('d'),
          KeyStroke.char('a'),
          KeyStroke.char('r'),
          KeyStroke.char('t'),
          KeyStroke.char(' '),
          KeyStroke.char('c'),
          KeyStroke.char('s'),
          KeyStroke.char('s'),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = ['dart', 'css'];
              final actual = RapidLogger().promptAny(message, separator: ' ');
              expect(actual, equals(expected));
              verify(() => stdout.write('$message ')).called(1);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });

      test('backspace deletes delimeter', () {
        final keyStrokes = [
          KeyStroke.char('d'),
          KeyStroke.char('a'),
          KeyStroke.char('r'),
          KeyStroke.char('t'),
          KeyStroke.char(','),
          KeyStroke.char('x'),
          KeyStroke.control(ControlCharacter.delete),
          KeyStroke.control(ControlCharacter.delete),
          KeyStroke.char(','),
          KeyStroke.char('c'),
          KeyStroke.char('s'),
          KeyStroke.char('s'),
          KeyStroke.control(ControlCharacter.ctrlJ),
        ];
        StdinOverrides.runZoned(
          () => IOOverrides.runZoned(
            () {
              const message = 'test message';
              const expected = ['dart', 'css'];
              final actual = RapidLogger().promptAny(message);
              expect(actual, equals(expected));
              verify(() => stdout.write('$message ')).called(1);
            },
            stdout: () => stdout,
            stdin: () => stdin,
          ),
          readKey: () => keyStrokes.removeAt(0),
        );
      });
    });
  });

  group('Progress', () {
    late Stdout stdout;

    setUp(() {
      stdout = MockStdout();
      when(() => stdout.supportsAnsiEscapes).thenReturn(true);
      when(() => stdout.hasTerminal).thenReturn(true);
      when(() => stdout.terminalColumns).thenReturn(80);
    });

    test('writes ms when elapsed time is less than 0.1s', () async {
      await _runZoned(
        () async {
          const message = 'test message';
          final progress = RapidLogger().progress(message);
          await Future<void>.delayed(const Duration(milliseconds: 10));
          progress.complete();
          verify(
            () => stdout.write(any(that: matches(RegExp(r'\(\d\dms\)')))),
          ).called(1);
        },
        stdout: () => stdout,
        zoneValues: {AnsiCode: true},
      );
    });

    test('writes static message when stdout has no terminal', () async {
      when(() => stdout.hasTerminal).thenReturn(false);
      await _runZoned(
        () async {
          const message = 'test message';
          final done = RapidLogger().progress(message);
          await Future<void>.delayed(const Duration(milliseconds: 400));
          done.complete();
          verifyInOrder([
            () => stdout.write('${lightGreen.wrap('⠋')} $message...'),
            () {
              stdout.write(
                '''\u001b[2K\r${lightGreen.wrap('✓')} $message ${darkGray.wrap('(0.4s)')}\n''',
              );
            },
          ]);
        },
        stdout: () => stdout,
        zoneValues: {AnsiCode: true},
      );
    });

    test('writes custom progress animation to stdout', () async {
      await _runZoned(
        () async {
          const time = '(0.Xs)';
          const message = 'test message';
          const progressOptions = ProgressOptions(
            animation: ProgressAnimation(frames: ['+', 'x', '*']),
          );
          final done =
              RapidLogger().progress(message, options: progressOptions);
          await Future<void>.delayed(const Duration(milliseconds: 400));
          done.complete();
          verifyInOrder([
            () {
              stdout.write(
                '''${lightGreen.wrap('\b${'\b' * (message.length + 4 + time.length)}+')} $message... ${darkGray.wrap('(0.1s)')}''',
              );
            },
            () {
              stdout.write(
                '''${lightGreen.wrap('\b${'\b' * (message.length + 4 + time.length)}x')} $message... ${darkGray.wrap('(0.2s)')}''',
              );
            },
            () {
              stdout.write(
                '''${lightGreen.wrap('\b${'\b' * (message.length + 4 + time.length)}*')} $message... ${darkGray.wrap('(0.3s)')}''',
              );
            },
            () {
              stdout.write(
                '''\b${'\b' * (message.length + 4 + time.length)}\u001b[2K${lightGreen.wrap('✓')} $message ${darkGray.wrap('(0.4s)')}\n''',
              );
            },
          ]);
        },
        stdout: () => stdout,
        stdin: () => stdin,
      );
    });

    test('supports empty list of animation frames', () async {
      await _runZoned(
        () async {
          const time = '(0.Xs)';
          const message = 'test message';
          const progressOptions = ProgressOptions(
            animation: ProgressAnimation(frames: []),
          );
          final done =
              RapidLogger().progress(message, options: progressOptions);
          await Future<void>.delayed(const Duration(milliseconds: 400));
          done.complete();
          verifyInOrder([
            () {
              stdout.write(
                '''${lightGreen.wrap('\b${'\b' * (message.length + 4 + time.length)}')}$message... ${darkGray.wrap('(0.1s)')}''',
              );
            },
            () {
              stdout.write(
                '''${lightGreen.wrap('\b${'\b' * (message.length + 4 + time.length)}')}$message... ${darkGray.wrap('(0.2s)')}''',
              );
            },
            () {
              stdout.write(
                '''${lightGreen.wrap('\b${'\b' * (message.length + 4 + time.length)}')}$message... ${darkGray.wrap('(0.3s)')}''',
              );
            },
            () {
              stdout.write(
                '''\b${'\b' * (message.length + 4 + time.length)}\u001b[2K${lightGreen.wrap('✓')} $message ${darkGray.wrap('(0.4s)')}\n''',
              );
            },
          ]);
        },
        stdout: () => stdout,
        stdin: () => stdin,
      );
    });

    test('handles lines longer than terminal width', () async {
      await _runZoned(
        () async {
          when(() => stdout.terminalColumns).thenReturn(16);
          const message = '1234567890123456xxxxxxxx';
          final progress = RapidLogger().progress(message);
          await Future<void>.delayed(const Duration(milliseconds: 200));
          progress.complete();
          verify(
            () {
              stdout.write(
                any(
                  that: matches(
                    RegExp(
                      r'\[92m⠙\[0m 1234567890123456xxxxxxxx... \[90m\(\d\dms\)\[0m',
                    ),
                  ),
                ),
              );
            },
          ).called(1);

          verify(
            () {
              stdout.write(
                '''[2K[1A[2K[1A[2K\r[92m⠹[0m 1234567890123456xxxxxxxx... [90m(0.2s)[0m''',
              );
            },
          ).called(1);
          verify(
            () {
              stdout.write(
                '''[2K[1A[2K[1A[2K\r[92m✓[0m 1234567890123456xxxxxxxx [90m(0.2s)[0m\n''',
              );
            },
          ).called(1);
        },
        stdout: () => stdout,
        zoneValues: {AnsiCode: true},
      );
    });

    group('.complete', () {
      test('writes lines to stdout', () async {
        await _runZoned(
          () async {
            const message = 'test message';
            final progress = RapidLogger().progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.complete();
            verify(
              () {
                stdout.write(
                  any(
                    that: matches(
                      RegExp(
                        r'\[92m⠙\[0m test message... \[90m\(\d\dms\)\[0m',
                      ),
                    ),
                  ),
                );
              },
            ).called(1);

            verify(
              () {
                stdout.write(
                  '''[2K\r[92m✓[0m test message [90m(0.1s)[0m\n''',
                );
              },
            ).called(1);
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });

      test('does not write lines to stdout when Level > info', () async {
        await _runZoned(
          () async {
            const message = 'test message';
            final progress =
                RapidLogger(level: Level.warning).progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.complete();
            verifyNever(() => stdout.write(any()));
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });
    });

    group('.update', () {
      test('writes lines to stdout', () async {
        await _runZoned(
          () async {
            const message = 'message';
            const update = 'update';
            final progress = RapidLogger().progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.update(update);
            await Future<void>.delayed(const Duration(milliseconds: 100));

            verify(
              () {
                stdout.write(
                  any(
                    that: matches(
                      RegExp(
                        r'\[92m⠙\[0m message... \[90m\(\d\dms\)\[0m',
                      ),
                    ),
                  ),
                );
              },
            ).called(1);

            verify(
              () {
                stdout.write(
                  any(
                    that: matches(
                      RegExp(
                        r'\[2K\u000D\[92m⠹\[0m update... \[90m\(0\.1s\)\[0m',
                      ),
                    ),
                  ),
                );
              },
            ).called(1);
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });

      test('does not write to stdout when Level > info', () async {
        await _runZoned(
          () async {
            const message = 'message';
            const update = 'update';
            final progress =
                RapidLogger(level: Level.warning).progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.update(update);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            verifyNever(() => stdout.write(any()));
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });
    });

    group('.fail', () {
      test('writes lines to stdout', () async {
        await _runZoned(
          () async {
            const time = '(0.1s)';
            const message = 'test message';
            final progress = RapidLogger().progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.fail();

            verify(
              () {
                stdout.write(
                  any(
                    that: matches(
                      RegExp(
                        r'\[92m⠙\[0m test message... \[90m\(\d\dms\)\[0m',
                      ),
                    ),
                  ),
                );
              },
            ).called(1);

            verify(
              () {
                stdout.write(
                  '''[2K\u000D[31m✗[0m $message [90m$time[0m\n''',
                );
              },
            ).called(1);
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });

      test('does not write to stdout when Level > info', () async {
        await _runZoned(
          () async {
            const message = 'test message';
            final progress =
                RapidLogger(level: Level.warning).progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.fail();
            verifyNever(() => stdout.write(any()));
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });
    });

    group('.cancel', () {
      test('writes lines to stdout', () async {
        await _runZoned(
          () async {
            const message = 'test message';
            final progress = RapidLogger().progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.cancel();
            verify(
              () {
                stdout.write(
                  any(
                    that: matches(
                      RegExp(
                        r'\[92m⠙\[0m test message... \[90m\(\d\dms\)\[0m',
                      ),
                    ),
                  ),
                );
              },
            ).called(1);

            verify(
              () {
                stdout.write(
                  any(
                    that: matches(
                      RegExp(
                        r'\[2K\u000D',
                      ),
                    ),
                  ),
                );
              },
            ).called(1);
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });

      test('does not write to stdout when Level > info', () async {
        await _runZoned(
          () async {
            const message = 'test message';
            final progress =
                RapidLogger(level: Level.warning).progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.cancel();
            verifyNever(() => stdout.write(any()));
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });
    });
  });

  group('ProgressGroup', () {
    late Stdout stdout;

    setUp(() {
      stdout = MockStdout();
      when(() => stdout.supportsAnsiEscapes).thenReturn(true);
      when(() => stdout.hasTerminal).thenReturn(true);
      when(() => stdout.terminalColumns).thenReturn(80);
    });

    test('writes description', () async {
      await _runZoned(
        () async {
          RapidLogger().progressGroup('test description');

          verify(() => stdout.writeln('test description')).called(1);
        },
        stdout: () => stdout,
        zoneValues: {AnsiCode: true},
      );
    });

    test('writes static message when stdout has no terminal', () async {
      when(() => stdout.hasTerminal).thenReturn(false);
      await _runZoned(
        () async {
          const message = 'test message';
          final progressGroup = RapidLogger().progressGroup();
          final progress = progressGroup.progress(message);
          await Future<void>.delayed(const Duration(milliseconds: 400));
          progress.complete();
          verifyInOrder([
            () => stdout.write(
                  any(
                    that: matches(
                      RegExp(r'\[92m⠋\[0m test message...'),
                    ),
                  ),
                ),
            () => stdout.write(
                  any(
                    that: matches(
                      RegExp(r'\[92m✓\[0m test message'),
                    ),
                  ),
                ),
          ]);
        },
        stdout: () => stdout,
        zoneValues: {AnsiCode: true},
      );
    });

    test('writes frames based on sub progress messages', () async {
      await _runZoned(
        () async {
          final progressGroup = RapidLogger().progressGroup();
          const message1 = 'test message1';
          const message2 = 'test message2';
          final progress1 = progressGroup.progress(message1);
          final progress2 = progressGroup.progress(message2);
          await Future<void>.delayed(const Duration(milliseconds: 100));
          progress1.complete();
          progress2.complete();

          verifyInOrder([
            () => stdout.write(
                  any(
                    that: matches(
                      RegExp(
                        r'^\[92m⠙\[0m test message1... \[90m\(\d\dms\)\[0m\n$',
                      ),
                    ),
                  ),
                ),
            () => stdout.write(
                  any(
                    that: matches(
                      RegExp(r'^\[1A\[2K\r$'),
                    ),
                  ),
                ),
            () => stdout.write(
                  any(
                    that: matches(
                      RegExp(
                        r'^\[92m⠙\[0m test message1... \[90m\(\d\dms\)\[0m\n\[92m⠙\[0m test message2... \[90m\(\d\dms\)\[0m\n$',
                      ),
                    ),
                  ),
                ),
            () => stdout.write(
                  any(
                    that: matches(
                      RegExp(r'^\[1A\[2K\r\[1A\[2K\r$'),
                    ),
                  ),
                ),
            () => stdout.write(
                  any(
                    that: matches(
                      RegExp(
                        r'^\[92m✓\[0m test message1 \[90m\(0.1s\)\[0m\n\[92m⠙\[0m test message2... \[90m\(\d\dms\)\[0m\n$',
                      ),
                    ),
                  ),
                ),
            () => stdout.write(
                  any(
                    that: matches(
                      RegExp(r'^\[1A\[2K\r\[1A\[2K\r$'),
                    ),
                  ),
                ),
            () => stdout.write(
                  any(
                    that: matches(
                      RegExp(
                        r'^\[92m✓\[0m test message1 \[90m\(0.1s\)\[0m\n\[92m✓\[0m test message2 \[90m\(0.1s\)\[0m\n$',
                      ),
                    ),
                  ),
                ),
          ]);
        },
        stdout: () => stdout,
        zoneValues: {AnsiCode: true},
      );
    });

    group('.update', () {
      test('writes lines to stdout', () async {
        await _runZoned(
          () async {
            const message = 'message';
            const update = 'update';
            final progress = RapidLogger().progressGroup().progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.update(update);
            await Future<void>.delayed(const Duration(milliseconds: 100));

            verifyInOrder([
              () => stdout.write(
                    any(
                      that: matches(
                        RegExp(
                          r'\[92m⠙\[0m message... \[90m\(\d\dms\)\[0m',
                        ),
                      ),
                    ),
                  ),
              () => stdout.write(
                    any(
                      that: matches(
                        RegExp(r'^\[1A\[2K\r$'),
                      ),
                    ),
                  ),
              () => stdout.write(
                    any(
                      that: matches(
                        RegExp(
                          r'\[92m⠹\[0m update... \[90m\(0\.1s\)\[0m',
                        ),
                      ),
                    ),
                  ),
            ]);
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });

      test('does not writes to stdout when Level > info', () async {
        await _runZoned(
          () async {
            const message = 'message';
            const update = 'update';
            final progress = RapidLogger(level: Level.warning)
                .progressGroup()
                .progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.update(update);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            verifyNever(() => stdout.write(any()));
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });
    });

    group('.fail', () {
      test('writes lines to stdout', () async {
        await _runZoned(
          () async {
            const message = 'message';
            final progress = RapidLogger().progressGroup().progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.fail();

            verifyInOrder([
              () => stdout.write(
                    any(
                      that: matches(
                        RegExp(
                          r'\[92m⠙\[0m message... \[90m\(\d\dms\)\[0m',
                        ),
                      ),
                    ),
                  ),
              () => stdout.write(
                    any(
                      that: matches(
                        RegExp(r'^\[1A\[2K\r$'),
                      ),
                    ),
                  ),
              () => stdout.write(
                    any(
                      that: matches(
                        RegExp(
                          r'\[31m✗\[0m message \[90m\(0\.1s\)\[0m',
                        ),
                      ),
                    ),
                  ),
            ]);
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });

      test('does not write to stdout when Level > info', () async {
        await _runZoned(
          () async {
            const message = 'test message';
            final progress = RapidLogger(level: Level.warning)
                .progressGroup()
                .progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.fail();
            verifyNever(() => stdout.write(any()));
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });
    });

    group('.cancel', () {
      test('writes lines to stdout', () async {
        await _runZoned(
          () async {
            const message = 'message';
            final progress = RapidLogger().progressGroup().progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.cancel();
            verifyInOrder([
              () => stdout.write(
                    any(
                      that: matches(
                        RegExp(
                          r'\[92m⠙\[0m message... \[90m\(\d\dms\)\[0m',
                        ),
                      ),
                    ),
                  ),
              // TODO(jtdLab): should clear line
            ]);
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });

      test('does not write to stdout when Level > info', () async {
        await _runZoned(
          () async {
            const message = 'test message';
            final progress = RapidLogger(level: Level.warning)
                .progressGroup()
                .progress(message);
            await Future<void>.delayed(const Duration(milliseconds: 100));
            progress.cancel();
            verifyNever(() => stdout.write(any()));
          },
          stdout: () => stdout,
          zoneValues: {AnsiCode: true},
        );
      });
    });
  });
}

T _runZoned<T>(
  T Function() body, {
  Map<Object?, Object?>? zoneValues,
  Stdin Function()? stdin,
  Stdout Function()? stdout,
}) {
  return runZoned(
    () => IOOverrides.runZoned(body, stdout: stdout, stdin: stdin),
    zoneValues: zoneValues,
  );
}

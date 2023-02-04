import 'package:rapid_cli/src/cli/cli.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  group('ProcessOverrides', () {
    group('runZoned', () {
      test('uses default Process.start when not specified', () {
        ProcessOverrides.runZoned(() {
          final overrides = ProcessOverrides.current;
          expect(overrides!.startProcess, isA<Function>());
        });
      });

      test('uses default Process.run when not specified', () {
        ProcessOverrides.runZoned(() {
          final overrides = ProcessOverrides.current;
          expect(overrides!.runProcess, isA<Function>());
        });
      });

      test('uses custom Process.start when specified', () {
        final process = FakeProcess();
        ProcessOverrides.runZoned(
          () {
            final overrides = ProcessOverrides.current;
            expect(overrides!.startProcess, equals(process.start));
          },
          startProcess: process.start,
        );
      });

      test('uses custom Process.run when specified', () {
        final process = FakeProcess();
        ProcessOverrides.runZoned(
          () {
            final overrides = ProcessOverrides.current;
            expect(overrides!.runProcess, equals(process.run));
          },
          runProcess: process.run,
        );
      });

      test(
          'uses current Process.start when not specified '
          'and zone already contains a Process.start', () {
        final process = FakeProcess();
        ProcessOverrides.runZoned(
          () {
            ProcessOverrides.runZoned(() {
              final overrides = ProcessOverrides.current;
              expect(overrides!.startProcess, equals(process.start));
            });
          },
          startProcess: process.start,
        );
      });

      test(
          'uses current Process.run when not specified '
          'and zone already contains a Process.run', () {
        final process = FakeProcess();
        ProcessOverrides.runZoned(
          () {
            ProcessOverrides.runZoned(() {
              final overrides = ProcessOverrides.current;
              expect(overrides!.runProcess, equals(process.run));
            });
          },
          runProcess: process.run,
        );
      });

      test(
          'uses nested Process.start when specified '
          'and zone already contains a Process.start', () {
        final rootProcess = FakeProcess();
        ProcessOverrides.runZoned(
          () {
            final nestedProcess = FakeProcess();
            final overrides = ProcessOverrides.current;
            expect(overrides!.startProcess, equals(rootProcess.start));
            ProcessOverrides.runZoned(
              () {
                final overrides = ProcessOverrides.current;
                expect(overrides!.startProcess, equals(nestedProcess.start));
              },
              startProcess: nestedProcess.start,
            );
          },
          startProcess: rootProcess.start,
        );
      });

      test(
          'uses nested Process.run when specified '
          'and zone already contains a Process.run', () {
        final rootProcess = FakeProcess();
        ProcessOverrides.runZoned(
          () {
            final nestedProcess = FakeProcess();
            final overrides = ProcessOverrides.current;
            expect(overrides!.runProcess, equals(rootProcess.run));
            ProcessOverrides.runZoned(
              () {
                final overrides = ProcessOverrides.current;
                expect(overrides!.runProcess, equals(nestedProcess.run));
              },
              runProcess: nestedProcess.run,
            );
          },
          runProcess: rootProcess.run,
        );
      });
    });
  });
}

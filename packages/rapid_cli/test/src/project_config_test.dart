import 'package:rapid_cli/src/project_config.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  group('RapidProjectConfig', () {
    group('fromYaml', () {
      test('throws if name is missing', () {
        expect(
          () => RapidProjectConfig.fromYaml(
            {},
            path: 'foo',
          ),
          throwsRapidConfigException(),
        );
      });

      test('throws if name is not a String', () {
        expect(
          () => RapidProjectConfig.fromYaml(
            {
              'rapid': {
                'name': 22,
              }
            },
            path: 'foo',
          ),
          throwsRapidConfigException(),
        );
      });

      test('throws if name is not a valid dart package name', () {
        void testName(String name) {
          expect(
            () => RapidProjectConfig.fromYaml(
              {
                'rapid': {
                  'name': name,
                }
              },
              path: 'foo',
            ),
            throwsRapidConfigException(),
          );
        }

        testName('hello(world');
        testName('hello)world');
        testName('hello=world');
        testName("hello'world");
        testName('hello/world');
        testName(r'hello$world');
        testName('hello"world');
        testName('69');
        testName(r'hello\world');
        testName('hello|world');
        testName('hello world');
        testName('hello*world');
        testName('hello#world');
        testName('hello`world');
        testName('hello!world');
        testName('hello?world');
        testName('hello~world');
        testName('hello,world');
        testName('hello.world');
      });

      test('accepts valid dart package name', () {
        void testName(String name) {
          RapidProjectConfig.fromYaml(
            {
              'rapid': {
                'name': name,
              },
            },
            path: '/foo',
          );
        }

        testName('hello_world');
        testName('hello-world');
        testName('helloworld');
      });
    });
  });
}

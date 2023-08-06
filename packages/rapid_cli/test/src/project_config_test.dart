import 'package:rapid_cli/src/project_config.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  group('RapidProjectConfig', () {
    group('fromYaml', () {
      test('throws if name is missing', () {
        expect(
          () => RapidProjectConfig.fromYaml(
            const {},
            path: 'foo',
          ),
          throwsRapidConfigException(),
        );
      });

      test('throws if name is not a String', () {
        expect(
          () => RapidProjectConfig.fromYaml(
            const {
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
        void test(String name) {
          expect(
            RapidProjectConfig.fromYaml(
              {
                'rapid': {
                  'name': name,
                },
              },
              path: '/foo',
            ),
            RapidProjectConfig(name: name, path: '/foo'),
          );
        }

        test('hello_world');
        test('hello-world');
        test('helloworld');
      });
    });

    test('hashCode', () {
      final instance1 = RapidProjectConfig(path: '/foo', name: 'bar');
      final instance2 = RapidProjectConfig(path: '/foo', name: 'bar');
      final instance3 = RapidProjectConfig(path: '/hello', name: 'world');

      expect(instance1.hashCode == instance2.hashCode, true);
      expect(instance1.hashCode == instance3.hashCode, false);
    });
  });
}

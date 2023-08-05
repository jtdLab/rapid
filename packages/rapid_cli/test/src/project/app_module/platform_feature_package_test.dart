import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/mason.dart';
import 'package:rapid_cli/src/project/bundles/bundles.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:test/test.dart';

import '../../mock_env.dart';
import '../../mocks.dart';

class _PlatformFeaturePackage extends PlatformFeaturePackage {
  _PlatformFeaturePackage({
    String? projectName,
    String? name,
    Platform? platform,
  }) : super(
          projectName: projectName ?? 'project_name',
          name: name ?? 'name',
          platform: platform ?? Platform.android,
          path: 'path_to_platform_feature_package',
          bloc: ({required name}) => MockBloc(),
          cubit: ({required name}) => MockCubit(),
        );
}

PlatformFeaturePackage _getPlatformFeaturePackage({
  required String name,
  String? projectName,
  Platform? platform,
}) {
  return _PlatformFeaturePackage(
    name: name,
    projectName: projectName,
    platform: platform,
  );
}

PlatformAppFeaturePackage _getPlatformAppFeaturePackage({
  String? projectName,
  String? path,
  Platform? platform,
  Bloc Function({required String name})? bloc,
  Cubit Function({required String name})? cubit,
}) {
  return PlatformAppFeaturePackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.web,
    bloc: bloc ?? (({required String name}) => MockBloc()),
    cubit: cubit ?? (({required String name}) => MockCubit()),
  );
}

PlatformPageFeaturePackage _getPlatformPageFeaturePackage({
  String? projectName,
  String? path,
  Platform? platform,
  String? name,
  Bloc Function({required String name})? bloc,
  Cubit Function({required String name})? cubit,
  NavigatorImplementation? navigatorImplementation,
}) {
  return PlatformPageFeaturePackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.web,
    name: name ?? 'name',
    bloc: bloc ?? (({required String name}) => MockBloc()),
    cubit: cubit ?? (({required String name}) => MockCubit()),
    navigatorImplementation:
        navigatorImplementation ?? MockNavigatorImplementation(),
  );
}

PlatformFlowFeaturePackage _getPlatformFlowFeaturePackage({
  String? projectName,
  String? path,
  Platform? platform,
  String? name,
  Bloc Function({required String name})? bloc,
  Cubit Function({required String name})? cubit,
  NavigatorImplementation? navigatorImplementation,
}) {
  return PlatformFlowFeaturePackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.web,
    name: name ?? 'flow',
    bloc: bloc ?? (({required String name}) => MockBloc()),
    cubit: cubit ?? (({required String name}) => MockCubit()),
    navigatorImplementation:
        navigatorImplementation ?? MockNavigatorImplementation(),
  );
}

PlatformTabFlowFeaturePackage _getPlatformTabFlowFeaturePackage({
  String? projectName,
  String? path,
  Platform? platform,
  String? name,
  Bloc Function({required String name})? bloc,
  Cubit Function({required String name})? cubit,
  NavigatorImplementation? navigatorImplementation,
}) {
  return PlatformTabFlowFeaturePackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.web,
    name: name ?? 'tab_flow',
    bloc: bloc ?? (({required String name}) => MockBloc()),
    cubit: cubit ?? (({required String name}) => MockCubit()),
    navigatorImplementation:
        navigatorImplementation ?? MockNavigatorImplementation(),
  );
}

PlatformWidgetFeaturePackage _getPlatformWidgetFeaturePackage({
  String? projectName,
  String? path,
  Platform? platform,
  String? name,
  Bloc Function({required String name})? bloc,
  Cubit Function({required String name})? cubit,
}) {
  return PlatformWidgetFeaturePackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.web,
    name: name ?? 'widget',
    bloc: bloc ?? (({required String name}) => MockBloc()),
    cubit: cubit ?? (({required String name}) => MockCubit()),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('PlatformFeaturePackage', () {
    test('compareTo', () {
      final platformFeaturePackage1 = _getPlatformFeaturePackage(name: 'cool');
      final platformFeaturePackage2 = _getPlatformFeaturePackage(name: 'swag');

      final result1 =
          platformFeaturePackage1.compareTo(platformFeaturePackage1);
      final result2 =
          platformFeaturePackage1.compareTo(platformFeaturePackage2);
      final result3 =
          platformFeaturePackage2.compareTo(platformFeaturePackage1);

      expect(result1, 0);
      expect(result2, -1);
      expect(result3, 1);
    });

    group('==', () {
      test('should return true for equal packages', () {
        final platformFeaturePackage1 = _getPlatformFeaturePackage(
          name: 'foo',
          projectName: 'project_name',
          platform: Platform.android,
        );
        final platformFeaturePackage2 = _getPlatformFeaturePackage(
          name: 'foo',
          projectName: 'project_name',
          platform: Platform.android,
        );
        expect(platformFeaturePackage1 == platformFeaturePackage2, true);
      });

      test('should return false for different names', () {
        final platformFeaturePackage1 = _getPlatformFeaturePackage(
          name: 'foo',
          projectName: 'project_name',
          platform: Platform.android,
        );
        final platformFeaturePackage2 = _getPlatformFeaturePackage(
          name: 'bar',
          projectName: 'project_name',
          platform: Platform.android,
        );
        expect(platformFeaturePackage1 == platformFeaturePackage2, false);
      });

      test('should return false for different project names', () {
        final platformFeaturePackage1 = _getPlatformFeaturePackage(
          name: 'foo',
          projectName: 'project_name_a',
          platform: Platform.android,
        );
        final platformFeaturePackage2 = _getPlatformFeaturePackage(
          name: 'foo',
          projectName: 'project_name_b',
          platform: Platform.android,
        );
        expect(platformFeaturePackage1 == platformFeaturePackage2, false);
      });

      test('should return false for different platforms', () {
        final platformFeaturePackage1 = _getPlatformFeaturePackage(
          name: 'foo',
          projectName: 'project_name',
          platform: Platform.android,
        );
        final platformFeaturePackage2 = _getPlatformFeaturePackage(
          name: 'foo',
          projectName: 'project_name',
          platform: Platform.macos,
        );
        expect(platformFeaturePackage1 == platformFeaturePackage2, false);
      });
    });

    group('hashCode', () {
      test('should return the same value for equal packages', () {
        final platformFeaturePackage1 = _getPlatformFeaturePackage(
          name: 'foo',
          projectName: 'project_name',
          platform: Platform.android,
        );
        final platformFeaturePackage2 = _getPlatformFeaturePackage(
          name: 'foo',
          projectName: 'project_name',
          platform: Platform.android,
        );
        expect(
          platformFeaturePackage1.hashCode,
          platformFeaturePackage2.hashCode,
        );
      });

      test('should return different values for different languages', () {
        final platformFeaturePackage1 = _getPlatformFeaturePackage(
          name: 'foo',
          projectName: 'project_name_a',
          platform: Platform.android,
        );
        final platformFeaturePackage2 = _getPlatformFeaturePackage(
          name: 'bar',
          projectName: 'project_name_b',
          platform: Platform.macos,
        );
        expect(
          platformFeaturePackage1.hashCode,
          isNot(platformFeaturePackage2.hashCode),
        );
      });
    });
  });

  group('PlatformAppFeaturePackage', () {
    test('.resolve', () {
      final platformAppFeaturePackage = PlatformAppFeaturePackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.web,
      );

      expect(platformAppFeaturePackage, isA<PlatformFeaturePackage>());
      expect(platformAppFeaturePackage.projectName, 'test_project');
      expect(
        platformAppFeaturePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_app',
      );
      expect(
        platformAppFeaturePackage.barrelFile.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_app/lib/test_project_web_app.dart',
      );
      expect(
        platformAppFeaturePackage.applicationDir.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_app/lib/src/application',
      );
      expect(
        platformAppFeaturePackage.applicationBarrelFile.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_app/lib/src/application/application.dart',
      );
      final bloc = platformAppFeaturePackage.bloc(name: 'Counter');
      expect(bloc.projectName, 'test_project');
      expect(bloc.platform, Platform.web);
      expect(bloc.name, 'Counter');
      expect(
        bloc.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_app',
      );
      expect(bloc.featureName, 'app');
      final cubit = platformAppFeaturePackage.cubit(name: 'Counter');
      expect(cubit.projectName, 'test_project');
      expect(cubit.platform, Platform.web);
      expect(cubit.name, 'Counter');
      expect(
        cubit.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_app',
      );
      expect(cubit.featureName, 'app');
    });

    test(
      'generate',
      withMockFs(
        () async {
          final generator = MockMasonGenerator();
          final generatorBuilder = MockMasonGeneratorBuilder(
            generator: generator,
          );
          generatorOverrides = generatorBuilder;
          final platformAppFeaturePackage = _getPlatformAppFeaturePackage(
            projectName: 'test_project',
            path: '/path/to/platform_app_feature_package',
            platform: Platform.web,
          );

          await platformAppFeaturePackage.generate();

          verifyInOrder([
            () => generatorBuilder(platformAppFeaturePackageBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/platform_app_feature_package',
                    ),
                  ),
                  vars: <String, dynamic>{
                    'project_name': 'test_project',
                    'platform': 'web',
                    'android': false,
                    'ios': false,
                    'linux': false,
                    'macos': false,
                    'web': true,
                    'windows': false,
                    'mobile': false,
                  },
                ),
          ]);
        },
      ),
    );
  });

  group('PlatformPageFeaturePackage', () {
    test('.resolve', () {
      final platformPageFeaturePackage = PlatformPageFeaturePackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.web,
        name: 'foo',
      );

      expect(platformPageFeaturePackage, isA<PlatformRoutableFeaturePackage>());
      expect(platformPageFeaturePackage.projectName, 'test_project');
      expect(
        platformPageFeaturePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_page',
      );
      expect(
        platformPageFeaturePackage.barrelFile.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_page/lib/test_project_web_foo_page.dart',
      );
      expect(
        platformPageFeaturePackage.applicationDir.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_page/lib/src/application',
      );
      expect(
        platformPageFeaturePackage.applicationBarrelFile.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_page/lib/src/application/application.dart',
      );
      expect(platformPageFeaturePackage.name, 'foo_page');
      final bloc = platformPageFeaturePackage.bloc(name: 'Counter');
      expect(bloc.projectName, 'test_project');
      expect(bloc.platform, Platform.web);
      expect(bloc.name, 'Counter');
      expect(
        bloc.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_page',
      );
      expect(bloc.featureName, 'foo_page');
      final cubit = platformPageFeaturePackage.cubit(name: 'Counter');
      expect(cubit.projectName, 'test_project');
      expect(cubit.platform, Platform.web);
      expect(cubit.name, 'Counter');
      expect(cubit.path,
          '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_page');
      expect(cubit.featureName, 'foo_page');
      final navigatorImplementation =
          platformPageFeaturePackage.navigatorImplementation;
      expect(navigatorImplementation.projectName, 'test_project');
      expect(navigatorImplementation.platform, Platform.web);
      expect(
        navigatorImplementation.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_page',
      );
      expect(navigatorImplementation.name, 'foo_page');
    });

    test(
      'generate',
      withMockFs(
        () async {
          final generator = MockMasonGenerator();
          final generatorBuilder = MockMasonGeneratorBuilder(
            generator: generator,
          );
          generatorOverrides = generatorBuilder;
          final platformPageFeaturePackage = _getPlatformPageFeaturePackage(
            projectName: 'test_project',
            path: '/path/to/platform_page_feature_package',
            platform: Platform.web,
            name: 'foo',
          );

          await platformPageFeaturePackage.generate(
            description: 'Foo Page Feature',
          );

          verifyInOrder([
            () => generatorBuilder(platformPageFeaturePackageBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/platform_page_feature_package',
                    ),
                  ),
                  vars: <String, dynamic>{
                    'name': 'foo_page',
                    'description': 'Foo Page Feature',
                    'project_name': 'test_project',
                    'platform': 'web',
                    'android': false,
                    'ios': false,
                    'linux': false,
                    'macos': false,
                    'web': true,
                    'windows': false,
                    'mobile': false,
                  },
                ),
          ]);
        },
      ),
    );
  });

  group('PlatformFlowFeaturePackage', () {
    test('.resolve', () {
      final platformFlowFeaturePackage = PlatformFlowFeaturePackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.web,
        name: 'foo',
      );

      expect(platformFlowFeaturePackage, isA<PlatformRoutableFeaturePackage>());
      expect(platformFlowFeaturePackage.projectName, 'test_project');
      expect(
        platformFlowFeaturePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_flow',
      );
      expect(
        platformFlowFeaturePackage.barrelFile.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_flow/lib/test_project_web_foo_flow.dart',
      );
      expect(
        platformFlowFeaturePackage.applicationDir.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_flow/lib/src/application',
      );
      expect(
        platformFlowFeaturePackage.applicationBarrelFile.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_flow/lib/src/application/application.dart',
      );
      expect(platformFlowFeaturePackage.name, 'foo_flow');
      final bloc = platformFlowFeaturePackage.bloc(name: 'Counter');
      expect(bloc.projectName, 'test_project');
      expect(bloc.platform, Platform.web);
      expect(bloc.name, 'Counter');
      expect(
        bloc.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_flow',
      );
      expect(bloc.featureName, 'foo_flow');
      final cubit = platformFlowFeaturePackage.cubit(name: 'Counter');
      expect(cubit.projectName, 'test_project');
      expect(cubit.platform, Platform.web);
      expect(cubit.name, 'Counter');
      expect(
        cubit.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_flow',
      );
      expect(cubit.featureName, 'foo_flow');
      final navigatorImplementation =
          platformFlowFeaturePackage.navigatorImplementation;
      expect(navigatorImplementation.projectName, 'test_project');
      expect(navigatorImplementation.platform, Platform.web);
      expect(
        navigatorImplementation.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_flow',
      );
      expect(navigatorImplementation.name, 'foo_flow');
    });

    test(
      'generate',
      withMockFs(
        () async {
          final generator = MockMasonGenerator();
          final generatorBuilder = MockMasonGeneratorBuilder(
            generator: generator,
          );
          generatorOverrides = generatorBuilder;
          final platformFlowFeaturePackage = _getPlatformFlowFeaturePackage(
            projectName: 'test_project',
            path: '/path/to/platform_flow_feature_package',
            platform: Platform.web,
            name: 'foo',
          );

          await platformFlowFeaturePackage.generate(
            description: 'Foo Flow Feature',
          );

          verifyInOrder([
            () => generatorBuilder(platformFlowFeaturePackageBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/platform_flow_feature_package',
                    ),
                  ),
                  vars: <String, dynamic>{
                    'name': 'foo_flow',
                    'description': 'Foo Flow Feature',
                    'project_name': 'test_project',
                    'platform': 'web',
                    'android': false,
                    'ios': false,
                    'linux': false,
                    'macos': false,
                    'web': true,
                    'windows': false,
                    'mobile': false,
                  },
                ),
          ]);
        },
      ),
    );
  });

  group('PlatformTabFlowFeaturePackage', () {
    test('.resolve', () {
      final platformTabFlowFeaturePackage =
          PlatformTabFlowFeaturePackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.web,
        name: 'foo',
      );

      expect(
          platformTabFlowFeaturePackage, isA<PlatformRoutableFeaturePackage>());
      expect(platformTabFlowFeaturePackage.projectName, 'test_project');
      expect(
        platformTabFlowFeaturePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_tab_flow',
      );
      expect(
        platformTabFlowFeaturePackage.barrelFile.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_tab_flow/lib/test_project_web_foo_tab_flow.dart',
      );
      expect(
        platformTabFlowFeaturePackage.applicationDir.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_tab_flow/lib/src/application',
      );
      expect(
        platformTabFlowFeaturePackage.applicationBarrelFile.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_tab_flow/lib/src/application/application.dart',
      );
      expect(platformTabFlowFeaturePackage.name, 'foo_tab_flow');
      final bloc = platformTabFlowFeaturePackage.bloc(name: 'Counter');
      expect(bloc.projectName, 'test_project');
      expect(bloc.platform, Platform.web);
      expect(bloc.name, 'Counter');
      expect(
        bloc.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_tab_flow',
      );
      expect(bloc.featureName, 'foo_tab_flow');
      final cubit = platformTabFlowFeaturePackage.cubit(name: 'Counter');
      expect(cubit.projectName, 'test_project');
      expect(cubit.platform, Platform.web);
      expect(cubit.name, 'Counter');
      expect(
        cubit.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_tab_flow',
      );
      expect(cubit.featureName, 'foo_tab_flow');
      final navigatorImplementation =
          platformTabFlowFeaturePackage.navigatorImplementation;
      expect(navigatorImplementation.projectName, 'test_project');
      expect(navigatorImplementation.platform, Platform.web);
      expect(
        navigatorImplementation.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_tab_flow',
      );
      expect(navigatorImplementation.name, 'foo_tab_flow');
    });

    test(
      'generate',
      withMockFs(
        () async {
          final generator = MockMasonGenerator();
          final generatorBuilder = MockMasonGeneratorBuilder(
            generator: generator,
          );
          generatorOverrides = generatorBuilder;
          final platformTabFlowFeaturePackage =
              _getPlatformTabFlowFeaturePackage(
            projectName: 'test_project',
            path: '/path/to/platform_tab_flow_feature_package',
            platform: Platform.web,
            name: 'foo',
          );

          await platformTabFlowFeaturePackage.generate(
            description: 'Foo Tab Flow Feature',
            subFeatures: {'feature1', 'feature2'},
          );

          verifyInOrder([
            () => generatorBuilder(platformTabFlowFeaturePackageBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/platform_tab_flow_feature_package',
                    ),
                  ),
                  vars: <String, dynamic>{
                    'name': 'foo_tab_flow',
                    'description': 'Foo Tab Flow Feature',
                    'project_name': 'test_project',
                    'platform': 'web',
                    'android': false,
                    'ios': false,
                    'linux': false,
                    'macos': false,
                    'web': true,
                    'windows': false,
                    'mobile': false,
                    'subRoutes': [
                      {'name': 'Feature1', 'isFirst': true},
                      {'name': 'Feature2', 'isFirst': false},
                    ],
                  },
                ),
          ]);
        },
      ),
    );
  });

  group('PlatformWidgetFeaturePackage', () {
    test('.resolve', () {
      final platformWidgetFeaturePackage = PlatformWidgetFeaturePackage.resolve(
        projectName: 'test_project',
        projectPath: '/path/to/project',
        platform: Platform.web,
        name: 'foo',
      );

      expect(platformWidgetFeaturePackage, isA<PlatformFeaturePackage>());
      expect(platformWidgetFeaturePackage.projectName, 'test_project');
      expect(
        platformWidgetFeaturePackage.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_widget',
      );
      expect(
        platformWidgetFeaturePackage.barrelFile.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_widget/lib/test_project_web_foo_widget.dart',
      );
      expect(
        platformWidgetFeaturePackage.applicationDir.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_widget/lib/src/application',
      );
      expect(
        platformWidgetFeaturePackage.applicationBarrelFile.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_widget/lib/src/application/application.dart',
      );
      expect(platformWidgetFeaturePackage.name, 'foo_widget');
      final bloc = platformWidgetFeaturePackage.bloc(name: 'Counter');
      expect(bloc.projectName, 'test_project');
      expect(bloc.platform, Platform.web);
      expect(bloc.name, 'Counter');
      expect(
        bloc.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_widget',
      );
      expect(bloc.featureName, 'foo_widget');
      final cubit = platformWidgetFeaturePackage.cubit(name: 'Counter');
      expect(cubit.projectName, 'test_project');
      expect(cubit.platform, Platform.web);
      expect(cubit.name, 'Counter');
      expect(
        cubit.path,
        '/path/to/project/packages/test_project/test_project_web/test_project_web_features/test_project_web_foo_widget',
      );
      expect(cubit.featureName, 'foo_widget');
    });

    test(
      'generate',
      withMockFs(
        () async {
          final generator = MockMasonGenerator();
          final generatorBuilder = MockMasonGeneratorBuilder(
            generator: generator,
          );
          generatorOverrides = generatorBuilder;
          final platformWidgetFeaturePackage = _getPlatformWidgetFeaturePackage(
            projectName: 'test_project',
            path: '/path/to/platform_widget_feature_package',
            platform: Platform.web,
            name: 'foo',
          );

          await platformWidgetFeaturePackage.generate(
            description: 'Foo Widget Feature',
          );

          verifyInOrder([
            () => generatorBuilder(platformWidgetFeaturePackageBundle),
            () => generator.generate(
                  any(
                    that: isA<DirectoryGeneratorTarget>().having(
                      (e) => e.dir.path,
                      'path',
                      '/path/to/platform_widget_feature_package',
                    ),
                  ),
                  vars: <String, dynamic>{
                    'name': 'foo_widget',
                    'description': 'Foo Widget Feature',
                    'project_name': 'test_project',
                    'platform': 'web',
                    'android': false,
                    'ios': false,
                    'linux': false,
                    'macos': false,
                    'web': true,
                    'windows': false,
                    'mobile': false,
                  },
                ),
          ]);
        },
      ),
    );
  });
}

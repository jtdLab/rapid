part of '../../project.dart';

abstract class PlatformFeaturePackage extends DartPackage {
  PlatformFeaturePackage({
    required this.projectName,
    required this.platform,
    required String path,
    required this.name,
    required this.bloc,
    required this.cubit,
  }) : super(path);

  final String projectName;

  final Platform platform;

  final String name;

  DartFile get barrelFile => DartFile(
      p.join(path, 'lib', '${projectName}_${platform.name}_$name.dart'));

  DartFile get applicationBarrelFile =>
      DartFile(p.join(path, 'lib', 'src', 'application', 'application.dart'));

  final Bloc Function({required String name}) bloc;

  final Cubit Function({required String name}) cubit;
}

abstract class PlatformRoutableFeaturePackage extends PlatformFeaturePackage {
  PlatformRoutableFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required super.name,
    required super.bloc,
    required super.cubit,
    required this.navigatorImplementation,
  });

  final NavigatorImplementation navigatorImplementation;
}

class PlatformAppFeaturePackage extends PlatformFeaturePackage {
  PlatformAppFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required super.bloc,
    required super.cubit,
  }) : super(name: 'app');

  factory PlatformAppFeaturePackage.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_features',
      '${projectName}_${platform.name}_app',
    );
    bloc({required String name}) => Bloc(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: 'app',
        );
    cubit({required String name}) => Cubit(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: 'app',
        );

    return PlatformAppFeaturePackage(
      projectName: projectName,
      path: path,
      platform: platform,
      bloc: bloc,
      cubit: cubit,
    );
  }

  Future<void> generate() async {
    await mason.generate(
      bundle: platformAppFeaturePackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'platform': platform.name,
      },
    );
  }
}

class PlatformPageFeaturePackage extends PlatformRoutableFeaturePackage {
  PlatformPageFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required String name,
    required super.bloc,
    required super.cubit,
    required super.navigatorImplementation,
  }) : super(name: '${name}_page');

  factory PlatformPageFeaturePackage.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
    required String name,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_features',
      '${projectName}_${platform.name}_${name}_page',
    );
    bloc({required String name}) => Bloc(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${name}_page',
        );
    cubit({required String name}) => Cubit(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${name}_page',
        );
    final navigatorImplementation = NavigatorImplementation(
      projectName: projectName,
      platform: platform,
      path: path,
      name: name,
    );

    return PlatformPageFeaturePackage(
      projectName: projectName,
      path: path,
      platform: platform,
      name: name,
      bloc: bloc,
      cubit: cubit,
      navigatorImplementation: navigatorImplementation,
    );
  }

  Future<void> generate({String? description}) async {
    await mason.generate(
      bundle: platformPageFeaturePackageBundle,
      target: this,
      vars: <String, dynamic>{
        'name': name, // TODO this is foo_page shouldnt it just be foo?
        'description': description, // TODO default inside template
        'project_name': projectName,
        'platform': platform.name,
      },
    );
  }
}

class PlatformFlowFeaturePackage extends PlatformRoutableFeaturePackage {
  PlatformFlowFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required String name,
    required super.bloc,
    required super.cubit,
    required super.navigatorImplementation,
  }) : super(name: '${name}_flow');

  factory PlatformFlowFeaturePackage.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
    required String name,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_features',
      '${projectName}_${platform.name}_${name}_flow',
    );
    bloc({required String name}) => Bloc(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${name}_flow',
        );
    cubit({required String name}) => Cubit(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${name}_flow',
        );
    final navigatorImplementation = NavigatorImplementation(
      projectName: projectName,
      platform: platform,
      path: path,
      name: name,
    );

    return PlatformFlowFeaturePackage(
      projectName: projectName,
      path: path,
      platform: platform,
      name: name,
      bloc: bloc,
      cubit: cubit,
      navigatorImplementation: navigatorImplementation,
    );
  }

  Future<void> generate({String? description}) async {
    await mason.generate(
      bundle: platformFlowFeaturePackageBundle,
      target: this,
      vars: <String, dynamic>{
        'name': name,
        'description': description,
        'project_name': projectName,
        'platform': platform.name,
      },
    );
  }
}

class PlatformTabFlowFeaturePackage extends PlatformRoutableFeaturePackage {
  PlatformTabFlowFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required String name,
    required super.bloc,
    required super.cubit,
    required super.navigatorImplementation,
  }) : super(name: '${name}_tab_flow');

  factory PlatformTabFlowFeaturePackage.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
    required String name,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_features',
      '${projectName}_${platform.name}_${name}_tab_flow',
    );
    bloc({required String name}) => Bloc(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${name}_tab_flow',
        );
    cubit({required String name}) => Cubit(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${name}_tab_flow',
        );
    final navigatorImplementation = NavigatorImplementation(
      projectName: projectName,
      platform: platform,
      path: path,
      name: name,
    );

    return PlatformTabFlowFeaturePackage(
      projectName: projectName,
      path: path,
      platform: platform,
      name: name,
      bloc: bloc,
      cubit: cubit,
      navigatorImplementation: navigatorImplementation,
    );
  }

  Future<void> generate({
    String? description,
    required Set<String> subFeatures,
  }) async {
    await mason.generate(
      bundle: platformTabFlowFeaturePackageBundle,
      target: this,
      vars: <String, dynamic>{
        'name': name,
        'description': description,
        'project_name': projectName,
        'platform': platform.name,
        'subRoutes': subFeatures
            .mapIndexed((i, e) => {'name': e.pascalCase, 'isFirst': i == 0})
            .toList(), // TODO needed?
      },
    );
  }
}

class PlatformWidgetFeaturePackage extends PlatformFeaturePackage {
  PlatformWidgetFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required String name,
    required super.bloc,
    required super.cubit,
  }) : super(name: '${name}_widget');

  factory PlatformWidgetFeaturePackage.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
    required String name,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_features',
      '${projectName}_${platform.name}_${name}_widget',
    );
    bloc({required String name}) => Bloc(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${name}_widget',
        );
    cubit({required String name}) => Cubit(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${name}_widget',
        );

    return PlatformWidgetFeaturePackage(
      projectName: projectName,
      path: path,
      platform: platform,
      name: name,
      bloc: bloc,
      cubit: cubit,
    );
  }

  Future<void> generate({String? description}) async {
    await mason.generate(
      bundle: platformWidgetFeaturePackageBundle,
      target: this,
      vars: <String, dynamic>{
        'name': name,
        'description': description,
        'project_name': projectName,
        'platform': platform.name,
      },
    );
  }
}
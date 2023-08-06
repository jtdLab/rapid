part of '../project.dart';

abstract class PlatformFeaturePackage extends DartPackage
    implements Comparable<PlatformFeaturePackage> {
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
        p.join(path, 'lib', '${projectName}_${platform.name}_$name.dart'),
      );

  Directory get applicationDir =>
      Directory(p.join(path, 'lib', 'src', 'application'));

  // TODO move to application dir?
  DartFile get applicationBarrelFile =>
      DartFile(p.join(path, 'lib', 'src', 'application', 'application.dart'));

  final Bloc Function({required String name}) bloc;

  final Cubit Function({required String name}) cubit;

  @override
  int compareTo(PlatformFeaturePackage other) {
    return name.compareTo(other.name);
  }

  @override
  bool operator ==(Object other) =>
      other is PlatformFeaturePackage &&
      projectName == other.projectName &&
      platform == other.platform &&
      name == other.name;

  @override
  int get hashCode =>
      Object.hash(projectName.hashCode, platform.hashCode, name.hashCode);
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
    Bloc bloc({required String name}) => Bloc(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: 'app',
        );
    Cubit cubit({required String name}) => Cubit(
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
        ...platformVars(platform),
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
    final selfName = name;
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_features',
      '${projectName}_${platform.name}_${selfName}_page',
    );
    Bloc bloc({required String name}) => Bloc(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${selfName}_page',
        );
    Cubit cubit({required String name}) => Cubit(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${selfName}_page',
        );
    final navigatorImplementation = NavigatorImplementation(
      projectName: projectName,
      platform: platform,
      path: path,
      name: '${selfName}_page',
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
        ...platformVars(platform),
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
    final selfName = name;
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_features',
      '${projectName}_${platform.name}_${selfName}_flow',
    );
    Bloc bloc({required String name}) => Bloc(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${selfName}_flow',
        );
    Cubit cubit({required String name}) => Cubit(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${selfName}_flow',
        );
    final navigatorImplementation = NavigatorImplementation(
      projectName: projectName,
      platform: platform,
      path: path,
      name: '${selfName}_flow',
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
        ...platformVars(platform),
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
    final selfName = name;
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_features',
      '${projectName}_${platform.name}_${selfName}_tab_flow',
    );
    Bloc bloc({required String name}) => Bloc(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${selfName}_tab_flow',
        );
    Cubit cubit({required String name}) => Cubit(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${selfName}_tab_flow',
        );
    final navigatorImplementation = NavigatorImplementation(
      projectName: projectName,
      platform: platform,
      path: path,
      name: '${selfName}_tab_flow',
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
    required Set<String> subFeatures,
    String? description,
  }) async {
    await mason.generate(
      bundle: platformTabFlowFeaturePackageBundle,
      target: this,
      vars: <String, dynamic>{
        'name': name,
        'description': description,
        'project_name': projectName,
        ...platformVars(platform),
        'subRoutes': subFeatures
            .mapIndexed((i, e) => {'name': e.pascalCase, 'isFirst': i == 0})
            .toList(), // TODO needed at all? needed to upper case?
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
    final selfName = name;
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_features',
      '${projectName}_${platform.name}_${selfName}_widget',
    );
    Bloc bloc({required String name}) => Bloc(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${selfName}_widget',
        );
    Cubit cubit({required String name}) => Cubit(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
          featureName: '${selfName}_widget',
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
        ...platformVars(platform),
      },
    );
  }
}

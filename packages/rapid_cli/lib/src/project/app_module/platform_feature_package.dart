part of '../project.dart';

/// {@template platform_feature_package}
/// Base class for:
///
///  * [PlatformRoutableFeaturePackage]
///
///  * [PlatformAppFeaturePackage]
///
///  * [PlatformWidgetFeaturePackage]
/// {@endtemplate}
abstract class PlatformFeaturePackage extends DartPackage
    implements Comparable<PlatformFeaturePackage> {
  /// {@macro platform_feature_package}
  PlatformFeaturePackage({
    required this.projectName,
    required this.platform,
    required String path,
    required this.name,
    required this.bloc,
    required this.cubit,
  }) : super(path);

  /// The name of the project this package is part of.
  final String projectName;

  /// The platform.
  final Platform platform;

  /// The name of this feature.
  final String name;

  /// The `lib/<project-name>_<platform>_<name>.dart` file.
  DartFile get barrelFile => DartFile(
        p.join(path, 'lib', '${projectName}_${platform.name}_$name.dart'),
      );

  /// The `lib/src/application` directory.
  Directory get applicationDir =>
      Directory(p.join(path, 'lib', 'src', 'application'));

  /// The `lib/src/application/application.dart` file.
  DartFile get applicationBarrelFile =>
      DartFile(p.join(path, 'lib', 'src', 'application', 'application.dart'));

  /// The bloc builder.
  final Bloc Function({required String name}) bloc;

  /// The cubit builder.
  final Cubit Function({required String name}) cubit;

  @override
  int compareTo(PlatformFeaturePackage other) {
    return name.compareTo(other.name);
  }
}

/// {@template platform_routable_feature_package}
/// Base class for:
///
///  * [PlatformPageFeaturePackage]
///
///  * [PlatformFlowFeaturePackage]
///
///  * [PlatformTabFlowFeaturePackage]
/// {@endtemplate}
abstract class PlatformRoutableFeaturePackage extends PlatformFeaturePackage {
  /// {@macro platform_routable_feature_package}
  PlatformRoutableFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required super.name,
    required super.bloc,
    required super.cubit,
    required this.navigatorImplementation,
  });

  /// The navigator implementation of this package.
  final NavigatorImplementation navigatorImplementation;
}

/// {@template platform_app_feature_package}
/// Abstraction of a platform app feature package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class PlatformAppFeaturePackage extends PlatformFeaturePackage {
  /// {@macro platform_app_feature_package}
  PlatformAppFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required super.bloc,
    required super.cubit,
  }) : super(name: 'app');

  /// Returns a [PlatformAppFeaturePackage] with [platform] from
  /// given [projectName] and [projectPath].
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

  /// Generate this package on disk.
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

/// {@template platform_page_feature_package}
/// Abstraction of a platform page feature package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class PlatformPageFeaturePackage extends PlatformRoutableFeaturePackage {
  /// {@macro platform_page_feature_package}
  PlatformPageFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required String name,
    required super.bloc,
    required super.cubit,
    required super.navigatorImplementation,
  }) : super(name: '${name}_page');

  /// Returns a [PlatformPageFeaturePackage] with [platform] and [name] from
  /// given [projectName] and [projectPath].
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

  /// Generate this package on disk.
  Future<void> generate({String? description}) async {
    await mason.generate(
      bundle: platformPageFeaturePackageBundle,
      target: this,
      vars: <String, dynamic>{
        'name': name, // TODO(jtdLab): this is foo_page shouldnt it just be foo?
        'description': description, // TODO(jtdLab): default inside template
        'project_name': projectName,
        ...platformVars(platform),
      },
    );
  }
}

/// {@template platform_flow_feature_package}
/// Abstraction of a platform flow feature package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class PlatformFlowFeaturePackage extends PlatformRoutableFeaturePackage {
  /// {@macro platform_flow_feature_package}
  PlatformFlowFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required String name,
    required super.bloc,
    required super.cubit,
    required super.navigatorImplementation,
  }) : super(name: '${name}_flow');

  /// Returns a [PlatformFlowFeaturePackage] with [platform] and [name] from
  /// given [projectName] and [projectPath].
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

  /// Generate this package on disk.
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

/// {@template platform_tab_flow_feature_package}
/// Abstraction of a platform tab flow feature package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class PlatformTabFlowFeaturePackage extends PlatformRoutableFeaturePackage {
  /// {@macro platform_tab_flow_feature_package}
  PlatformTabFlowFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required String name,
    required super.bloc,
    required super.cubit,
    required super.navigatorImplementation,
  }) : super(name: '${name}_tab_flow');

  /// Returns a [PlatformTabFlowFeaturePackage] with [platform] and [name] from
  /// given [projectName] and [projectPath].
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

  /// Generate this package on disk.
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
            .toList(), // TODO(jtdLab): needed at all? needed to upper case?
      },
    );
  }
}

/// {@template platform_widget_feature_package}
/// Abstraction of a platform widget feature package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class PlatformWidgetFeaturePackage extends PlatformFeaturePackage {
  /// {@macro platform_widget_feature_package}
  PlatformWidgetFeaturePackage({
    required super.projectName,
    required super.platform,
    required super.path,
    required String name,
    required super.bloc,
    required super.cubit,
  }) : super(name: '${name}_widget');

  /// Returns a [PlatformWidgetFeaturePackage] with [platform] and [name] from
  /// given [projectName] and [projectPath].
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

  /// Generate this package on disk.
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

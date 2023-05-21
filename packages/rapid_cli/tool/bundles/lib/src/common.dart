const platforms = ['android', 'ios', 'linux', 'macos', 'web', 'windows'];
const dart = DartDependency('3.0.0', '4.0.0');
const flutter = FlutterDependency('3.10.0');
final packages = [
  PackageDependency('auto_route', '7.2.0'),
  PackageDependency('auto_route_generator', '7.1.1'),
  PackageDependency('bloc_concurrency', '0.2.2'),
  PackageDependency('bloc_test', '9.1.2'),
  PackageDependency('bloc', '8.1.2'),
  PackageDependency('build_runner', '2.4.4'),
  PackageDependency('cupertino_icons', '1.0.5'),
  PackageDependency('dartz', '0.10.1'),
  PackageDependency('faker', '2.1.0'),
  PackageDependency('fluent_ui', '4.6.1'),
  PackageDependency('flutter_bloc', '8.1.3'),
  PackageDependency('flutter_gen_runner', '5.3.1'),
  PackageDependency('flutter_lints', '2.0.1'),
  PackageDependency('freezed_annotation', '2.2.0'),
  PackageDependency('freezed', '2.3.4'),
  PackageDependency('get_it', '7.6.0'),
  PackageDependency('injectable_generator', '2.1.5'),
  PackageDependency('injectable', '2.1.1'),
  PackageDependency('json_annotation', '4.8.1'),
  PackageDependency('json_serializable', '6.7.0'),
  PackageDependency('lints', '2.1.0'),
  PackageDependency('macos_ui', '1.12.2'),
  PackageDependency('melos', '3.0.1'),
  PackageDependency('meta', '1.9.1'),
  PackageDependency('mocktail', '0.3.0'),
  PackageDependency('test', '1.24.3'),
  PackageDependency('theme_tailor_annotation', '2.0.0'),
  PackageDependency('theme_tailor', '2.0.0'),
  PackageDependency('url_strategy', '0.2.0'),
  PackageDependency('yaru_icons', '1.0.4'),
  PackageDependency('yaru', '0.7.0'),
];

const arbFile = Template(
  'arb_file',
  'templates/arb_file',
  'lib/src/project/platform_directory/platform_features_directory/platform_feature_package',
);
const bloc = Template(
  'bloc',
  'templates/bloc',
  'lib/src/project/platform_directory/platform_features_directory/platform_feature_package',
);
const cubit = Template(
  'cubit',
  'templates/cubit',
  'lib/src/project/platform_directory/platform_features_directory/platform_feature_package',
);
const dataTransferObject = Template(
  'data_transfer_object',
  'templates/data_transfer_object',
  'lib/src/project/infrastructure_dir/infrastructure_package',
);
const diPackage = PackageTemplate(
  'di_package',
  'templates/di_package',
  'lib/src/project/di_package',
);
const domainPackage = PackageTemplate(
  'domain_package',
  'templates/domain_package',
  'lib/src/project/domain_dir/domain_package',
);
const entity = Template(
  'entity',
  'templates/entity',
  'lib/src/project/domain_directory/domain_package',
);
const infrastructurePackage = PackageTemplate(
  'infrastructure_package',
  'templates/infrastructure_package',
  'lib/src/project/infrastructure_directory/infrastructure_package',
);
const loggingPackage = PackageTemplate(
  'logging_package',
  'templates/logging_package',
  'lib/src/project/logging_package',
);
const navigator = Template(
  'navigator',
  'templates/navigator',
  'lib/src/project/platform_directory/platform_navigation_package',
);
const navigatorImplementation = Template(
  'navigator_implementation',
  'templates/navigator_implementation',
  'lib/src/project/platform_directory/platform_features_directory/platform_feature_package',
);
const platformAppFeaturePackage = PlatformPackageTemplate(
  'platform_app_feature_package',
  'templates/platform_app_feature_package',
  'lib/src/project/platform_directory/platform_features_directory/platform_feature_package',
);
const platformFeaturePackage = PlatformNamedPackageTemplate(
  'platform_feature_package',
  'templates/platform_feature_package',
  'lib/src/project/platform_directory/platform_features_directory/platform_feature_package',
);
const platformNavigationPackage = PlatformPackageTemplate(
  'platform_navigation_package',
  'templates/platform_navigation_package',
  'lib/src/project/platform_directory/platform_navigation_package',
);
const platformRootPackage = PlatformPackageTemplate(
  'platform_root_package',
  'templates/platform_root_package',
  'lib/src/project/platform_directory/platform_root_package',
);
const serviceImplementation = Template(
  'service_implementation',
  'templates/service_implementation',
  'lib/src/project/infrastructure_dir/infrastructure_package',
);
const platformUiPackage = PlatformPackageTemplate(
  'platform_ui_package',
  'templates/platform_ui_package',
  'lib/src/project/platform_ui_package',
);
const project = PackageTemplate(
  'project',
  'templates/project',
  'lib/src/project',
);
const androidNativeDirectory = Template(
  'android_native_directory',
  'templates/platform_root_package/android_native_directory',
  'lib/src/project/platform_directory/platform_root_package/platform_native_directory',
);
const iosNativeDirectory = Template(
  'ios_native_directory',
  'templates/platform_root_package/ios_native_directory',
  'lib/src/project/platform_directory/platform_root_package/platform_native_directory',
);
const linuxNativeDirectory = Template(
  'linux_native_directory',
  'templates/platform_root_package/linux_native_directory',
  'lib/src/project/platform_directory/platform_root_package/platform_native_directory',
);
const macosNativeDirectory = Template(
  'macos_native_directory',
  'templates/platform_root_package/macos_native_directory',
  'lib/src/project/platform_directory/platform_root_package/platform_native_directory',
);
const webNativeDirectory = Template(
  'web_native_directory',
  'templates/platform_root_package/web_native_directory',
  'lib/src/project/platform_directory/platform_root_package/platform_native_directory',
);
const windowsNativeDirectory = Template(
  'windows_native_directory',
  'templates/platform_root_package/windows_native_directory',
  'lib/src/project/platform_directory/platform_root_package/platform_native_directory',
);
const serviceInterface = Template(
  'service_interface',
  'templates/service_interface',
  'lib/src/project/domain_dir/domain_package',
);
const uiPackage = PackageTemplate(
  'ui_package',
  'templates/ui_package',
  'lib/src/project/ui_package',
);
const valueObject = Template(
  'value_object',
  'templates/value_object',
  'lib/src/project/domain_dir/domain_package',
);
const widget = Template(
  'widget',
  'templates/widget',
  'lib/src/project/platform_ui_package',
);

final templates = [
  arbFile,
  bloc,
  cubit,
  dataTransferObject,
  diPackage,
  domainPackage,
  entity,
  infrastructurePackage,
  loggingPackage,
  navigator,
  navigatorImplementation,
  platformAppFeaturePackage,
  platformFeaturePackage,
  platformNavigationPackage,
  platformRootPackage,
  serviceImplementation,
  platformUiPackage,
  project,
  androidNativeDirectory,
  iosNativeDirectory,
  linuxNativeDirectory,
  macosNativeDirectory,
  webNativeDirectory,
  windowsNativeDirectory,
  serviceInterface,
  uiPackage,
  valueObject,
  widget,
];

class DartDependency {
  final String minVersion;
  final String maxVersion;

  const DartDependency(this.minVersion, this.maxVersion);

  String toYaml() => 'sdk: ">=$minVersion <$maxVersion"';
}

class FlutterDependency {
  final String minVersion;

  const FlutterDependency(this.minVersion);

  String toYaml() => 'flutter: ">=$minVersion"';
}

class PackageDependency {
  final String name;
  final String version;

  PackageDependency(this.name, this.version);

  String toYaml() => '$name: ^$version';
}

class Template {
  /// The name specified in 'brick.yaml'.
  final String name;

  /// The path relative to `rapid_cli`.
  final String path;

  /// The path where the bundled templates will be located in the git repo relative to `rapid_cli`.
  final String repoPath;

  const Template(this.name, this.path, this.repoPath);

  bool operator ==(o) => o is Template && name == o.name;
  int get hashCode => name.hashCode;
}

class PackageTemplate extends Template {
  const PackageTemplate(super.name, super.path, super.repoPath);
}

class PlatformPackageTemplate extends PackageTemplate {
  const PlatformPackageTemplate(super.name, super.path, super.repoPath);
}

class PlatformNamedPackageTemplate extends PackageTemplate {
  const PlatformNamedPackageTemplate(super.name, super.path, super.repoPath);
}

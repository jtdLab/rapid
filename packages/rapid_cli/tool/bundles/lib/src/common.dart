// TODO maybe rename to targets
const platforms = [
  'android',
  'ios',
  'linux',
  'macos',
  'web',
  'windows',
  'mobile'
];
const dart = DartDependency('3.0.0', '4.0.0');
const flutter = FlutterDependency('3.10.0');
final packages = [
  PackageDependency('alchemist', '0.6.1'),
  PackageDependency('auto_route', '7.7.1'),
  PackageDependency('auto_route_generator', '7.2.0'),
  PackageDependency('bloc_concurrency', '0.2.2'),
  PackageDependency('bloc_test', '9.1.3'),
  PackageDependency('bloc', '8.1.2'),
  PackageDependency('build_runner', '2.4.5'),
  PackageDependency('cupertino_icons', '1.0.5'),
  PackageDependency('dartz', '0.10.1'),
  PackageDependency('faker', '2.1.0'),
  PackageDependency('fluent_ui', '4.6.2'),
  PackageDependency('flutter_bloc', '8.1.3'),
  PackageDependency('flutter_gen_runner', '5.3.1'),
  PackageDependency('flutter_lints', '2.0.1'),
  PackageDependency('freezed_annotation', '2.2.0'),
  PackageDependency('freezed', '2.3.5'),
  PackageDependency('get_it', '7.6.0'),
  PackageDependency('injectable_generator', '2.1.6'),
  PackageDependency('injectable', '2.1.2'),
  PackageDependency('json_annotation', '4.8.1'),
  PackageDependency('json_serializable', '6.7.0'),
  PackageDependency('lints', '2.1.0'),
  PackageDependency('macos_ui', '1.12.2'),
  PackageDependency('melos', '3.1.1'),
  PackageDependency('meta', '1.9.1'),
  PackageDependency('mocktail', '0.3.0'),
  PackageDependency('test', '1.24.3'),
  PackageDependency('theme_tailor_annotation', '2.0.0'),
  PackageDependency('theme_tailor', '2.0.0'),
  PackageDependency('url_strategy', '0.2.0'),
  PackageDependency('yaru_icons', '1.0.4'),
  PackageDependency('yaru', '0.8.0'),
];

const androidNativeDirectory = Template(
  'android_native_directory',
  'templates/platform_root_package/android_native_directory',
);
const bloc = Template(
  'bloc',
  'templates/bloc',
);
const cubit = Template(
  'cubit',
  'templates/cubit',
);
const dataTransferObject = Template(
  'data_transfer_object',
  'templates/data_transfer_object',
);
const diPackage = PackageTemplate(
  'di_package',
  'templates/di_package',
);
const domainPackage = PackageTemplate(
  'domain_package',
  'templates/domain_package',
);
const entity = Template(
  'entity',
  'templates/entity',
);
const infrastructurePackage = PackageTemplate(
  'infrastructure_package',
  'templates/infrastructure_package',
);
const iosNativeDirectory = Template(
  'ios_native_directory',
  'templates/platform_root_package/ios_native_directory',
);
const linuxNativeDirectory = Template(
  'linux_native_directory',
  'templates/platform_root_package/linux_native_directory',
);
const loggingPackage = PackageTemplate(
  'logging_package',
  'templates/logging_package',
);
const macosNativeDirectory = Template(
  'macos_native_directory',
  'templates/platform_root_package/macos_native_directory',
);
const navigatorImplementation = Template(
  'navigator_implementation',
  'templates/navigator_implementation',
);
const navigatorInterface = Template(
  'navigator_interface',
  'templates/navigator_interface',
);
const platformAppFeaturePackage = PlatformPackageTemplate(
  'platform_app_feature_package',
  'templates/platform_app_feature_package',
);
const platformFlowFeaturePackage = PlatformNamedPackageTemplate(
  'platform_flow_feature_package',
  'templates/platform_flow_feature_package',
);
const platformLocalizationPackage = PlatformPackageTemplate(
  'platform_localization_package',
  'templates/platform_localization_package',
);
const platformNavigationPackage = PlatformPackageTemplate(
  'platform_navigation_package',
  'templates/platform_navigation_package',
);
const platformPageFeaturePackage = PlatformNamedPackageTemplate(
  'platform_page_feature_package',
  'templates/platform_page_feature_package',
);
const platformRootPackage = PlatformPackageTemplate(
  'platform_root_package',
  'templates/platform_root_package',
);
const platformTabFlowFeaturePackage = PlatformNamedPackageTemplate(
  'platform_tab_flow_feature_package',
  'templates/platform_tab_flow_feature_package',
);
const platformUiPackage = PlatformPackageTemplate(
  'platform_ui_package',
  'templates/platform_ui_package',
);
const platformWidgetFeaturePackage = PlatformNamedPackageTemplate(
  'platform_widget_feature_package',
  'templates/platform_widget_feature_package',
);
const rootPackage = PackageTemplate(
  'root_package',
  'templates/root_package',
);
const serviceImplementation = Template(
  'service_implementation',
  'templates/service_implementation',
);
const serviceInterface = Template(
  'service_interface',
  'templates/service_interface',
);
const themedWidget = Template(
  'themed_widget',
  'templates/themed_widget',
);
const uiPackage = PackageTemplate(
  'ui_package',
  'templates/ui_package',
);
const valueObject = Template(
  'value_object',
  'templates/value_object',
);
const webNativeDirectory = Template(
  'web_native_directory',
  'templates/platform_root_package/web_native_directory',
);
const widget = Template(
  'widget',
  'templates/widget',
);
const windowsNativeDirectory = Template(
  'windows_native_directory',
  'templates/platform_root_package/windows_native_directory',
);

final templates = [
  androidNativeDirectory,
  bloc,
  cubit,
  dataTransferObject,
  diPackage,
  domainPackage,
  entity,
  infrastructurePackage,
  iosNativeDirectory,
  linuxNativeDirectory,
  loggingPackage,
  macosNativeDirectory,
  navigatorImplementation,
  navigatorInterface,
  platformAppFeaturePackage,
  platformFlowFeaturePackage,
  platformLocalizationPackage,
  platformNavigationPackage,
  platformPageFeaturePackage,
  platformRootPackage,
  platformTabFlowFeaturePackage,
  platformUiPackage,
  platformWidgetFeaturePackage,
  rootPackage,
  serviceImplementation,
  serviceInterface,
  themedWidget,
  uiPackage,
  valueObject,
  webNativeDirectory,
  widget,
  windowsNativeDirectory
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

  const Template(this.name, this.path);

  bool operator ==(o) => o is Template && name == o.name;
  int get hashCode => name.hashCode;
}

class PackageTemplate extends Template {
  const PackageTemplate(super.name, super.path);
}

class PlatformPackageTemplate extends PackageTemplate {
  const PlatformPackageTemplate(super.name, super.path);
}

class PlatformNamedPackageTemplate extends PackageTemplate {
  const PlatformNamedPackageTemplate(super.name, super.path);
}

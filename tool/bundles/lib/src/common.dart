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
  PackageDependency('auto_route', '7.8.0'),
  PackageDependency('auto_route_generator', '7.3.0'),
  PackageDependency('bloc_concurrency', '0.2.2'),
  PackageDependency('bloc_test', '9.1.4'),
  PackageDependency('bloc', '8.1.2'),
  PackageDependency('build_runner', '2.4.6'),
  PackageDependency('build_verify', '3.1.0'),
  PackageDependency('cupertino_icons', '1.0.5'),
  PackageDependency('faker', '2.1.0'),
  PackageDependency('fluent_ui', '4.7.1'),
  PackageDependency('flutter_bloc', '8.1.3'),
  PackageDependency('flutter_gen_runner', '5.3.1'),
  PackageDependency('flutter_lints', '2.0.2'),
  PackageDependency('freezed_annotation', '2.4.1'),
  PackageDependency('freezed', '2.4.1'),
  PackageDependency('get_it', '7.6.0'),
  PackageDependency('injectable_generator', '2.1.6'),
  PackageDependency('injectable', '2.1.2'),
  PackageDependency('json_annotation', '4.8.1'),
  PackageDependency('json_serializable', '6.7.1'),
  PackageDependency('lints', '2.1.1'),
  PackageDependency('macos_ui', '2.0.0'),
  PackageDependency('melos', '3.1.1'),
  PackageDependency('meta', '1.9.1'),
  PackageDependency('mocktail', '1.0.0'),
  PackageDependency('test', '1.24.5'),
  PackageDependency('theme_tailor_annotation', '2.0.0'),
  PackageDependency('theme_tailor', '2.0.0'),
  PackageDependency('url_strategy', '0.2.0'),
  PackageDependency('yaru_icons', '2.1.0'),
  PackageDependency('yaru', '0.9.0'),
];

const androidNativeDirectory = Template(
  'android_native_directory',
  'bricks/platform_root_package/android_native_directory',
);
const bloc = Template(
  'bloc',
  'bricks/bloc',
);
const cubit = Template(
  'cubit',
  'bricks/cubit',
);
const dataTransferObject = Template(
  'data_transfer_object',
  'bricks/data_transfer_object',
);
const diPackage = PackageTemplate(
  'di_package',
  'bricks/di_package',
);
const domainPackage = PackageTemplate(
  'domain_package',
  'bricks/domain_package',
);
const entity = Template(
  'entity',
  'bricks/entity',
);
const infrastructurePackage = PackageTemplate(
  'infrastructure_package',
  'bricks/infrastructure_package',
);
const iosNativeDirectory = Template(
  'ios_native_directory',
  'bricks/platform_root_package/ios_native_directory',
);
const linuxNativeDirectory = Template(
  'linux_native_directory',
  'bricks/platform_root_package/linux_native_directory',
);
const loggingPackage = PackageTemplate(
  'logging_package',
  'bricks/logging_package',
);
const macosNativeDirectory = Template(
  'macos_native_directory',
  'bricks/platform_root_package/macos_native_directory',
);
const navigatorImplementation = Template(
  'navigator_implementation',
  'bricks/navigator_implementation',
);
const navigatorInterface = Template(
  'navigator_interface',
  'bricks/navigator_interface',
);
const platformAppFeaturePackage = PlatformPackageTemplate(
  'platform_app_feature_package',
  'bricks/platform_app_feature_package',
);
const platformFlowFeaturePackage = PlatformNamedPackageTemplate(
  'platform_flow_feature_package',
  'bricks/platform_flow_feature_package',
);
const platformLocalizationPackage = PlatformPackageTemplate(
  'platform_localization_package',
  'bricks/platform_localization_package',
);
const platformNavigationPackage = PlatformPackageTemplate(
  'platform_navigation_package',
  'bricks/platform_navigation_package',
);
const platformPageFeaturePackage = PlatformNamedPackageTemplate(
  'platform_page_feature_package',
  'bricks/platform_page_feature_package',
);
const platformRootPackage = PlatformPackageTemplate(
  'platform_root_package',
  'bricks/platform_root_package',
);
const platformTabFlowFeaturePackage = PlatformNamedPackageTemplate(
  'platform_tab_flow_feature_package',
  'bricks/platform_tab_flow_feature_package',
);
const platformUiPackage = PlatformPackageTemplate(
  'platform_ui_package',
  'bricks/platform_ui_package',
);
const platformWidgetFeaturePackage = PlatformNamedPackageTemplate(
  'platform_widget_feature_package',
  'bricks/platform_widget_feature_package',
);
const rootPackage = PackageTemplate(
  'root_package',
  'bricks/root_package',
);
const serviceImplementation = Template(
  'service_implementation',
  'bricks/service_implementation',
);
const serviceInterface = Template(
  'service_interface',
  'bricks/service_interface',
);
const themedWidget = Template(
  'themed_widget',
  'bricks/themed_widget',
);
const uiPackage = PackageTemplate(
  'ui_package',
  'bricks/ui_package',
);
const valueObject = Template(
  'value_object',
  'bricks/value_object',
);
const webNativeDirectory = Template(
  'web_native_directory',
  'bricks/platform_root_package/web_native_directory',
);
const widget = Template(
  'widget',
  'bricks/widget',
);
const windowsNativeDirectory = Template(
  'windows_native_directory',
  'bricks/platform_root_package/windows_native_directory',
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

  /// The path relative to root.
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

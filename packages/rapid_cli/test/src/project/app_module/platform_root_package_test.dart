import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

IosRootPackage _getIosRootPackage({
  String? projectName,
  String? path,
  IosNativeDirectory? nativeDirectory,
}) {
  return IosRootPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    nativeDirectory: nativeDirectory ??
        IosNativeDirectory.resolve(
          projectName: 'test_project',
          platformRootPackagePath: '/path/to/ios_native_directory',
        ),
  );
}

MacosRootPackage _getMacosRootPackage({
  String? projectName,
  String? path,
  MacosNativeDirectory? nativeDirectory,
}) {
  return MacosRootPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    nativeDirectory: nativeDirectory ??
        MacosNativeDirectory.resolve(
          projectName: 'test_project',
          platformRootPackagePath: '/path/to/macos_native_directory',
        ),
  );
}

NoneIosRootPackage _getNoneIosRootPackage({
  String? projectName,
  String? path,
  Platform? platform,
  NoneIosNativeDirectory? nativeDirectory,
}) {
  return NoneIosRootPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    platform: platform ?? Platform.android,
    nativeDirectory: nativeDirectory ??
        NoneIosNativeDirectory.resolve(
          projectName: 'test_project',
          platformRootPackagePath: '/path/to/none_ios_native_directory',
          platform: platform ?? Platform.android,
        ),
  );
}

MobileRootPackage _getMobileRootPackage({
  String? projectName,
  String? path,
  NoneIosNativeDirectory? androidNativeDirectory,
  IosNativeDirectory? iosNativeDirectory,
}) {
  return MobileRootPackage(
    projectName: projectName ?? 'projectName',
    path: path ?? 'path',
    androidNativeDirectory: androidNativeDirectory ??
        NoneIosNativeDirectory.resolve(
          projectName: 'test_project',
          platformRootPackagePath: '/path/to/android_native_directory',
          platform: Platform.android,
        ),
    iosNativeDirectory: iosNativeDirectory ??
        IosNativeDirectory.resolve(
          projectName: 'test_project',
          platformRootPackagePath: '/path/to/ios_native_directory',
        ),
  );
}

void main() {
  // TODO
  final hund = Hund();
}

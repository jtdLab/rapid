import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/plist_file.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';

import '../platform_root_package.dart';
import 'platform_native_directory_impl.dart';

// TODO: consider IosNativeDirectory add/remove lang
// TODO: consider InfoPlistFile add/remove lang

typedef _PlatformNativeDirectoryBuilder<R extends PlatformNativeDirectory,
        T extends PlatformRootPackage>
    = R Function({required T rootPackage});

/// {@template platform_native_directory}
/// Base class for an abstraction of a platform native directory of a platform root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>/<platform>`
/// {@endtemplate}
abstract class PlatformNativeDirectory
    implements Directory, OverridableGenerator {}

/// Signature of [NoneIosNativeDirectory.new].
typedef NoneIosNativeDirectoryBuilder = _PlatformNativeDirectoryBuilder<
    NoneIosNativeDirectory, PlatformRootPackage>;

/// {@template none_ios_native_directory}
/// Abstraction of a platform native directory of a platform root package of a Rapid project.
///
/// With a platform != iOS
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>/platform>`
/// {@endtemplate}
abstract class NoneIosNativeDirectory extends PlatformNativeDirectory {
  /// {@macro none_ios_native_directory}
  factory NoneIosNativeDirectory({
    required PlatformRootPackage rootPackage,
  }) =>
      NoneIosNativeDirectoryImpl(
        rootPackage: rootPackage,
      );

  /// Creates this directory on disk.
  Future<void> create({
    String? description,
    String? orgName,
  });
}

/// Signature of [IosNativeDirectory.new].
typedef IosNativeDirectoryBuilder
    = _PlatformNativeDirectoryBuilder<IosNativeDirectory, PlatformRootPackage>;

/// {@template ios_native_directory}
/// Abstraction of the ios native directory of a platform root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_ios/<project name>_ios/ios`
/// {@endtemplate}
abstract class IosNativeDirectory extends PlatformNativeDirectory {
  /// {@macro ios_native_directory}
  factory IosNativeDirectory({
    required PlatformRootPackage rootPackage,
  }) =>
      IosNativeDirectoryImpl(
        rootPackage: rootPackage,
      );

  @visibleForTesting
  InfoPlistFile? infoPlistFileOverrides;

  /// Creates this directory on disk.
  Future<void> create({
    required String orgName,
    required String language,
  });

  void addLanguage({required String language});

  void removeLanguage({required String language});
}

/// {@template info_plist_file}
/// Abstraction of the Info.plist file of the ios native directory of a platform root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>/ios/Runner/Info.plist`
/// {@endtemplate}
abstract class InfoPlistFile implements PlistFile {
  /// {@macro info_plist_file}
  factory InfoPlistFile({
    required IosNativeDirectory iosNativeDirectory,
  }) =>
      InfoPlistFileImpl(
        iosNativeDirectory: iosNativeDirectory,
      );

  void addLanguage({required String language});

  void removeLanguage({required String language});
}

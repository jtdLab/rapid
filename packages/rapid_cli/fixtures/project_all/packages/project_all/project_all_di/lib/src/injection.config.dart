// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:project_all_android_home_page/project_all_android_home_page.dart'
    as _i5;
import 'package:project_all_infrastructure/project_all_infrastructure.dart'
    as _i4;
import 'package:project_all_ios_home_page/project_all_ios_home_page.dart'
    as _i6;
import 'package:project_all_linux_home_page/project_all_linux_home_page.dart'
    as _i8;
import 'package:project_all_logging/project_all_logging.dart' as _i3;
import 'package:project_all_macos_home_page/project_all_macos_home_page.dart'
    as _i9;
import 'package:project_all_web_home_page/project_all_web_home_page.dart'
    as _i7;
import 'package:project_all_windows_home_page/project_all_windows_home_page.dart'
    as _i10;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await _i3.ProjectAllLoggingPackageModule().init(gh);
    await _i4.ProjectAllInfrastructurePackageModule().init(gh);
    await _i5.ProjectAllAndroidHomePagePackageModule().init(gh);
    await _i6.ProjectAllIosHomePagePackageModule().init(gh);
    await _i7.ProjectAllWebHomePagePackageModule().init(gh);
    await _i8.ProjectAllLinuxHomePagePackageModule().init(gh);
    await _i9.ProjectAllMacosHomePagePackageModule().init(gh);
    await _i10.ProjectAllWindowsHomePagePackageModule().init(gh);
    return this;
  }
}

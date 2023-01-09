// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:test_app_android_home_page/test_app_android_home_page.dart'
    as _i5;
import 'package:test_app_infrastructure/test_app_infrastructure.dart' as _i4;
import 'package:test_app_ios_home_page/test_app_ios_home_page.dart' as _i6;
import 'package:test_app_linux_home_page/test_app_linux_home_page.dart' as _i8;
import 'package:test_app_logging/test_app_logging.dart' as _i3;
import 'package:test_app_macos_home_page/test_app_macos_home_page.dart' as _i9;
import 'package:test_app_web_home_page/test_app_web_home_page.dart' as _i7;
import 'package:test_app_windows_home_page/test_app_windows_home_page.dart'
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
    await _i3.TestAppLoggingPackageModule().init(gh);
    await _i4.TestAppInfrastructurePackageModule().init(gh);
    await _i5.TestAppAndroidHomePagePackageModule().init(gh);
    await _i6.TestAppIosHomePagePackageModule().init(gh);
    await _i7.TestAppWebHomePagePackageModule().init(gh);
    await _i8.TestAppLinuxHomePagePackageModule().init(gh);
    await _i9.TestAppMacosHomePagePackageModule().init(gh);
    await _i10.TestAppWindowsHomePagePackageModule().init(gh);
    return this;
  }
}

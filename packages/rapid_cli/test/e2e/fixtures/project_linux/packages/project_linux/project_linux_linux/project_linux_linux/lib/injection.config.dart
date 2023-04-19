// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:project_linux_infrastructure/project_linux_infrastructure.dart'
    as _i4;
import 'package:project_linux_linux_app/project_linux_linux_app.dart' as _i14;
import 'package:project_linux_linux_home_page/project_linux_linux_home_page.dart'
    as _i8;
import 'package:project_linux_logging/project_linux_logging.dart' as _i3;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await _i3.ProjectLinuxLoggingPackageModule().init(gh);
    await _i4.ProjectLinuxInfrastructurePackageModule().init(gh);

    await _i14.ProjectLinuxLinuxAppPackageModule().init(gh);
    await _i8.ProjectLinuxLinuxHomePagePackageModule().init(gh);

    return this;
  }
}

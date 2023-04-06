// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:project_web_infrastructure/project_web_infrastructure.dart'
    as _i4;
import 'package:project_web_logging/project_web_logging.dart' as _i3;
import 'package:project_web_web_app/project_web_web_app.dart' as _i13;
import 'package:project_web_web_home_page/project_web_web_home_page.dart'
    as _i7;

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
    await _i3.ProjectWebLoggingPackageModule().init(gh);
    await _i4.ProjectWebInfrastructurePackageModule().init(gh);

    await _i13.ProjectWebWebAppPackageModule().init(gh);
    await _i7.ProjectWebWebHomePagePackageModule().init(gh);

    return this;
  }
}

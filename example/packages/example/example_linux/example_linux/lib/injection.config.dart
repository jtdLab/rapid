// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:example_infrastructure/example_infrastructure.dart' as _i4;
import 'package:example_linux_app/example_linux_app.dart' as _i14;
import 'package:example_linux_home_page/example_linux_home_page.dart' as _i8;
import 'package:example_logging/example_logging.dart' as _i3;

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
    await _i3.ExampleLoggingPackageModule().init(gh);
    await _i4.ExampleInfrastructurePackageModule().init(gh);

    await _i14.ExampleLinuxAppPackageModule().init(gh);
    await _i8.ExampleLinuxHomePagePackageModule().init(gh);

    return this;
  }
}

//@GeneratedMicroModule;ProjectIosLoggingPackageModule;package:project_ios_logging/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:injectable/injectable.dart' as _i1;
import 'package:project_ios_logging/src/logger.dart' as _i3;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
class ProjectIosLoggingPackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of [GetIt]
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {
    gh.lazySingleton<_i3.ProjectIosLogger>(
      () => _i3.ProjectIosLoggerDevelopment(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i3.ProjectIosLogger>(
      () => _i3.ProjectIosLoggerTest(),
      registerFor: {_test},
    );
    gh.lazySingleton<_i3.ProjectIosLogger>(
      () => _i3.ProjectIosLoggerProduction(),
      registerFor: {_prod},
    );
  }
}

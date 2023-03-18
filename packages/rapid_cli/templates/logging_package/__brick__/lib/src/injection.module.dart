//@GeneratedMicroModule;{{project_name.pascalCase()}}LoggingPackageModule;package:{{project_name}}_logging/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:injectable/injectable.dart' as _i1;
import 'package:{{project_name}}_logging/src/logger.dart' as _i3;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
class {{project_name.pascalCase()}}LoggingPackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of [GetIt]
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {
    gh.lazySingleton<_i3.{{project_name.pascalCase()}}Logger>(
      () => _i3.{{project_name.pascalCase()}}LoggerDevelopment(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i3.{{project_name.pascalCase()}}Logger>(
      () => _i3.{{project_name.pascalCase()}}LoggerTest(),
      registerFor: {_test},
    );
    gh.lazySingleton<_i3.{{project_name.pascalCase()}}Logger>(
      () => _i3.{{project_name.pascalCase()}}LoggerProduction(),
      registerFor: {_prod},
    );
  }
}

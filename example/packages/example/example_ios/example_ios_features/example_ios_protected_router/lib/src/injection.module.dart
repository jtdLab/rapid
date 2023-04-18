//@GeneratedMicroModule;ExampleIosProtectedRouterPackageModule;package:example_ios_protected_router/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:example_ios_navigation/example_ios_navigation.dart' as _i3;
import 'package:example_ios_protected_router/src/presentation/navigator.dart'
    as _i4;
import 'package:injectable/injectable.dart' as _i1;

const String _ios = 'ios';

class ExampleIosProtectedRouterPackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {
    gh.lazySingleton<_i3.IProtectedRouterNavigator>(
      () => _i4.ProtectedRouterNavigator(),
      registerFor: {_ios},
    );
  }
}

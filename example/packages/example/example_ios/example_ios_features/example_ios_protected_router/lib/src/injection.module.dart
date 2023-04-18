//@GeneratedMicroModule;ExampleIosProtectedRouterPackageModule;package:example_ios_protected_router/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:example_domain/example_domain.dart' as _i4;
import 'package:example_ios_navigation/example_ios_navigation.dart' as _i5;
import 'package:example_ios_protected_router/src/presentation/navigator.dart'
    as _i6;
import 'package:example_ios_protected_router/src/presentation/router.dart'
    as _i3;
import 'package:injectable/injectable.dart' as _i1;

const String _ios = 'ios';

class ExampleIosProtectedRouterPackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {
    gh.lazySingleton<_i3.AuthGuard>(
      () => _i3.AuthGuard(
        gh<_i4.IAuthService>(),
        gh<_i5.IPublicRouterNavigator>(),
      ),
      registerFor: {_ios},
    );
    gh.lazySingleton<_i5.IProtectedRouterNavigator>(
      () => _i6.ProtectedRouterNavigator(),
      registerFor: {_ios},
    );
  }
}

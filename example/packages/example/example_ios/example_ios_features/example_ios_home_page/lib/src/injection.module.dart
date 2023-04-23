//@GeneratedMicroModule;ExampleIosHomePagePackageModule;package:example_ios_home_page/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:example_domain_markdown/example_domain_markdown.dart' as _i4;
import 'package:example_ios_home_page/src/application/home_bloc.dart' as _i3;
import 'package:injectable/injectable.dart' as _i1;

const String _ios = 'ios';

class ExampleIosHomePagePackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {
    gh.factory<_i3.HomeBloc>(
      () => _i3.HomeBloc(gh<_i4.IMarkdownService>()),
      registerFor: {_ios},
    );
  }
}

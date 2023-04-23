//@GeneratedMicroModule;ExampleInfrastructureMarkdownPackageModule;package:example_infrastructure_markdown/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:example_domain_markdown/i_markdown_service.dart' as _i4;
import 'package:example_infrastructure_markdown/src/injection.dart' as _i6;
import 'package:example_infrastructure_markdown/src/remote_markdown_service.dart'
    as _i5;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i1;

const String _dev = 'dev';

class ExampleInfrastructureMarkdownPackageModule
    extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {
    final registerModule = _$RegisterModule();
    gh.factory<_i3.Client>(() => registerModule.client);
    gh.lazySingleton<_i4.IMarkdownService>(
      () => _i5.RemoteMarkdownService(gh<_i3.Client>()),
      registerFor: {_dev},
    );
  }
}

class _$RegisterModule extends _i6.RegisterModule {}

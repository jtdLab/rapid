{{#android}}// coverage:ignore-file
//@GeneratedMicroModule;{{project_name.pascalCase()}}Android{{name.pascalCase()}}PackageModule;package:{{project_name}}_android_{{name}}/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:injectable/injectable.dart' as _i1;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
class {{project_name.pascalCase()}}Android{{name.pascalCase()}}PackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of [GetIt]
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {}
}
{{/android}}{{#ios}}// coverage:ignore-file
//@GeneratedMicroModule;{{project_name.pascalCase()}}Ios{{name.pascalCase()}}PackageModule;package:{{project_name}}_ios_{{name}}/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:injectable/injectable.dart' as _i1;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
class {{project_name.pascalCase()}}Ios{{name.pascalCase()}}PackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of [GetIt]
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {}
}
{{/ios}}{{#linux}}// coverage:ignore-file
//@GeneratedMicroModule;{{project_name.pascalCase()}}Linux{{name.pascalCase()}}PackageModule;package:{{project_name}}_linux_{{name}}/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:injectable/injectable.dart' as _i1;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
class {{project_name.pascalCase()}}Linux{{name.pascalCase()}}PackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of [GetIt]
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {}
}
{{/linux}}{{#macos}}// coverage:ignore-file
//@GeneratedMicroModule;{{project_name.pascalCase()}}Macos{{name.pascalCase()}}PackageModule;package:{{project_name}}_macos_{{name}}/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:injectable/injectable.dart' as _i1;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
class {{project_name.pascalCase()}}Macos{{name.pascalCase()}}PackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of [GetIt]
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {}
}
{{/macos}}{{#web}}// coverage:ignore-file
//@GeneratedMicroModule;{{project_name.pascalCase()}}Web{{name.pascalCase()}}PackageModule;package:{{project_name}}_web_{{name}}/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:injectable/injectable.dart' as _i1;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
class {{project_name.pascalCase()}}Web{{name.pascalCase()}}PackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of [GetIt]
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {}
}
{{/web}}{{#windows}}// coverage:ignore-file
//@GeneratedMicroModule;{{project_name.pascalCase()}}Windows{{name.pascalCase()}}PackageModule;package:{{project_name}}_windows_{{name}}/src/injection.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:injectable/injectable.dart' as _i1;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
class {{project_name.pascalCase()}}Windows{{name.pascalCase()}}PackageModule extends _i1.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of [GetIt]
  @override
  _i2.FutureOr<void> init(_i1.GetItHelper gh) {}
}
{{/windows}}
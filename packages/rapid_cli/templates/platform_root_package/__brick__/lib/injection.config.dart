// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;import 'package:injectable/injectable.dart' as _i2;{{#android}}import 'package:{{project_name}}_android_app/{{project_name}}_android_app.dart' as _i11;import 'package:{{project_name}}_android_home_page/{{project_name}}_android_home_page.dart' as _i5;{{/android}}import 'package:{{project_name}}_infrastructure/{{project_name}}_infrastructure.dart' as _i4;{{#ios}}import 'package:{{project_name}}_ios_app/{{project_name}}_ios_app.dart' as _i12;import 'package:{{project_name}}_ios_home_page/{{project_name}}_ios_home_page.dart' as _i6;{{/ios}}{{#linux}}import 'package:{{project_name}}_linux_app/{{project_name}}_linux_app.dart' as _i14;import 'package:{{project_name}}_linux_home_page/{{project_name}}_linux_home_page.dart' as _i8;{{/linux}}import 'package:{{project_name}}_logging/{{project_name}}_logging.dart' as _i3;{{#macos}}import 'package:{{project_name}}_macos_app/{{project_name}}_macos_app.dart' as _i15;import 'package:{{project_name}}_macos_home_page/{{project_name}}_macos_home_page.dart' as _i9;{{/macos}}{{#web}}import 'package:{{project_name}}_web_app/{{project_name}}_web_app.dart' as _i13;import 'package:{{project_name}}_web_home_page/{{project_name}}_web_home_page.dart' as _i7;{{/web}}{{#windows}}import 'package:{{project_name}}_windows_app/{{project_name}}_windows_app.dart' as _i16;import 'package:{{project_name}}_windows_home_page/{{project_name}}_windows_home_page.dart' as _i10;{{/windows}}

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
    await _i3.{{project_name.pascalCase()}}LoggingPackageModule().init(gh);
    await _i4.{{project_name.pascalCase()}}InfrastructurePackageModule().init(gh);
    {{#android}}await _i11.{{project_name.pascalCase()}}AndroidAppPackageModule().init(gh);{{/android}}
    {{#android}}await _i5.{{project_name.pascalCase()}}AndroidHomePagePackageModule().init(gh);{{/android}}
    {{#ios}}await _i12.{{project_name.pascalCase()}}IosAppPackageModule().init(gh);{{/ios}}
    {{#ios}}await _i6.{{project_name.pascalCase()}}IosHomePagePackageModule().init(gh);{{/ios}}
    {{#linux}}await _i14.{{project_name.pascalCase()}}LinuxAppPackageModule().init(gh);{{/linux}}
    {{#linux}}await _i8.{{project_name.pascalCase()}}LinuxHomePagePackageModule().init(gh);{{/linux}}
    {{#macos}}await _i15.{{project_name.pascalCase()}}MacosAppPackageModule().init(gh);{{/macos}}
    {{#macos}}await _i9.{{project_name.pascalCase()}}MacosHomePagePackageModule().init(gh);{{/macos}}
    {{#web}}await _i13.{{project_name.pascalCase()}}WebAppPackageModule().init(gh);{{/web}}
    {{#web}}await _i7.{{project_name.pascalCase()}}WebHomePagePackageModule().init(gh);{{/web}}
    {{#windows}}await _i16.{{project_name.pascalCase()}}WindowsAppPackageModule().init(gh);{{/windows}}
    {{#windows}}await _i10.{{project_name.pascalCase()}}WindowsHomePagePackageModule().init(gh);{{/windows}}
    return this;
  }
}

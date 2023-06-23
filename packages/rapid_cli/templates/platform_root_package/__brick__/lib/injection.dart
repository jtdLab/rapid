{{#android}}import 'package:{{project_name}}_android_app/{{project_name}}_android_app.dart';import 'package:{{project_name}}_android_home_page/{{project_name}}_android_home_page.dart';{{/android}}import 'package:{{project_name}}_di/{{project_name}}_di.dart';import 'package:{{project_name}}_infrastructure/{{project_name}}_infrastructure.dart';{{#ios}}import 'package:{{project_name}}_ios_app/{{project_name}}_ios_app.dart';import 'package:{{project_name}}_ios_home_page/{{project_name}}_ios_home_page.dart';{{/ios}}{{#linux}}import 'package:{{project_name}}_linux_app/{{project_name}}_linux_app.dart';import 'package:{{project_name}}_linux_home_page/{{project_name}}_linux_home_page.dart';{{/linux}}import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';{{#macos}}import 'package:{{project_name}}_macos_app/{{project_name}}_macos_app.dart';import 'package:{{project_name}}_macos_home_page/{{project_name}}_macos_home_page.dart';{{/macos}}{{#web}}import 'package:{{project_name}}_web_app/{{project_name}}_web_app.dart';import 'package:{{project_name}}_web_home_page/{{project_name}}_web_home_page.dart';{{/web}}{{#windows}}import 'package:{{project_name}}_windows_app/{{project_name}}_windows_app.dart';import 'package:{{project_name}}_windows_home_page/{{project_name}}_windows_home_page.dart';{{/windows}}{{#mobile}}import 'package:{{project_name}}_mobile_app/{{project_name}}_mobile_app.dart';import 'package:{{project_name}}_mobile_home_page/{{project_name}}_mobile_home_page.dart';{{/mobile}}import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit(
  externalPackageModules: [
    {{project_name.pascalCase()}}LoggingPackageModule,
    {{project_name.pascalCase()}}InfrastructurePackageModule,
    {{#android}}{{project_name.pascalCase()}}AndroidAppPackageModule,{{/android}}
    {{#android}}{{project_name.pascalCase()}}AndroidHomePagePackageModule,{{/android}}
    {{#ios}}{{project_name.pascalCase()}}IosAppPackageModule,{{/ios}}
    {{#ios}}{{project_name.pascalCase()}}IosHomePagePackageModule,{{/ios}}
    {{#linux}}{{project_name.pascalCase()}}LinuxAppPackageModule,{{/linux}}
    {{#linux}}{{project_name.pascalCase()}}LinuxHomePagePackageModule,{{/linux}}
    {{#macos}}{{project_name.pascalCase()}}MacosAppPackageModule,{{/macos}}
    {{#macos}}{{project_name.pascalCase()}}MacosHomePagePackageModule,{{/macos}}
    {{#web}}{{project_name.pascalCase()}}WebAppPackageModule,{{/web}}
    {{#web}}{{project_name.pascalCase()}}WebHomePagePackageModule,{{/web}}
    {{#windows}}{{project_name.pascalCase()}}WindowsAppPackageModule,{{/windows}}
    {{#windows}}{{project_name.pascalCase()}}WindowsHomePagePackageModule,{{/windows}}
    {{#mobile}}{{project_name.pascalCase()}}MobileAppPackageModule,{{/mobile}}
    {{#mobile}}{{project_name.pascalCase()}}MobileHomePagePackageModule,{{/mobile}}
  ],
)
Future<void> configureDependencies(String environment, String platform) async =>
    await getIt.init(
      environmentFilter: NoEnvOrContainsAny({environment, platform}),
    );

/// Setup registering third party packages.
///
/// For more info see: https://pub.dev/packages/injectable#registering-third-party-types
@module
abstract class RegisterModule {
  // TODO: register third party dependencies here
}

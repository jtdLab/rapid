// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i1;
import 'package:{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}_home_page/{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}_home_page.dart' as _i2;

abstract class $Router extends _i1.RootStackRouter {
  $Router({super.navigatorKey});

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    ..._i2.HomePageModule().pagesMap,
  };
}

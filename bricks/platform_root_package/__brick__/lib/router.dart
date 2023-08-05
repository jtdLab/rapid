import 'package:auto_route/auto_route.dart';
import 'package:{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}{{#mobile}}mobile{{/mobile}}_home_page/{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}{{#mobile}}mobile{{/mobile}}_home_page.dart';

import 'router.gr.dart';

/// Setup auto route which generates routing code.
///
/// For more info see: https://pub.dev/packages/auto_route#setup-and-usage
@AutoRouterConfig(
  replaceInRouteName: null,
  modules: [
    HomePageModule,
  ],
)
class Router extends $Router {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomePageRoute.page, path: '/'),
        // TODO: add routes here
      ];
}

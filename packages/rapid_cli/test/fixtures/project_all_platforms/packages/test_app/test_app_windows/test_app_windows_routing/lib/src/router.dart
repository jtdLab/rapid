import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:test_app_windows_home_page/test_app_windows_home_page.dart';

part 'router.gr.dart';

/// Setup auto route which generates routing code.
///
/// For more info see: https://pub.dev/packages/auto_route
@MaterialAutoRouter(
  routes: [
    MaterialRoute(
      initial: true,
      page: HomePage,
    ),
  ],
)
class Router extends _$Router {}

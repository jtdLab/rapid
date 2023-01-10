import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:project_all_ios_home_page/project_all_ios_home_page.dart';

part 'router.gr.dart';

/// Setup auto route which generates routing code.
///
/// For more info see: https://pub.dev/packages/auto_route
@CupertinoAutoRouter(
  routes: [
    CupertinoRoute(
      initial: true,
      page: HomePage,
    ),
  ],
)
class Router extends _$Router {}

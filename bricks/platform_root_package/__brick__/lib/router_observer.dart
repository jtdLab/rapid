import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';

class {{project_name.pascalCase()}}RouterObserver extends AutoRouterObserver {
  {{project_name.pascalCase()}}RouterObserver(this.logger);

  final {{project_name.pascalCase()}}Logger logger;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.debug('New route pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.debug('Route popped: ${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.debug('Route removed: ${route.settings.name}');
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    logger.debug('Tab route visited: ${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    logger.debug('Tab route re-visited: ${route.name}');
  }
}

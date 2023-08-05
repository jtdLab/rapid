import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';

class {{project_name.pascalCase()}}RouterObserver extends AutoRouterObserver {
  final {{project_name.pascalCase()}}Logger logger;

  {{project_name.pascalCase()}}RouterObserver(this.logger);

  @override
  void didPush(Route route, Route? previousRoute) {
    logger.debug('New route pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    logger.debug('Route popped: ${route.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
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
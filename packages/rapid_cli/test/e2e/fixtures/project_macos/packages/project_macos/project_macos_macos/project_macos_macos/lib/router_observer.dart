import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:project_macos_logging/project_macos_logging.dart';

class ProjectMacosRouterObserver extends AutoRouterObserver {
  final ProjectMacosLogger logger;

  ProjectMacosRouterObserver(this.logger);

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

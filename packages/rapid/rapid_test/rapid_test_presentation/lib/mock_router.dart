import 'package:auto_route/auto_route.dart';
import 'package:auto_route/src/matcher/route_matcher.dart';
import 'package:auto_route/src/router/controller/navigation_history/navigation_history_base.dart';
import 'package:auto_route/src/router/controller/pageless_routes_observer.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

class MockRouter extends Mock implements RootStackRouter {
  /// The underlying router
  final RootStackRouter _router;

  ///final Widget widget;
  MockRouter._(RootStackRouter router) : _router = router {
    registerFallbackValue(const TestRoute());
    when(() => push(any())).thenAnswer((_) async => null);
    when(() => pop()).thenAnswer((_) async => true);
  }

  factory MockRouter.widget(Widget widget) = _MockRouterWidget;

  factory MockRouter.flow(
    Widget flow,
    List<PageRouteInfo<dynamic>> childRoutes,
  ) = _MockRouterFlow;

  ///MockRouter(this.widget) : _router = _SingleTestRouteRouter(widget);
  @override
  ActiveGuardObserver get activeGuardObserver => _router.activeGuardObserver;

  @override
  void addListener(VoidCallback listener) => _router.addListener(listener);

  @override
  void attachChildController(RoutingController childController) =>
      _router.attachChildController(childController);

  @override
  PageRouteInfo? buildPageRoute(
    String? path, {
    bool includePrefixMatches = true,
  }) =>
      _router.buildPageRoute(path, includePrefixMatches: includePrefixMatches);

  @override
  List<PageRouteInfo>? buildPageRoutesStack(
    String? path, {
    bool includePrefixMatches = true,
  }) =>
      _router.buildPageRoutesStack(
        path,
        includePrefixMatches: includePrefixMatches,
      );

  @override
  bool get canNavigateBack => _router.canNavigateBack;

  @override
  bool get canPopSelfOrChildren => _router.canPopSelfOrChildren;

  @override
  List<RoutingController> get childControllers => _router.childControllers;

  @override
  RouteData get current => _router.current;

  @override
  RouteData? get currentChild => _router.currentChild;

  @override
  String get currentPath => _router.currentPath;

  @override
  List<RouteMatch> get currentSegments => _router.currentSegments;

  @override
  String get currentUrl => _router.currentUrl;

  @override
  AutoRouterDelegate declarativeDelegate({
    required RoutesBuilder routes,
    String? navRestorationScopeId,
    RoutePopCallBack? onPopRoute,
    String? initialDeepLink,
    OnNavigateCallBack? onNavigate,
    NavigatorObserversBuilder navigatorObservers =
        AutoRouterDelegate.defaultNavigatorObserversBuilder,
  }) =>
      _router.declarativeDelegate(
        routes: routes,
        navRestorationScopeId: navRestorationScopeId,
        onPopRoute: onPopRoute,
        initialDeepLink: initialDeepLink,
        onNavigate: onNavigate,
        navigatorObservers: navigatorObservers,
      );

  @override
  DefaultRouteParser defaultRouteParser({bool includePrefixMatches = false}) =>
      _router.defaultRouteParser(includePrefixMatches: includePrefixMatches);

  @override
  AutoRouterDelegate delegate({
    List<PageRouteInfo>? initialRoutes,
    String? initialDeepLink,
    String? navRestorationScopeId,
    WidgetBuilder? placeholder,
    NavigatorObserversBuilder navigatorObservers =
        AutoRouterDelegate.defaultNavigatorObserversBuilder,
  }) =>
      AutoRouterDelegate(
        this,
        initialDeepLink: initialDeepLink,
        initialRoutes: initialRoutes,
        navRestorationScopeId: navRestorationScopeId,
        navigatorObservers: navigatorObservers,
        placeholder: placeholder,
      );

  @override
  void dispose() => _router.dispose();

  @override
  bool get hasEntries => _router.hasEntries;

  @override
  bool get hasListeners => _router.hasListeners;

  @override
  bool get hasPagelessTopRoute => _router.hasPagelessTopRoute;

  @override
  T? innerRouterOf<T extends RoutingController>(String routeName) =>
      _router.innerRouterOf<T>(routeName);

  @override
  bool isPathActive(String path) => _router.isPathActive(path);

  @override
  bool get isRoot => _router.isRoot;

  @override
  bool isRouteActive(String routeName) => _router.isRouteActive(routeName);

  @override
  bool isRouteDataActive(RouteData data) => _router.isRouteDataActive(data);

  @override
  bool get isTopMost => _router.isTopMost;

  @override
  LocalKey get key => _router.key;

  @override
  bool get managedByWidget => _router.managedByWidget;

  @override
  void markUrlStateForReplace() => _router.markUrlStateForReplace();

  @override
  RouteMatcher get matcher => _router.matcher;

  /* 
  @override
  Future navigate(PageRouteInfo route, {OnNavigationFailure? onFailure}) =>
      _router.navigate(route, onFailure: onFailure); 
  */

  @override
  Future<void> navigateAll(
    List<RouteMatch> routes, {
    OnNavigationFailure? onFailure,
  }) =>
      _router.navigateAll(routes, onFailure: onFailure);

  /*
  @override
  void navigateBack() => _router.navigateBack();
  @override
  Future<void> navigateNamed(
    String path, {
    bool includePrefixMatches = false,
    OnNavigationFailure? onFailure,
  }) =>
      _router.navigateNamed(
        path,
        includePrefixMatches: includePrefixMatches,
        onFailure: onFailure,
      );
  */

  @override
  NavigationHistory get navigationHistory => _router.navigationHistory;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _router.navigatorKey;

  @override
  void notifyAll({bool forceUrlRebuild = false}) =>
      _router.notifyAll(forceUrlRebuild: forceUrlRebuild);

  @override
  void notifyListeners() => _router.notifyListeners();

  @override
  OnNestedNavigateCallBack? get onNavigate => _router.onNavigate;

  @override
  PageBuilder get pageBuilder => _router.pageBuilder;

  @override
  int get pageCount => _router.pageCount;

  @override
  PagelessRoutesObserver get pagelessRoutesObserver =>
      _router.pagelessRoutesObserver;

  @override
  T? parent<T extends RoutingController>() => _router.parent<T>();

  @override
  StackRouter? get parentAsStackRouter => _router.parentAsStackRouter;

  @override
  PendingRoutesHandler get pendingRoutesHandler => _router.pendingRoutesHandler;

  /* @override
  Future<bool> pop<T extends Object?>([T? result]) {
    // TODO: implement pop
    throw UnimplementedError();
  }
  @override
  Future<T?> popAndPush<T extends Object?, TO extends Object?>(
      PageRouteInfo route,
      {TO? result,
      OnNavigationFailure? onFailure}) {
    // TODO: implement popAndPush
    throw UnimplementedError();
  }
  @override
  Future<void> popAndPushAll(List<PageRouteInfo> routes, {onFailure}) {
    // TODO: implement popAndPushAll
    throw UnimplementedError();
  }
  @override
  void popForced<T extends Object?>([T? result]) {
    // TODO: implement popForced
  }
  @override
  Future<bool> popTop<T extends Object?>([T? result]) {
    // TODO: implement popTop
    throw UnimplementedError();
  }
  @override
  void popUntil(RoutePredicate predicate) {
    // TODO: implement popUntil
  }
  @override
  void popUntilRoot() {
    // TODO: implement popUntilRoot
  }
  @override
  void popUntilRouteWithName(String name) {
    // TODO: implement popUntilRouteWithName
  }
  @override
  Future<T?> push<T extends Object?>(PageRouteInfo route,
      {OnNavigationFailure? onFailure}) {
    // TODO: implement push
    throw UnimplementedError();
  }
  @override
  Future<void> pushAll(List<PageRouteInfo> routes,
      {OnNavigationFailure? onFailure}) {
    // TODO: implement pushAll
    throw UnimplementedError();
  }
  @override
  Future<T?> pushAndPopUntil<T extends Object?>(PageRouteInfo route,
      {required RoutePredicate predicate, OnNavigationFailure? onFailure}) {
    // TODO: implement pushAndPopUntil
    throw UnimplementedError();
  }
  @override
  Future<T?> pushNamed<T extends Object?>(String path,
      {bool includePrefixMatches = false, OnNavigationFailure? onFailure}) {
    // TODO: implement pushNamed
    throw UnimplementedError();
  }
  @override
  Future<T?> pushNativeRoute<T extends Object?>(Route<T> route) {
    // TODO: implement pushNativeRoute
    throw UnimplementedError();
  }
  @override
  Future<T?> pushWidget<T extends Object?>(Widget widget,
      {RouteTransitionsBuilder? transitionBuilder,
      bool fullscreenDialog = false,
      Duration transitionDuration = const Duration(milliseconds: 300)}) {
    // TODO: implement pushWidget
    throw UnimplementedError();
  } */

  @override
  void removeChildController(RoutingController childController) =>
      _router.removeChildController(childController);

  @override
  bool removeLast() => _router.removeLast();

  @override
  void removeListener(VoidCallback listener) =>
      _router.removeListener(listener);

  @override
  void removeRoute(RouteData route, {bool notify = true}) =>
      _router.removeRoute(route, notify: notify);

  @override
  bool removeUntil(RouteDataPredicate predicate) =>
      _router.removeUntil(predicate);

  @override
  bool removeWhere(RouteDataPredicate predicate, {bool notify = true}) =>
      _router.removeWhere(predicate, notify: notify);

  /*  @override
  Future<T?> replace<T extends Object?>(PageRouteInfo route,
      {OnNavigationFailure? onFailure}) {
    // TODO: implement replace
    throw UnimplementedError();
  }
  @override
  Future<void> replaceAll(List<PageRouteInfo> routes,
      {OnNavigationFailure? onFailure}) {
    // TODO: implement replaceAll
    throw UnimplementedError();
  }
  @override
  Future<T?> replaceNamed<T extends Object?>(String path,
      {bool includePrefixMatches = false, OnNavigationFailure? onFailure}) {
    // TODO: implement replaceNamed
    throw UnimplementedError();
  } */

  @override
  StackRouter get root => _router.root;

  @override
  RouteCollection get routeCollection => _router.routeCollection;

  @override
  RouteData get routeData => _router.routeData;

  @override
  AutoRouteInformationProvider routeInfoProvider({
    RouteInformation? initialRouteInformation,
    bool Function(String?)? neglectWhen,
  }) =>
      _router.routeInfoProvider(
        initialRouteInformation: initialRouteInformation,
        neglectWhen: neglectWhen,
      );

  @override
  List<AutoRoutePage> get stack => _router.stack;

  @override
  List<RouteData> get stackData => _router.stackData;

  @override
  int get stateHash => _router.stateHash;

  @override
  RouteMatch get topMatch => _router.topMatch;

  @override
  RoutingController topMostRouter({bool ignorePagelessRoutes = false}) =>
      _router.topMostRouter(ignorePagelessRoutes: ignorePagelessRoutes);

  @override
  AutoRoutePage? get topPage => _router.topPage;

  @override
  RouteData get topRoute => _router.topRoute;

  @override
  void updateDeclarativeRoutes(List<PageRouteInfo> routes) =>
      _router.updateDeclarativeRoutes(routes);

  @override
  void updateRouteData(RouteData data) => _router.updateRouteData(data);

  @override
  UrlState get urlState => _router.urlState;
}

class _MockRouterWidget extends MockRouter {
  final Widget widget;

  _MockRouterWidget(this.widget) : super._(_RouterWidget(widget));
}

class _MockRouterFlow extends MockRouter {
  final Widget flow; // TODO scalable.Flow
  final List<PageRouteInfo<dynamic>> childRoutes;

  _MockRouterFlow(this.flow, this.childRoutes)
      : super._(_RouterFlow(flow, childRoutes));
}

class TestRoute extends PageRouteInfo<void> {
  const TestRoute({List<PageRouteInfo>? children})
      : super(TestRoute.name, path: '/', initialChildren: children);

  static const String name = 'TestRoute';
}

class _RouterWidget extends RootStackRouter {
  final Widget widget;

  _RouterWidget(this.widget);

  @override
  Map<String, PageFactory> get pagesMap => {
        'foo': (routeData) {
          // TODO make definable via a builder some app might want no CustomPage
          return CustomPage<dynamic>(
            routeData: routeData,
            child: widget,
            opaque: true,
            barrierDismissible: false,
          );
        },
      };

  @override
  List<RouteConfig> get routes => [
        RouteConfig('foo', path: '/'),
      ];
}

// TODO impl
class _RouterFlow extends RootStackRouter {
  final Widget flow; // TODO scalable.Flow
  final List<PageRouteInfo<dynamic>> childRoutes;

  _RouterFlow(this.flow, this.childRoutes);

  @override
  Map<String, PageFactory> get pagesMap => {
        'foo': (routeData) {
          // TODO make definable via a builder some app might want no CustomPage
          return CustomPage<dynamic>(
            routeData: routeData,
            child: flow,
            opaque: true,
            barrierDismissible: false,
          );
        },
        for (final childRoute in childRoutes)
          childRoute.routeName: (routeData) {
            // TODO make definable via a builder some app might want no CustomPage
            return CustomPage<dynamic>(
              routeData: routeData,
              child: Container(), // TODO MockWidget
              opaque: true,
              barrierDismissible: false,
            );
          },
      };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          'foo',
          path: '/',
          children: [
            RouteConfig(
              childRoutes.first.routeName,
              path: '',
              parent: 'foo',
            ),
            for (final childRoute in childRoutes.skip(1))
              RouteConfig(
                childRoute.routeName,
                path: childRoute.routeName,
                parent: 'foo',
              ),
          ],
        ),
      ];
}

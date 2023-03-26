{{#android}}import 'package:flutter/material.dart';{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';{{/ios}}{{#linux}}import 'package:flutter/material.dart';{{/linux}}{{#macos}}import 'package:flutter/widgets.dart';{{/macos}}{{#web}}import 'package:flutter/material.dart';{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';{{/windows}}
import 'package:flutter_test/flutter_test.dart';

class FakeLocalizationsDelegate extends LocalizationsDelegate<dynamic> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future load(Locale locale) async {}

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}

class FakeRouterDelegate extends RouterDelegate<Object> {
  @override
  void addListener(VoidCallback listener) {}

  @override
  Widget build(BuildContext context) => Container();

  @override
  Future<bool> popRoute() async => false;

  @override
  void removeListener(VoidCallback listener) {}

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}

{{#macos}}class FakeRouteInformationParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return 0;
  }
}

class FakeRouterConfig extends RouterConfig<Object> {
  final RouteInformationParser<Object> _routeInformationParser;

  FakeRouterConfig()
      : _routeInformationParser = FakeRouteInformationParser(),
        super(routerDelegate: FakeRouterDelegate());

  @override
  RouteInformationParser<Object>? get routeInformationParser =>
      _routeInformationParser;
}
{{/macos}}{{#windows}}class FakeRouteInformationParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return 0;
  }
}

class FakeRouterConfig extends RouterConfig<Object> {
  final RouteInformationParser<Object> _routeInformationParser;

  FakeRouterConfig()
      : _routeInformationParser = FakeRouteInformationParser(),
        super(routerDelegate: FakeRouterDelegate());

  @override
  RouteInformationParser<Object>? get routeInformationParser =>
      _routeInformationParser;
}
{{/windows}}{{^macos}}{{^windows}}class FakeRouterConfig extends RouterConfig<Object> {
  FakeRouterConfig() : super(routerDelegate: FakeRouterDelegate());
}
{{/windows}}{{/macos}}
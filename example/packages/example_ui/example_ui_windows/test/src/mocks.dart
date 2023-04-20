import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeLocalizationsDelegate extends LocalizationsDelegate<dynamic> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future load(Locale locale) async {}

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}

class FakeRouteInformationProvider extends Fake
    implements RouteInformationProvider {}

class FakeRouteInformationParser extends RouteInformationParser<Object> {}

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

class FakeRouterConfig extends RouterConfig<Object> {
  FakeRouterConfig()
      : super(
          routeInformationProvider: FakeRouteInformationProvider(),
          routeInformationParser: FakeRouteInformationParser(),
          routerDelegate: FakeRouterDelegate(),
        );
}

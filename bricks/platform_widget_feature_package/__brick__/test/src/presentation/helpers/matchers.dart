import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Matches a [Route] with [name].
Matcher isRoute(String name) => _IsRoute(name);

class _IsRoute extends Matcher {
  const _IsRoute(this._name);

  final String _name;

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    final name = _name;

    if (item is Route) {
      return item.settings.name == name;
    }

    return false;
  }

  @override
  Description describe(Description description) =>
      description..add('is Route with name ').addDescriptionOf(_name);

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is Route) {
      return super
          .describeMismatch(item, mismatchDescription, matchState, verbose);
    } else {
      return mismatchDescription.add('is not a Route');
    }
  }
}

/// Matches a [TabPageRoute] with [name].
Matcher isTabPageRoute(String name) => _IsTabPageRoute(name);

class _IsTabPageRoute extends Matcher {
  const _IsTabPageRoute(this._name);

  final String _name;

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    final name = _name;

    if (item is TabPageRoute) {
      return item.name == name;
    }

    return false;
  }

  @override
  Description describe(Description description) =>
      description..add('is TabPageRoute with name ').addDescriptionOf(_name);

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is Route) {
      return super
          .describeMismatch(item, mismatchDescription, matchState, verbose);
    } else {
      return mismatchDescription.add('is not a TabPageRoute');
    }
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_android_routing/project_android_android_routing.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';

/// Matches a [Route] with [name].
Matcher isRoute(String name) => _IsRoute(name);

class _IsRoute extends Matcher {
  final String _name;

  const _IsRoute(this._name);

  @override
  bool matches(Object? item, Map matchState) {
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
    Map matchState,
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
  final String _name;

  const _IsTabPageRoute(this._name);

  @override
  bool matches(Object? item, Map matchState) {
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
    Map matchState,
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

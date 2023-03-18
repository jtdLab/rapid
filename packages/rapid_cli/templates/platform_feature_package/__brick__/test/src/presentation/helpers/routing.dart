import 'package:flutter_test/flutter_test.dart';{{#android}}import 'package:{{project_name}}_android_routing/{{project_name}}_android_routing.dart';import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';{{/android}}
{{#ios}}import 'package:{{project_name}}_ios_routing/{{project_name}}_ios_routing.dart';import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';{{/ios}}
{{#linux}}import 'package:{{project_name}}_linux_routing/{{project_name}}_linux_routing.dart';import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';{{/linux}}
{{#macos}}import 'package:{{project_name}}_macos_routing/{{project_name}}_macos_routing.dart';import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';{{/macos}}
{{#web}}import 'package:{{project_name}}_web_routing/{{project_name}}_web_routing.dart';import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';{{/web}}
{{#windows}}import 'package:{{project_name}}_windows_routing/{{project_name}}_windows_routing.dart';import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';{{/windows}}

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

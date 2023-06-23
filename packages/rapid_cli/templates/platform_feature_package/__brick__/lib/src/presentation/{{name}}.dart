{{#android}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
{{#exampleTranslation}}import 'package:{{project_name}}_android_{{name}}/src/presentation/l10n/l10n.dart';{{/exampleTranslation}}
import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';
{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_android_{{name.snakeCase()}}/{{project_name}}_android_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}{{^isPage}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(toString()),
      ),
    );{{/isPage}}{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
{{#isFlow}}    // TODO: See https://pub.dev/packages/auto_route#nested-navigation
    return const AutoRouter();{{/isFlow}}
{{#isPage}}{{#exampleTranslation}}final title = context.l10n.title;

{{/exampleTranslation}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text({{#exampleTranslation}}title{{/exampleTranslation}}{{^exampleTranslation}}toString(){{/exampleTranslation}}),
      ),
    );{{/isPage}}
{{#isTabFlow}}    // TODO: See https://pub.dev/packages/auto_route#tab-navigation
    return const AutoTabsRouter(
      routes: [
{{#subRoutes}}   
        {{name.pascalCase()}}Route(),
{{/subRoutes}}   
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/android}}{{#ios}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
{{#exampleTranslation}}import 'package:{{project_name}}_ios_{{name}}/src/presentation/l10n/l10n.dart';{{/exampleTranslation}}
import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';
{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_ios_{{name.snakeCase()}}/{{project_name}}_ios_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}{{^isPage}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(toString()),
      ),
    );{{/isPage}}{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
{{#isFlow}}    // TODO: See https://pub.dev/packages/auto_route#nested-navigation
    return const AutoRouter();{{/isFlow}}
{{#isPage}}{{#exampleTranslation}}final title = context.l10n.title;

{{/exampleTranslation}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text({{#exampleTranslation}}title{{/exampleTranslation}}{{^exampleTranslation}}toString(){{/exampleTranslation}}),
      ),
    );{{/isPage}}
{{#isTabFlow}}    // TODO: See https://pub.dev/packages/auto_route#tab-navigation
    return const AutoTabsRouter(
      routes: [
{{#subRoutes}}   
        {{name.pascalCase()}}Route(),
{{/subRoutes}}   
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/ios}}{{#linux}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
{{#exampleTranslation}}import 'package:{{project_name}}_linux_{{name}}/src/presentation/l10n/l10n.dart';{{/exampleTranslation}}
import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';
{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_linux_{{name.snakeCase()}}/{{project_name}}_linux_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}{{^isPage}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(toString()),
      ),
    );{{/isPage}}{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
{{#isFlow}}    // TODO: See https://pub.dev/packages/auto_route#nested-navigation
    return const AutoRouter();{{/isFlow}}
{{#isPage}}{{#exampleTranslation}}final title = context.l10n.title;

{{/exampleTranslation}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text({{#exampleTranslation}}title{{/exampleTranslation}}{{^exampleTranslation}}toString(){{/exampleTranslation}}),
      ),
    );{{/isPage}}
{{#isTabFlow}}    // TODO: See https://pub.dev/packages/auto_route#tab-navigation
    return const AutoTabsRouter(
      routes: [
{{#subRoutes}}   
        {{name.pascalCase()}}Route(),
{{/subRoutes}}   
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/linux}}{{#macos}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
{{#exampleTranslation}}import 'package:{{project_name}}_macos_{{name}}/src/presentation/l10n/l10n.dart';{{/exampleTranslation}}
import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';
{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_macos_{{name.snakeCase()}}/{{project_name}}_macos_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}{{^isPage}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(toString()),
      ),
    );{{/isPage}}{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
{{#isFlow}}    // TODO: See https://pub.dev/packages/auto_route#nested-navigation
    return const AutoRouter();{{/isFlow}}
{{#isPage}}{{#exampleTranslation}}final title = context.l10n.title;

{{/exampleTranslation}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text({{#exampleTranslation}}title{{/exampleTranslation}}{{^exampleTranslation}}toString(){{/exampleTranslation}}),
      ),
    );{{/isPage}}
{{#isTabFlow}}    // TODO: See https://pub.dev/packages/auto_route#tab-navigation
    return const AutoTabsRouter(
      routes: [
{{#subRoutes}}   
        {{name.pascalCase()}}Route(),
{{/subRoutes}}   
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/macos}}{{#web}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';
{{#exampleTranslation}}import 'package:{{project_name}}_web_{{name}}/src/presentation/l10n/l10n.dart';{{/exampleTranslation}}
{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_web_{{name.snakeCase()}}/{{project_name}}_web_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}{{^isPage}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(toString()),
      ),
    );{{/isPage}}{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
{{#isFlow}}    // TODO: See https://pub.dev/packages/auto_route#nested-navigation
    return const AutoRouter();{{/isFlow}}
{{#isPage}}{{#exampleTranslation}}final title = context.l10n.title;

{{/exampleTranslation}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text({{#exampleTranslation}}title{{/exampleTranslation}}{{^exampleTranslation}}toString(){{/exampleTranslation}}),
      ),
    );{{/isPage}}
{{#isTabFlow}}    // TODO: See https://pub.dev/packages/auto_route#tab-navigation
    return const AutoTabsRouter(
      routes: [
{{#subRoutes}}   
        {{name.pascalCase()}}Route(),
{{/subRoutes}}   
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/web}}{{#windows}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';
{{#exampleTranslation}}import 'package:{{project_name}}_windows_{{name}}/src/presentation/l10n/l10n.dart';{{/exampleTranslation}}
{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_windows_{{name.snakeCase()}}/{{project_name}}_windows_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}{{^isPage}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(toString()),
      ),
    );{{/isPage}}{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
{{#isFlow}}    // TODO: See https://pub.dev/packages/auto_route#nested-navigation
    return const AutoRouter();{{/isFlow}}
{{#isPage}}{{#exampleTranslation}}final title = context.l10n.title;

{{/exampleTranslation}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text({{#exampleTranslation}}title{{/exampleTranslation}}{{^exampleTranslation}}toString(){{/exampleTranslation}}),
      ),
    );{{/isPage}}
{{#isTabFlow}}    // TODO: See https://pub.dev/packages/auto_route#tab-navigation
    return const AutoTabsRouter(
      routes: [
{{#subRoutes}}   
        {{name.pascalCase()}}Route(),
{{/subRoutes}}   
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/windows}}{{#mobile}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
import 'package:{{project_name}}_ui_mobile/{{project_name}}_ui_mobile.dart';
{{#exampleTranslation}}import 'package:{{project_name}}_mobile_{{name}}/src/presentation/l10n/l10n.dart';{{/exampleTranslation}}
{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_mobile_{{name.snakeCase()}}/{{project_name}}_mobile_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}{{^isPage}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(toString()),
      ),
    );{{/isPage}}{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
{{#isFlow}}    // TODO: See https://pub.dev/packages/auto_route#nested-navigation
    return const AutoRouter();{{/isFlow}}
{{#isPage}}{{#exampleTranslation}}final title = context.l10n.title;

{{/exampleTranslation}}    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text({{#exampleTranslation}}title{{/exampleTranslation}}{{^exampleTranslation}}toString(){{/exampleTranslation}}),
      ),
    );{{/isPage}}
{{#isTabFlow}}    // TODO: See https://pub.dev/packages/auto_route#tab-navigation
    return const AutoTabsRouter(
      routes: [
{{#subRoutes}}   
        {{name.pascalCase()}}Route(),
{{/subRoutes}}   
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/mobile}}
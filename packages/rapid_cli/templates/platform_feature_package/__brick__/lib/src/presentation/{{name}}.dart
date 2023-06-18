{{#android}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
import 'package:{{project_name}}_android_{{name}}/src/presentation/l10n/l10n.dart';
import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}    final title = context.l10n.title;

    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(title),
      ),
    );{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
    {{#isFlow}}    return const AutoRouter();{{/isFlow}}
    {{#isTabFlow}}    return const AutoTabsRouter(
      routes: [
        // TODO: add tab routes here
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/android}}{{#ios}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
import 'package:{{project_name}}_ios_{{name}}/src/presentation/l10n/l10n.dart';
import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}    final title = context.l10n.title;

    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(title),
      ),
    );{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
    {{#isFlow}}    return const AutoRouter();{{/isFlow}}
    {{#isTabFlow}}    return const AutoTabsRouter(
      routes: [
        // TODO: add tab routes here
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/ios}}{{#linux}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
import 'package:{{project_name}}_linux_{{name}}/src/presentation/l10n/l10n.dart';
import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}    final title = context.l10n.title;

    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(title),
      ),
    );{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
    {{#isFlow}}    return const AutoRouter();{{/isFlow}}
    {{#isTabFlow}}    return const AutoTabsRouter(
      routes: [
        // TODO: add tab routes here
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/linux}}{{#macos}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
import 'package:{{project_name}}_macos_{{name}}/src/presentation/l10n/l10n.dart';
import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}    final title = context.l10n.title;

    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(title),
      ),
    );{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
    {{#isFlow}}    return const AutoRouter();{{/isFlow}}
    {{#isTabFlow}}    return const AutoTabsRouter(
      routes: [
        // TODO: add tab routes here
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/macos}}{{#web}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';
import 'package:{{project_name}}_web_{{name}}/src/presentation/l10n/l10n.dart';

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}    final title = context.l10n.title;

    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(title),
      ),
    );{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
    {{#isFlow}}    return const AutoRouter();{{/isFlow}}
    {{#isTabFlow}}    return const AutoTabsRouter(
      routes: [
        // TODO: add tab routes here
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/web}}{{#windows}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';
import 'package:{{project_name}}_windows_{{name}}/src/presentation/l10n/l10n.dart';

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}    final title = context.l10n.title;

    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(title),
      ),
    );{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
    {{#isFlow}}    return const AutoRouter();{{/isFlow}}
    {{#isTabFlow}}    return const AutoTabsRouter(
      routes: [
        // TODO: add tab routes here
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/windows}}{{#mobile}}{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}
import 'package:{{project_name}}_ui_mobile/{{project_name}}_ui_mobile.dart';
import 'package:{{project_name}}_mobile_{{name}}/src/presentation/l10n/l10n.dart';

{{#routable}}@RoutePage(){{/routable}}
class {{name.pascalCase()}} extends StatelessWidget {
  const {{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
{{^isFlow}}{{^isTabFlow}}{{^isWidget}}    final title = context.l10n.title;

    return {{project_name.pascalCase()}}Scaffold(
      body: Center(
        child: Text(title),
      ),
    );{{/isWidget}}{{/isTabFlow}}{{/isFlow}}
    {{#isFlow}}    return const AutoRouter();{{/isFlow}}
    {{#isTabFlow}}    return const AutoTabsRouter(
      routes: [
        // TODO: add tab routes here
      ],
    );{{/isTabFlow}}
    {{#isWidget}}    return Container();{{/isWidget}}
  }
}
{{/mobile}}
{{#android}}export '{{name}}.dart';
export 'l10n/{{project_name}}_android_{{name}}_localizations.dart';
{{#routable}}export 'routes.dart';{{/routable}}
{{#routable}}export 'routes.module.dart';{{/routable}}
{{/android}}{{#ios}}
export '{{name}}.dart';
export 'l10n/{{project_name}}_ios_{{name}}_localizations.dart';
{{#routable}}export 'routes.dart';{{/routable}}
{{#routable}}export 'routes.module.dart';{{/routable}}
{{/ios}}{{#linux}}
export '{{name}}.dart';
export 'l10n/{{project_name}}_linux_{{name}}_localizations.dart';
{{#routable}}export 'routes.dart';{{/routable}}
{{#routable}}export 'routes.module.dart';{{/routable}}
{{/linux}}{{#macos}}
export '{{name}}.dart';
export 'l10n/{{project_name}}_macos_{{name}}_localizations.dart';
{{#routable}}export 'routes.dart';{{/routable}}
{{#routable}}export 'routes.module.dart';{{/routable}}
{{/macos}}{{#web}}
export '{{name}}.dart';
export 'l10n/{{project_name}}_web_{{name}}_localizations.dart';
{{#routable}}export 'routes.dart';{{/routable}}
{{#routable}}export 'routes.module.dart';{{/routable}}
{{/web}}{{#windows}}
export '{{name}}.dart';
export 'l10n/{{project_name}}_windows_{{name}}_localizations.dart';
{{#routable}}export 'routes.dart';{{/routable}}
{{#routable}}export 'routes.module.dart';{{/routable}}
{{/windows}}
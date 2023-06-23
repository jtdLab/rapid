{{#android}}export '{{name}}.dart';{{#localization}}export 'l10n/{{project_name}}_android_{{name}}_localizations.dart';{{/localization}}{{#routable}}export 'routes.dart';{{/routable}}{{#routable}}export 'routes.gm.dart';{{/routable}}
{{/android}}{{#ios}}
export '{{name}}.dart';{{#localization}}export 'l10n/{{project_name}}_ios_{{name}}_localizations.dart';{{/localization}}{{#routable}}export 'routes.dart';{{/routable}}{{#routable}}export 'routes.gm.dart';{{/routable}}
{{/ios}}{{#linux}}
export '{{name}}.dart';{{#localization}}export 'l10n/{{project_name}}_linux_{{name}}_localizations.dart';{{/localization}}{{#routable}}export 'routes.dart';{{/routable}}{{#routable}}export 'routes.gm.dart';{{/routable}}
{{/linux}}{{#macos}}
export '{{name}}.dart';{{#localization}}export 'l10n/{{project_name}}_macos_{{name}}_localizations.dart';{{/localization}}{{#routable}}export 'routes.dart';{{/routable}}{{#routable}}export 'routes.gm.dart';{{/routable}}
{{/macos}}{{#web}}
export '{{name}}.dart';{{#localization}}export 'l10n/{{project_name}}_web_{{name}}_localizations.dart';{{/localization}}{{#routable}}export 'routes.dart';{{/routable}}{{#routable}}export 'routes.gm.dart';{{/routable}}
{{/web}}{{#windows}}
export '{{name}}.dart';{{#localization}}export 'l10n/{{project_name}}_windows_{{name}}_localizations.dart';{{/localization}}{{#routable}}export 'routes.dart';{{/routable}}{{#routable}}export 'routes.gm.dart';{{/routable}}
{{/windows}}{{#mobile}}
export '{{name}}.dart';{{#localization}}export 'l10n/{{project_name}}_mobile_{{name}}_localizations.dart';{{/localization}}{{#routable}}export 'routes.dart';{{/routable}}{{#routable}}export 'routes.gm.dart';{{/routable}}
{{/mobile}}
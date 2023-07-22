/// Widgets and themes implementing {{project_name.titleCase()}} design language for {{#android}}Android{{/android}}{{#ios}}iOS{{/ios}}{{#linux}}Linux{{/linux}}{{#macos}}macOS{{/macos}}{{#web}}Web{{/web}}{{#windows}}Windows{{/windows}}{{#mobile}}Mobile{{/mobile}}.
///
/// To use, import `package:{{project_name}}_ui_{{platform}}/{{project_name}}_ui_{{platform}}.dart`.
library {{project_name}}_ui_{{platform}};

{{#android}}export 'package:flutter/material.dart' hide Router;{{/android}}
{{#ios}}export 'package:flutter/cupertino.dart' hide Router;
export 'package:cupertino_icons/cupertino_icons.dart';{{/ios}}
{{#linux}}export 'package:flutter/material.dart' hide Router;
export 'package:yaru/yaru.dart';
export 'package:yaru_icons/yaru_icons.dart';{{/linux}}
{{#macos}}export 'package:cupertino_icons/cupertino_icons.dart';
export 'package:flutter/material.dart' show ThemeMode;
export 'package:flutter/widgets.dart' hide Router;
export 'package:macos_ui/macos_ui.dart';{{/macos}}
{{#web}}export 'package:flutter/material.dart' hide Router;{{/web}}
{{#windows}}export 'package:fluent_ui/fluent_ui.dart' hide Router;{{/windows}}
{{#mobile}}export 'package:flutter/material.dart' hide Router;{{/mobile}}

export 'package:{{project_name}}_ui/{{project_name}}_ui.dart';

export 'src/app.dart';
export 'src/scaffold.dart';
export 'src/scaffold_theme.dart';

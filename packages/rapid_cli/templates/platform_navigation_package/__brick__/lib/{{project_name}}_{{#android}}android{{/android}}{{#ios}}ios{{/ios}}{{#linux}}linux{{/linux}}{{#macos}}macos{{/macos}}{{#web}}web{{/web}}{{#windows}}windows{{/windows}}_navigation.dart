/// The Navigation of {{project_name.titleCase()}} for {{#android}}Android{{/android}}{{#ios}}iOS{{/ios}}{{#linux}}Linux{{/linux}}{{#macos}}macOS{{/macos}}{{#web}}Web{{/web}}{{#windows}}Windows{{/windows}}.
///
/// To use, import `package:{{project_name}}{{#android}}_android_navigation{{/android}}{{#ios}}_ios_navigation{{/ios}}{{#linux}}_linux_navigation{{/linux}}{{#macos}}_macos_navigation{{/macos}}{{#web}}_web_navigation{{/web}}{{#windows}}_windows_navigation{{/windows}}/{{project_name}}{{#android}}_android_navigation{{/android}}{{#ios}}_ios_navigation{{/ios}}{{#linux}}_linux_navigation{{/linux}}{{#macos}}_macos_navigation{{/macos}}{{#web}}_web_navigation{{/web}}{{#windows}}_windows_navigation{{/windows}}.dart`.
{{#android}}library {{project_name}}_android_navigation;{{/android}}{{#ios}}library {{project_name}}_ios_navigation;{{/ios}}{{#linux}}library {{project_name}}_linux_navigation;{{/linux}}{{#macos}}library {{project_name}}_macos_navigation;{{/macos}}{{#web}}library {{project_name}}_web_navigation;{{/web}}{{#windows}}library {{project_name}}_windows_navigation;{{/windows}}

export 'src/i_home_page_navigator.dart';

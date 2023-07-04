/// The {{name.titleCase()}} feature of {{project_name.titleCase()}} for {{#android}}Android{{/android}}{{#ios}}iOS{{/ios}}{{#linux}}Linux{{/linux}}{{#macos}}macOS{{/macos}}{{#web}}Web{{/web}}{{#windows}}Windows{{/windows}}{{#mobile}}Mobile{{/mobile}}.
///
/// To use, import `package:{{project_name}}{{#android}}_android_{{name}}{{/android}}{{#ios}}_ios_{{name}}{{/ios}}{{#linux}}_linux_{{name}}{{/linux}}{{#macos}}_macos_{{name}}{{/macos}}{{#web}}_web_{{name}}{{/web}}{{#windows}}_windows_{{name}}{{/windows}}{{#mobile}}_mobile_{{name}}{{/mobile}}/{{project_name}}{{#android}}_android_{{name}}{{/android}}{{#ios}}_ios_{{name}}{{/ios}}{{#linux}}_linux_{{name}}{{/linux}}{{#macos}}_macos_{{name}}{{/macos}}{{#web}}_web_{{name}}{{/web}}{{#windows}}_windows_{{name}}{{/windows}}{{#mobile}}_mobile_{{name}}{{/mobile}}.dart`.
{{#android}}library {{project_name}}_android_{{name}};{{/android}}{{#ios}}library {{project_name}}_ios_{{name}};{{/ios}}{{#linux}}library {{project_name}}_linux_{{name}};{{/linux}}{{#macos}}library {{project_name}}_macos_{{name}};{{/macos}}{{#web}}library {{project_name}}_web_{{name}};{{/web}}{{#windows}}library {{project_name}}_windows_{{name}};{{/windows}}{{#mobile}}library {{project_name}}_mobile_{{name}};{{/mobile}}

export 'src/injection.module.dart';
export 'src/presentation/presentation.dart';

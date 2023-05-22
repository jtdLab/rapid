/// The App feature of {{project_name.titleCase()}} for {{#android}}Android{{/android}}{{#ios}}iOS{{/ios}}{{#linux}}Linux{{/linux}}{{#macos}}macOS{{/macos}}{{#web}}Web{{/web}}{{#windows}}Windows{{/windows}}{{#mobile}}Mobile{{/mobile}}.
///
/// To use, import `package:{{project_name}}{{#android}}_android_app{{/android}}{{#ios}}_ios_app{{/ios}}{{#linux}}_linux_app{{/linux}}{{#macos}}_macos_app{{/macos}}{{#web}}_web_app{{/web}}{{#windows}}_windows_app{{/windows}}{{#mobile}}_mobile_app{{/mobile}}/{{project_name}}{{#android}}_android_app{{/android}}{{#ios}}_ios_app{{/ios}}{{#linux}}_linux_app{{/linux}}{{#macos}}_macos_app{{/macos}}{{#web}}_web_app{{/web}}{{#windows}}_windows_app{{/windows}}{{#mobile}}_mobile_app{{/mobile}}.dart`.
{{#android}}library {{project_name}}_android_app;{{/android}}{{#ios}}library {{project_name}}_ios_app;{{/ios}}{{#linux}}library {{project_name}}_linux_app;{{/linux}}{{#macos}}library {{project_name}}_macos_app;{{/macos}}{{#web}}library {{project_name}}_web_app;{{/web}}{{#windows}}library {{project_name}}_windows_app;{{/windows}}{{#mobile}}library {{project_name}}_mobile_app;{{/mobile}}

export 'src/injection.module.dart';
export 'src/presentation/presentation.dart';

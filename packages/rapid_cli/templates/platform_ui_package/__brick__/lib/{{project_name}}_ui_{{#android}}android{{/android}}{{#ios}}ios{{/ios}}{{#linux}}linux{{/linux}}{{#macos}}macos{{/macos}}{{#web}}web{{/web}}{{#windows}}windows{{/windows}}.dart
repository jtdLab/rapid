{{#android}}/// Widgets and themes implementing {{project_name.titleCase()}} design language for Android.
///
/// To use, import `package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart`.
library {{project_name}}_ui_android;

export 'package:flutter/material.dart' hide Router;
export 'package:{{project_name}}_ui/{{project_name}}_ui.dart';

export 'src/app.dart';
export 'src/scaffold.dart';
export 'src/scaffold_theme.dart';
{{/android}}{{#ios}}
/// Widgets and themes implementing {{project_name.titleCase()}} design language for iOS.
///
/// To use, import `package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart`.
library {{project_name}}_ui_ios;

export 'package:cupertino_icons/cupertino_icons.dart';
export 'package:flutter/cupertino.dart' hide Router;
export 'package:{{project_name}}_ui/{{project_name}}_ui.dart';

export 'src/app.dart';
export 'src/scaffold.dart';
export 'src/scaffold_theme.dart';
{{/ios}}{{#linux}}
/// Widgets and themes implementing {{project_name.titleCase()}} design language for Linux.
///
/// To use, import `package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart`.
library {{project_name}}_ui_linux;

export 'package:flutter/material.dart' hide Router;
export 'package:{{project_name}}_ui/{{project_name}}_ui.dart';
export 'package:yaru/yaru.dart';
export 'package:yaru_icons/yaru_icons.dart';

export 'src/app.dart';
export 'src/scaffold.dart';
export 'src/scaffold_theme.dart';
{{/linux}}{{#macos}}
/// Widgets and themes implementing {{project_name.titleCase()}} design language for macOS.
///
/// To use, import `package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart`.
library {{project_name}}_ui_macos;

export 'package:cupertino_icons/cupertino_icons.dart';
export 'package:flutter/cupertino.dart' show Brightness;
export 'package:flutter/widgets.dart' hide Router;
export 'package:macos_ui/macos_ui.dart';
export 'package:{{project_name}}_ui/{{project_name}}_ui.dart';

export 'src/app.dart';
export 'src/scaffold.dart';
export 'src/scaffold_theme.dart';
{{/macos}}{{#web}}
/// Widgets and themes implementing {{project_name.titleCase()}} design language for Web.
///
/// To use, import `package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart`.
library {{project_name}}_ui_web;

export 'package:flutter/material.dart' hide Router;
export 'package:{{project_name}}_ui/{{project_name}}_ui.dart';

export 'src/app.dart';
export 'src/scaffold.dart';
export 'src/scaffold_theme.dart';
{{/web}}{{#windows}}
/// Widgets and themes implementing {{project_name.titleCase()}} design language for Windows.
///
/// To use, import `package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart`.
library {{project_name}}_ui_windows;

export 'package:fluent_ui/fluent_ui.dart' hide Router;
export 'package:{{project_name}}_ui/{{project_name}}_ui.dart';

export 'src/app.dart';
export 'src/scaffold.dart';
export 'src/scaffold_theme.dart';
{{/windows}}
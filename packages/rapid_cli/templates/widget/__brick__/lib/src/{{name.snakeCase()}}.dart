{{^android}}{{^ios}}{{^linux}}{{^macos}}{{^web}}{{^windows}}{{^mobile}}import 'package:flutter/widgets.dart';{{/mobile}}{{/windows}}{{/web}}{{/macos}}{{/linux}}{{/ios}}{{/android}}
{{#android}}import 'package:flutter/material.dart';{{/android}}
{{#ios}}import 'package:flutter/cupertino.dart';{{/ios}}
{{#linux}}import 'package:flutter/material.dart';{{/linux}}
{{#macos}}import 'package:flutter/cupertino.dart';{{/macos}}
{{#web}}import 'package:flutter/material.dart';{{/web}}
{{#windows}}import 'package:fluent_ui/fluent_ui.dart';{{/windows}}
{{#mobile}}import 'package:flutter/material.dart';{{/mobile}}

class {{project_name.pascalCase()}}{{name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}{{name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement
    return Container();
  }
}
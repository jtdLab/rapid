import 'package:{{project_name}}_di/{{project_name}}_di.dart';
import 'package:{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}_navigation/{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}_navigation.dart';
import 'package:injectable/injectable.dart';

@{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}
@LazySingleton(as: I{{name.pascalCase()}}Navigator)
class {{name.pascalCase()}}Navigator implements I{{name.pascalCase()}}Navigator {
  // TODO: implement navigation methods
}
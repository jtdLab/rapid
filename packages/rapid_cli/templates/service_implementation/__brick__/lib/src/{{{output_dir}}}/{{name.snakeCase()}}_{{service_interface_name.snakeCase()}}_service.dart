import 'package:injectable/injectable.dart';
import 'package:{{project_name}}_domain{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}/{{project_name}}_domain{{#has_sub_infrastructure_name}}_{{sub_infrastructure_name}}{{/has_sub_infrastructure_name}}.dart';

// TODO: description
@dev
@LazySingleton(as: I{{service_interface_name.pascalCase()}}Service)
class {{name.pascalCase()}}{{service_interface_name.pascalCase()}}Service implements I{{service_interface_name.pascalCase()}}Service {
  // TODO: implement
}
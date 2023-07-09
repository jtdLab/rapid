// TODO: currently its not possible to resolve a project completly because
// 1. cant distinct feature types and custom feature, entity and value objects, widgets and not widgets files
// -> could be solved by maintaining a graph of the project in a  .lock file or smth

// TODO maybe rename AppModule to AppDirectory

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:rapid_cli/src/utils.dart';

import '../io.dart';
import '../mason.dart' as mason;
import '../project_config.dart';
import 'bundles/bundles.dart';

part 'app_module/app_module.dart';
part 'app_module/bloc.dart';
part 'app_module/cubit.dart';
part 'app_module/data_transfer_object.dart';
part 'app_module/di_package.dart';
part 'app_module/domain_directory.dart';
part 'app_module/domain_package.dart';
part 'app_module/entity.dart';
part 'app_module/infrastructure_directory.dart';
part 'app_module/infrastructure_package.dart';
part 'app_module/logging_package.dart';
part 'app_module/navigator_implementation.dart';
part 'app_module/navigator_interface.dart';
part 'app_module/platform_directory.dart';
part 'app_module/platform_feature_package.dart';
part 'app_module/platform_features_directory.dart';
part 'app_module/platform_localization_package.dart';
part 'app_module/platform_native_directory.dart';
part 'app_module/platform_navigation_package.dart';
part 'app_module/platform_root_package.dart';
part 'app_module/service_implementation.dart';
part 'app_module/service_interface.dart';
part 'app_module/value_object.dart';
part 'root_package.dart';
part 'ui_module/platform_ui_package.dart';
part 'ui_module/ui_module.dart';
part 'ui_module/ui_package.dart';
part 'ui_module/widget.dart';

class RapidProject {
  RapidProject({
    required this.name,
    required this.path,
    required this.rootPackage,
    required this.uiModule,
    required this.appModule,
  });

  factory RapidProject.fromConfig(RapidProjectConfig config) {
    final name = config.name;
    final path = config.path;
    final rootPackage =
        RootPackage.resolve(projectName: name, projectPath: path);
    final appModule = AppModule.resolve(projectName: name, projectPath: path);
    final uiModule = UiModule.resolve(projectName: name, projectPath: path);

    return RapidProject(
      name: name,
      path: path,
      rootPackage: rootPackage,
      appModule: appModule,
      uiModule: uiModule,
    );
  }

  final String path;

  final String name;

  final RootPackage rootPackage;

  final AppModule appModule;

  final UiModule uiModule;
}

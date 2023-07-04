import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../base.dart';

class DeactivatePlatformCommand extends RapidLeafCommand {
  DeactivatePlatformCommand(this.platform, super.project);

  final Platform platform;

  @override
  String get name => platform.name;

  @override
  List<String> get aliases => platform.aliases;

  @override
  String get invocation => 'rapid deactivate ${platform.name}';

  @override
  String get description =>
      'Removes support for ${platform.prettyName} from this project.';

  @override
  Future<void> run() async {
    return rapid.deactivatePlatform(platform);
  }
}

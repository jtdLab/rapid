import 'package:rapid_cli/src/command_runner/util/platform_x.dart';
import 'package:rapid_cli/src/project/platform.dart';

import '../../../base.dart';
import '../../../util/class_name_rest.dart';

// TODO add platform specific stuff to the tempalte

const _defaultTheme = true;

class UiPlatformAddWidgetCommand extends RapidLeafCommand with ClassNameGetter {
  UiPlatformAddWidgetCommand(this.platform, super.project) {
    argParser.addFlag(
      'theme',
      help: 'Wheter the new widget has its own theme.',
      defaultsTo: _defaultTheme,
    );
  }

  final Platform platform;

  @override
  String get name => 'widget';

  @override
  String get invocation =>
      'rapid ui ${platform.name} add widget <name> [arguments]';

  @override
  String get description =>
      'Add a widget to the ${platform.prettyName} UI part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.className;
    final theme = argResults['theme'] ?? _defaultTheme;

    return rapid.uiPlatformAddWidget(platform, name: name, theme: theme);
  }
}

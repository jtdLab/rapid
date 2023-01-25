import 'package:args/command_runner.dart';
import 'package:rapid_cli/src/commands/activate/android/android.dart';
import 'package:rapid_cli/src/commands/activate/ios/ios.dart';
import 'package:rapid_cli/src/commands/activate/linux/linux.dart';
import 'package:rapid_cli/src/commands/activate/macos/macos.dart';
import 'package:rapid_cli/src/commands/activate/web/web.dart';
import 'package:rapid_cli/src/commands/activate/windows/windows.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template activate_platform_command}
/// Base class for:
///
///  * [ActivateAndroidCommand]
///
///  * [ActivateIosCommand]
///
///  * [ActivateLinuxCommand]
///
///  * [ActivateMacosCommand]
///
///  * [ActivateWebCommand]
///
///  * [ActivateWindowsCommand]
/// {@endtemplate}
abstract class ActivatePlatformCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro activate_platform_command}
  ActivatePlatformCommand({
    required this.platform,
  });

  final Platform platform;

  @override
  String get name => platform.name;

  @override
  List<String> get aliases => platform.aliases;

  @override
  String get invocation => 'rapid activate ${platform.name}';

  @override
  String get description =>
      'Adds support for ${platform.prettyName} to this project.';
}

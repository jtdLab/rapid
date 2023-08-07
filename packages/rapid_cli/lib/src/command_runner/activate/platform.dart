import '../../utils.dart';
import '../base.dart';
import 'android.dart';
import 'ios.dart';
import 'linux.dart';
import 'macos.dart';
import 'mobile.dart';
import 'web.dart';
import 'windows.dart';

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
///  * [ActivateMobileCommand]
///
///  * [ActivateWebCommand]
///
///  * [ActivateWindowsCommand]
/// {@endtemplate}
abstract class ActivatePlatformCommand extends RapidPlatformLeafCommand {
  /// {@macro activate_platform_command}
  ActivatePlatformCommand(
    super.project, {
    required super.platform,
  });

  @override
  String get name => platform.name;

  @override
  List<String> get aliases => platform.aliases;

  @override
  String get invocation => 'rapid activate ${platform.name}';

  @override
  String get description =>
      'Add support for ${platform.prettyName} to this project.';
}

import '../../project/platform.dart';
import '../base.dart';
import '../util/platform_x.dart';
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
abstract class ActivatePlatformCommand extends RapidLeafCommand {
  /// {@macro activate_platform_command}
  ActivatePlatformCommand(
    super.project, {
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

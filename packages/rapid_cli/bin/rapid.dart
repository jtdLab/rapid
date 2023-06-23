import 'package:cli_launcher/cli_launcher.dart';
import 'package:rapid_cli/src/command_runner.dart';

Future<void> main(List<String> arguments) async => launchExecutable(
      arguments,
      LaunchConfig(
        name: ExecutableName('rapid', package: 'rapid_cli'),
        launchFromSelf: false,
        entrypoint: rapidEntryPoint,
      ),
    );

import 'package:mason/mason.dart';

extension LoggerX on Logger {
  commandTitle(String text) {
    info('${lightYellow.wrap('⚡')}${lightBlue.wrap(styleBold.wrap(text))}');
  }

  commandSuccess([String? text]) {
    this
      ..info('')
      ..success(text ?? 'Success!')
      ..info('');
  }

  commandError(String text) {
    this
      ..info('')
      ..err(text);
  }
}

import 'package:injectable/injectable.dart';

/// Used to annotate dependencies which are registered under certain platforms.
abstract class Platform {
  static const android = 'android';

  static const ios = 'ios';

  static const web = 'web';

  static const linux = 'linux';

  static const macos = 'macos';

  static const windows = 'windows';
}

/// Use this to annotate Android dependencies.
const android = Environment(Platform.android);

/// Use this to annotate iOS dependencies.
const ios = Environment(Platform.ios);

/// Use this to annotate Web dependencies.
const web = Environment(Platform.web);

/// Use this to annotate Linux dependencies.
const linux = Environment(Platform.linux);

/// Use this to annotate macOS dependencies.
const macos = Environment(Platform.macos);

/// Use this to annotate Windows dependencies.
const windows = Environment(Platform.windows);

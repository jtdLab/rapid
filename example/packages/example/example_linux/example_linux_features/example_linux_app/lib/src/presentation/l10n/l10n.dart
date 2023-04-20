// coverage:ignore-file
import 'package:flutter/widgets.dart';

import 'example_linux_app_localizations.dart';

export 'example_linux_app_localizations.dart';

extension ExampleLinuxAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  ExampleLinuxAppLocalizations get l10n =>
      ExampleLinuxAppLocalizations.of(this);
}

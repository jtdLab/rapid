// coverage:ignore-file
import 'package:flutter/widgets.dart';

import 'example_windows_app_localizations.dart';

export 'example_windows_app_localizations.dart';

extension ExampleWindowsAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  ExampleWindowsAppLocalizations get l10n =>
      ExampleWindowsAppLocalizations.of(this);
}

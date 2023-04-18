// coverage:ignore-file
import 'package:flutter/widgets.dart';

import 'example_android_app_localizations.dart';

export 'example_android_app_localizations.dart';

extension ExampleAndroidAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  ExampleAndroidAppLocalizations get l10n =>
      ExampleAndroidAppLocalizations.of(this);
}

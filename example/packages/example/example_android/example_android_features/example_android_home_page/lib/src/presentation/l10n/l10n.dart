// coverage:ignore-file
import 'package:flutter/widgets.dart';

import 'example_android_home_page_localizations.dart';

export 'example_android_home_page_localizations.dart';

extension ExampleAndroidHomePageLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  ExampleAndroidHomePageLocalizations get l10n =>
      ExampleAndroidHomePageLocalizations.of(this);
}

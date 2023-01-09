import 'package:flutter/widgets.dart';

import 'test_app_android_home_page_localizations.dart';

extension TestAppAndroidHomePageLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  TestAppAndroidHomePageLocalizations get l10n =>
      TestAppAndroidHomePageLocalizations.of(this);
}

import 'package:flutter/widgets.dart';

import 'test_app_ios_home_page_localizations.dart';

extension TestAppIosHomePageLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  TestAppIosHomePageLocalizations get l10n =>
      TestAppIosHomePageLocalizations.of(this);
}

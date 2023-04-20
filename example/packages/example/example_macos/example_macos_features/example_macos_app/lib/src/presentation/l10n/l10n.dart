// coverage:ignore-file
import 'package:flutter/widgets.dart';

import 'example_macos_app_localizations.dart';

export 'example_macos_app_localizations.dart';

extension ExampleMacosAppLocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  ExampleMacosAppLocalizations get l10n =>
      ExampleMacosAppLocalizations.of(this);
}

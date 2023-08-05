import 'package:flutter/widgets.dart';

import '{{project_name}}_localizations.dart';

extension {{project_name.pascalCase()}}LocalizationsX on BuildContext {
  /// The l10n object which holds all localized strings.
  {{project_name.pascalCase()}}Localizations get l10n =>
      {{project_name.pascalCase()}}Localizations.of(this);
}

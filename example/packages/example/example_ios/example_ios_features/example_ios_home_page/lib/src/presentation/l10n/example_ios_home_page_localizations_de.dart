// coverage:ignore-file

import 'example_ios_home_page_localizations.dart';

/// The translations for German (`de`).
class ExampleIosHomePageLocalizationsDe
    extends ExampleIosHomePageLocalizations {
  ExampleIosHomePageLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get errorServer => 'Serverfehler. Versuchen Sie es später erneut.';

  @override
  String get errorNotFound => 'Ressource nicht gefunden.';
}

// coverage:ignore-file

import 'example_ios_home_page_localizations.dart';

/// The translations for English (`en`).
class ExampleIosHomePageLocalizationsEn
    extends ExampleIosHomePageLocalizations {
  ExampleIosHomePageLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get errorServer => 'Server error. Try again later.';

  @override
  String get errorNotFound => 'Resource not found.';
}

// coverage:ignore-file

import 'example_ios_login_page_localizations.dart';

/// The translations for German (`de`).
class ExampleIosLoginPageLocalizationsDe
    extends ExampleIosLoginPageLocalizations {
  ExampleIosLoginPageLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get login => 'Anmelden';

  @override
  String get signUpNow => 'Jetzt registrieren';

  @override
  String get orSignInWith => 'Oder anmelden mit';

  @override
  String get dontHaveAnAccount => 'Sie haben noch kein Konto?';

  @override
  String get errorServer => 'Serverfehler. Versuchen Sie es später erneut.';

  @override
  String get errorInvalidUsernameAndPasswordCombination =>
      'Ungültiger Benutzername oder Passwort.';
}

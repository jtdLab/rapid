// coverage:ignore-file

import 'example_ios_sign_up_page_localizations.dart';

/// The translations for German (`de`).
class ExampleIosSignUpPageLocalizationsDe
    extends ExampleIosSignUpPageLocalizations {
  ExampleIosSignUpPageLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get email => 'E-Mail-Adresse';

  @override
  String get errorInvalidEmailAddress => 'Ungültige E-Mail-Adresse.';

  @override
  String get username => 'Benutzername';

  @override
  String get errorInvalidUsername =>
      'Ungültiger Benutzername. Bitte verwenden Sie 3-15 Zeichen und nur Buchstaben, Zahlen, ., -, und _.';

  @override
  String get password => 'Passwort';

  @override
  String get errorInvalidPassword =>
      'Ungültiges Passwort. Bitte verwenden Sie 6-32 Zeichen (keine Leerzeichen).';

  @override
  String get passwordAgain => 'Passwort erneut';

  @override
  String get errorPasswordsDontMatch => 'Passwörter stimmen nicht überein.';

  @override
  String get signUp => 'Registrieren';

  @override
  String get login => 'Anmelden';

  @override
  String get alreadyHaveAnAccount => 'Haben Sie bereits ein Konto?';

  @override
  String get errorServer => 'Serverfehler. Versuchen Sie es später erneut.';

  @override
  String get errorEmailAlreadyInUse => 'E-Mail-Adresse wird bereits verwendet.';

  @override
  String get errorUsernameAlreadyInUse =>
      'Benutzername wird bereits verwendet.';
}

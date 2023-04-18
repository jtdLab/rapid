// coverage:ignore-file

import 'example_ios_sign_up_page_localizations.dart';

/// The translations for English (`en`).
class ExampleIosSignUpPageLocalizationsEn extends ExampleIosSignUpPageLocalizations {
  ExampleIosSignUpPageLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get email => 'Email address';

  @override
  String get errorInvalidEmailAddress => 'Invalid email';

  @override
  String get errorInvalidEmailAndPasswordCombination => 'Invalid email or password';

  @override
  String get username => 'Username';

  @override
  String get errorInvalidUsername => 'errorInvalidUsername - en';

  @override
  String get password => 'Password';

  @override
  String get errorInvalidPassword => 'errorInvalidPassword - en';

  @override
  String get passwordAgain => 'Password again';

  @override
  String get errorPasswordsDontMatch => 'Passwords don\'t match';

  @override
  String get signUp => 'Sign up';

  @override
  String get signIn => 'Sign in';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';
}

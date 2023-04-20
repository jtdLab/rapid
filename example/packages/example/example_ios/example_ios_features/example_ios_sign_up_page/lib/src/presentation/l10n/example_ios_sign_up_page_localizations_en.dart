// coverage:ignore-file

import 'example_ios_sign_up_page_localizations.dart';

/// The translations for English (`en`).
class ExampleIosSignUpPageLocalizationsEn extends ExampleIosSignUpPageLocalizations {
  ExampleIosSignUpPageLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get email => 'Email address';

  @override
  String get errorInvalidEmailAddress => 'Invalid email.';

  @override
  String get username => 'Username';

  @override
  String get errorInvalidUsername => 'Invalid username. Please use 3-15 characters and only include letters, numbers, ., -, and _.';

  @override
  String get password => 'Password';

  @override
  String get errorInvalidPassword => 'Invalid password. Please use 6-32 non-white space characters.';

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

  @override
  String get errorServer => 'Server error. Try again later.';

  @override
  String get errorEmailAlreadyInUse => 'Email already in use.';

  @override
  String get errorUsernameAlreadyInUse => 'Username already in use.';
}

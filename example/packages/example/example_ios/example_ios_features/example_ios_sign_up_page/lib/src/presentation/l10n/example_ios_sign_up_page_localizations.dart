// coverage:ignore-file
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'example_ios_sign_up_page_localizations_en.dart';

/// Callers can lookup localized strings with an instance of ExampleIosSignUpPageLocalizations
/// returned by `ExampleIosSignUpPageLocalizations.of(context)`.
///
/// Applications need to include `ExampleIosSignUpPageLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/example_ios_sign_up_page_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ExampleIosSignUpPageLocalizations.localizationsDelegates,
///   supportedLocales: ExampleIosSignUpPageLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the ExampleIosSignUpPageLocalizations.supportedLocales
/// property.
abstract class ExampleIosSignUpPageLocalizations {
  ExampleIosSignUpPageLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ExampleIosSignUpPageLocalizations of(BuildContext context) {
    return Localizations.of<ExampleIosSignUpPageLocalizations>(
        context, ExampleIosSignUpPageLocalizations)!;
  }

  static const LocalizationsDelegate<ExampleIosSignUpPageLocalizations>
      delegate = _ExampleIosSignUpPageLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email;

  /// No description provided for @errorInvalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid email.'**
  String get errorInvalidEmailAddress;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @errorInvalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Invalid username. Please use 3-15 characters and only include letters, numbers, ., -, and _.'**
  String get errorInvalidUsername;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @errorInvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid password. Please use 6-32 non-white space characters.'**
  String get errorInvalidPassword;

  /// No description provided for @passwordAgain.
  ///
  /// In en, this message translates to:
  /// **'Password again'**
  String get passwordAgain;

  /// No description provided for @errorPasswordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match.'**
  String get errorPasswordsDontMatch;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Try again later.'**
  String get errorServer;

  /// No description provided for @errorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Email already in use.'**
  String get errorEmailAlreadyInUse;

  /// No description provided for @errorUsernameAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Username already in use.'**
  String get errorUsernameAlreadyInUse;
}

class _ExampleIosSignUpPageLocalizationsDelegate
    extends LocalizationsDelegate<ExampleIosSignUpPageLocalizations> {
  const _ExampleIosSignUpPageLocalizationsDelegate();

  @override
  Future<ExampleIosSignUpPageLocalizations> load(Locale locale) {
    return SynchronousFuture<ExampleIosSignUpPageLocalizations>(
        lookupExampleIosSignUpPageLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_ExampleIosSignUpPageLocalizationsDelegate old) => false;
}

ExampleIosSignUpPageLocalizations lookupExampleIosSignUpPageLocalizations(
    Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ExampleIosSignUpPageLocalizationsEn();
  }

  throw FlutterError(
      'ExampleIosSignUpPageLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

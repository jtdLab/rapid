// coverage:ignore-file
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'example_ios_home_page_localizations_en.dart';

/// Callers can lookup localized strings with an instance of ExampleIosHomePageLocalizations
/// returned by `ExampleIosHomePageLocalizations.of(context)`.
///
/// Applications need to include `ExampleIosHomePageLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/example_ios_home_page_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ExampleIosHomePageLocalizations.localizationsDelegates,
///   supportedLocales: ExampleIosHomePageLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ExampleIosHomePageLocalizations.supportedLocales
/// property.
abstract class ExampleIosHomePageLocalizations {
  ExampleIosHomePageLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ExampleIosHomePageLocalizations of(BuildContext context) {
    return Localizations.of<ExampleIosHomePageLocalizations>(
        context, ExampleIosHomePageLocalizations)!;
  }

  static const LocalizationsDelegate<ExampleIosHomePageLocalizations> delegate =
      _ExampleIosHomePageLocalizationsDelegate();

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

  /// Title text shown in the Home Page
  ///
  /// In en, this message translates to:
  /// **'Home Page title for en'**
  String get title;
}

class _ExampleIosHomePageLocalizationsDelegate
    extends LocalizationsDelegate<ExampleIosHomePageLocalizations> {
  const _ExampleIosHomePageLocalizationsDelegate();

  @override
  Future<ExampleIosHomePageLocalizations> load(Locale locale) {
    return SynchronousFuture<ExampleIosHomePageLocalizations>(
        lookupExampleIosHomePageLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_ExampleIosHomePageLocalizationsDelegate old) => false;
}

ExampleIosHomePageLocalizations lookupExampleIosHomePageLocalizations(
    Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ExampleIosHomePageLocalizationsEn();
  }

  throw FlutterError(
      'ExampleIosHomePageLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

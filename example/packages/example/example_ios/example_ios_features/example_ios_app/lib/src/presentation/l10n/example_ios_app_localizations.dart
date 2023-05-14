// coverage:ignore-file
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'example_ios_app_localizations_de.dart';
import 'example_ios_app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of ExampleIosAppLocalizations
/// returned by `ExampleIosAppLocalizations.of(context)`.
///
/// Applications need to include `ExampleIosAppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/example_ios_app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ExampleIosAppLocalizations.localizationsDelegates,
///   supportedLocales: ExampleIosAppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ExampleIosAppLocalizations.supportedLocales
/// property.
abstract class ExampleIosAppLocalizations {
  ExampleIosAppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ExampleIosAppLocalizations of(BuildContext context) {
    return Localizations.of<ExampleIosAppLocalizations>(
        context, ExampleIosAppLocalizations)!;
  }

  static const LocalizationsDelegate<ExampleIosAppLocalizations> delegate =
      _ExampleIosAppLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];
}

class _ExampleIosAppLocalizationsDelegate
    extends LocalizationsDelegate<ExampleIosAppLocalizations> {
  const _ExampleIosAppLocalizationsDelegate();

  @override
  Future<ExampleIosAppLocalizations> load(Locale locale) {
    return SynchronousFuture<ExampleIosAppLocalizations>(
        lookupExampleIosAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_ExampleIosAppLocalizationsDelegate old) => false;
}

ExampleIosAppLocalizations lookupExampleIosAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return ExampleIosAppLocalizationsDe();
    case 'en':
      return ExampleIosAppLocalizationsEn();
  }

  throw FlutterError(
      'ExampleIosAppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant Scan'**
  String get scanTitle;

  /// No description provided for @analyzingImage.
  ///
  /// In en, this message translates to:
  /// **'Analyzing image...'**
  String get analyzingImage;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @previewImage.
  ///
  /// In en, this message translates to:
  /// **'Image Preview'**
  String get previewImage;

  /// No description provided for @selectPlant.
  ///
  /// In en, this message translates to:
  /// **'Select Plant'**
  String get selectPlant;

  /// No description provided for @scanTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Tips'**
  String get scanTipsTitle;

  /// No description provided for @tipGoodLighting.
  ///
  /// In en, this message translates to:
  /// **'Ensure good lighting'**
  String get tipGoodLighting;

  /// No description provided for @tipFocusArea.
  ///
  /// In en, this message translates to:
  /// **'Focus on affected area'**
  String get tipFocusArea;

  /// No description provided for @tipKeepStable.
  ///
  /// In en, this message translates to:
  /// **'Keep the camera steady'**
  String get tipKeepStable;

  /// No description provided for @tipWholePlant.
  ///
  /// In en, this message translates to:
  /// **'Capture the whole plant'**
  String get tipWholePlant;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @settingsAndInfo.
  ///
  /// In en, this message translates to:
  /// **'Settings & Info'**
  String get settingsAndInfo;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @howToScanPlant.
  ///
  /// In en, this message translates to:
  /// **'How to scan a plant?'**
  String get howToScanPlant;

  /// No description provided for @howToScanPlantDesc.
  ///
  /// In en, this message translates to:
  /// **'Open the Scan menu, point the camera at the plant you want to scan, and follow the on-screen instructions.'**
  String get howToScanPlantDesc;

  /// No description provided for @howToViewHistory.
  ///
  /// In en, this message translates to:
  /// **'How to view scan history?'**
  String get howToViewHistory;

  /// No description provided for @howToViewHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Click the History menu at the bottom of the app to see all previous scan results.'**
  String get howToViewHistoryDesc;

  /// No description provided for @howToContactSupport.
  ///
  /// In en, this message translates to:
  /// **'How to contact support?'**
  String get howToContactSupport;

  /// No description provided for @howToContactSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Send an email to support@tanipintar.id or call us at 0822-1234-5678.'**
  String get howToContactSupportDesc;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get rateApp;

  /// No description provided for @howSatisfied.
  ///
  /// In en, this message translates to:
  /// **'How satisfied are you with our app?'**
  String get howSatisfied;

  /// No description provided for @verySatisfied.
  ///
  /// In en, this message translates to:
  /// **'😊 Very Satisfied'**
  String get verySatisfied;

  /// No description provided for @satisfied.
  ///
  /// In en, this message translates to:
  /// **'🙂 Satisfied'**
  String get satisfied;

  /// No description provided for @lessSatisfied.
  ///
  /// In en, this message translates to:
  /// **'😕 Less Satisfied'**
  String get lessSatisfied;

  /// No description provided for @selectRating.
  ///
  /// In en, this message translates to:
  /// **'Select a rating (1-5 stars)'**
  String get selectRating;

  /// No description provided for @reviewCategories.
  ///
  /// In en, this message translates to:
  /// **'Review Categories'**
  String get reviewCategories;

  /// No description provided for @usability.
  ///
  /// In en, this message translates to:
  /// **'Usability'**
  String get usability;

  /// No description provided for @detectionAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Detection Accuracy'**
  String get detectionAccuracy;

  /// No description provided for @appAppearance.
  ///
  /// In en, this message translates to:
  /// **'App Appearance'**
  String get appAppearance;

  /// No description provided for @appFeatures.
  ///
  /// In en, this message translates to:
  /// **'App Features'**
  String get appFeatures;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// No description provided for @shareYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience using this app...'**
  String get shareYourExperience;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank You!'**
  String get thankYou;

  /// No description provided for @reviewSaved.
  ///
  /// In en, this message translates to:
  /// **'Your review has been saved successfully'**
  String get reviewSaved;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @sendReview.
  ///
  /// In en, this message translates to:
  /// **'Send Review'**
  String get sendReview;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required'**
  String get cameraPermissionRequired;

  /// No description provided for @cameraNotFound.
  ///
  /// In en, this message translates to:
  /// **'Camera not found'**
  String get cameraNotFound;

  /// No description provided for @storagePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required'**
  String get storagePermissionRequired;

  /// No description provided for @cameraNotReady.
  ///
  /// In en, this message translates to:
  /// **'Camera is not ready'**
  String get cameraNotReady;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Farming App'**
  String get appTitle;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, Farmer!'**
  String get greeting;

  /// No description provided for @greetingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to your smart farming assistant.'**
  String get greetingSubtitle;

  /// No description provided for @quickScan.
  ///
  /// In en, this message translates to:
  /// **'Quick Scan'**
  String get quickScan;

  /// No description provided for @quickScanDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan your plants quickly and easily.'**
  String get quickScanDesc;

  /// No description provided for @noRecentAnalysis.
  ///
  /// In en, this message translates to:
  /// **'No recent analysis available.'**
  String get noRecentAnalysis;

  /// No description provided for @recentAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Recent Analysis'**
  String get recentAnalysis;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sq.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('en'),
    Locale('sq'),
  ];

  /// No description provided for @onboarding_screen1_headline.
  ///
  /// In en, this message translates to:
  /// **'Your baby’s first bites matter more than you think.'**
  String get onboarding_screen1_headline;

  /// No description provided for @onboarding_screen1_subtext.
  ///
  /// In en, this message translates to:
  /// **'Let’s make them joyful, safe, and stress-free, together.'**
  String get onboarding_screen1_subtext;

  /// No description provided for @onboarding_screen1_cta.
  ///
  /// In en, this message translates to:
  /// **'Let’s Start'**
  String get onboarding_screen1_cta;

  /// No description provided for @onboarding_screen1_secondary_button.
  ///
  /// In en, this message translates to:
  /// **'I ALREADY HAVE AN ACCOUNT'**
  String get onboarding_screen1_secondary_button;

  /// No description provided for @onboarding_screen2_headline.
  ///
  /// In en, this message translates to:
  /// **'The first 1,000 days shape your baby’s health for life.'**
  String get onboarding_screen2_headline;

  /// No description provided for @onboarding_screen2_subtext.
  ///
  /// In en, this message translates to:
  /// **'From brain development to immunity, early nutrition makes all the difference. Niblin helps you get it right.'**
  String get onboarding_screen2_subtext;

  /// No description provided for @onboarding_screen2_cta.
  ///
  /// In en, this message translates to:
  /// **'Show Me How'**
  String get onboarding_screen2_cta;

  /// No description provided for @onboarding_screen3_headline.
  ///
  /// In en, this message translates to:
  /// **'Confused about what to feed next?'**
  String get onboarding_screen3_headline;

  /// No description provided for @onboarding_screen3_subtext.
  ///
  /// In en, this message translates to:
  /// **'Most parents spend hours searching, only to find conflicting advice. Niblin gives you clear, stage-based guidance you can trust.'**
  String get onboarding_screen3_subtext;

  /// No description provided for @onboarding_screen3_cta.
  ///
  /// In en, this message translates to:
  /// **'See the Difference'**
  String get onboarding_screen3_cta;

  /// No description provided for @onboarding_screen4_headline.
  ///
  /// In en, this message translates to:
  /// **'Everything you need, in one app.'**
  String get onboarding_screen4_headline;

  /// No description provided for @onboarding_screen4_bullet1.
  ///
  /// In en, this message translates to:
  /// **'Age-based recipes for every stage'**
  String get onboarding_screen4_bullet1;

  /// No description provided for @onboarding_screen4_bullet2.
  ///
  /// In en, this message translates to:
  /// **'Track foods & allergy reactions'**
  String get onboarding_screen4_bullet2;

  /// No description provided for @onboarding_screen4_bullet3.
  ///
  /// In en, this message translates to:
  /// **'Plan meals & auto-generate shopping lists'**
  String get onboarding_screen4_bullet3;

  /// No description provided for @onboarding_screen4_cta.
  ///
  /// In en, this message translates to:
  /// **'Let’s Personalize Your Plan'**
  String get onboarding_screen4_cta;

  /// No description provided for @onboarding_screen5_headline.
  ///
  /// In en, this message translates to:
  /// **'Let’s start with your little one.'**
  String get onboarding_screen5_headline;

  /// No description provided for @onboarding_screen5_field_name.
  ///
  /// In en, this message translates to:
  /// **'Baby’s name'**
  String get onboarding_screen5_field_name;

  /// No description provided for @onboarding_screen5_field_dob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get onboarding_screen5_field_dob;

  /// No description provided for @onboarding_screen5_field_feeding_style.
  ///
  /// In en, this message translates to:
  /// **'Feeding style (Purees, BLW, Mixed)'**
  String get onboarding_screen5_field_feeding_style;

  /// No description provided for @onboarding_screen5_cta.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboarding_screen5_cta;

  /// No description provided for @onboarding_screen6_headline.
  ///
  /// In en, this message translates to:
  /// **'90% of brain development happens by age 5.'**
  String get onboarding_screen6_headline;

  /// No description provided for @onboarding_screen6_subtext.
  ///
  /// In en, this message translates to:
  /// **'We tailor recipes to your baby’s stage to fuel growth and learning.'**
  String get onboarding_screen6_subtext;

  /// No description provided for @onboarding_screen6_cta.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_screen6_cta;

  /// No description provided for @onboarding_screen7_headline.
  ///
  /// In en, this message translates to:
  /// **'Any allergies or preferences we should know?'**
  String get onboarding_screen7_headline;

  /// No description provided for @onboarding_screen7_option_dairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get onboarding_screen7_option_dairy;

  /// No description provided for @onboarding_screen7_option_eggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get onboarding_screen7_option_eggs;

  /// No description provided for @onboarding_screen7_option_peanuts.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get onboarding_screen7_option_peanuts;

  /// No description provided for @onboarding_screen7_option_wheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get onboarding_screen7_option_wheat;

  /// No description provided for @onboarding_screen7_option_other.
  ///
  /// In en, this message translates to:
  /// **'Other (multi-select)'**
  String get onboarding_screen7_option_other;

  /// No description provided for @onboarding_screen7_cta.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_screen7_cta;

  /// No description provided for @onboarding_screen8_headline.
  ///
  /// In en, this message translates to:
  /// **'Introducing variety early can prevent picky eating later.'**
  String get onboarding_screen8_headline;

  /// No description provided for @onboarding_screen8_subtext.
  ///
  /// In en, this message translates to:
  /// **'We guide you on the right foods, at the right time.'**
  String get onboarding_screen8_subtext;

  /// No description provided for @onboarding_screen8_cta.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboarding_screen8_cta;

  /// No description provided for @onboarding_screen9_headline.
  ///
  /// In en, this message translates to:
  /// **'What matters most to you?'**
  String get onboarding_screen9_headline;

  /// No description provided for @onboarding_screen9_option_growth.
  ///
  /// In en, this message translates to:
  /// **'Healthy growth'**
  String get onboarding_screen9_option_growth;

  /// No description provided for @onboarding_screen9_option_picky.
  ///
  /// In en, this message translates to:
  /// **'Preventing picky eating'**
  String get onboarding_screen9_option_picky;

  /// No description provided for @onboarding_screen9_option_allergen.
  ///
  /// In en, this message translates to:
  /// **'Allergen safety'**
  String get onboarding_screen9_option_allergen;

  /// No description provided for @onboarding_screen9_option_planning.
  ///
  /// In en, this message translates to:
  /// **'Meal planning help'**
  String get onboarding_screen9_option_planning;

  /// No description provided for @onboarding_screen9_cta.
  ///
  /// In en, this message translates to:
  /// **'See My Baby’s Plan'**
  String get onboarding_screen9_cta;

  /// No description provided for @onboarding_screen10_headline.
  ///
  /// In en, this message translates to:
  /// **'Your baby’s first week of meals is ready!'**
  String get onboarding_screen10_headline;

  /// No description provided for @onboarding_screen10_subtext.
  ///
  /// In en, this message translates to:
  /// **'Based on your baby’s age, preferences, and goals, we’ve picked the perfect starting recipes.'**
  String get onboarding_screen10_subtext;

  /// No description provided for @onboarding_screen10_recipe1.
  ///
  /// In en, this message translates to:
  /// **'Banana Oat Porridge'**
  String get onboarding_screen10_recipe1;

  /// No description provided for @onboarding_screen10_recipe2.
  ///
  /// In en, this message translates to:
  /// **'Sweet Potato Fingers'**
  String get onboarding_screen10_recipe2;

  /// No description provided for @onboarding_screen10_recipe3.
  ///
  /// In en, this message translates to:
  /// **'Apple Cinnamon Mash'**
  String get onboarding_screen10_recipe3;

  /// No description provided for @onboarding_screen10_cta.
  ///
  /// In en, this message translates to:
  /// **'Unlock My Plan'**
  String get onboarding_screen10_cta;

  /// No description provided for @onboarding_screen11_headline.
  ///
  /// In en, this message translates to:
  /// **'Give your baby the best start — without the stress.'**
  String get onboarding_screen11_headline;

  /// No description provided for @onboarding_screen11_bullet1.
  ///
  /// In en, this message translates to:
  /// **'Expert-vetted recipes for every stage'**
  String get onboarding_screen11_bullet1;

  /// No description provided for @onboarding_screen11_bullet2.
  ///
  /// In en, this message translates to:
  /// **'Personalized weekly meal plans'**
  String get onboarding_screen11_bullet2;

  /// No description provided for @onboarding_screen11_bullet3.
  ///
  /// In en, this message translates to:
  /// **'Food & allergy tracker'**
  String get onboarding_screen11_bullet3;

  /// No description provided for @onboarding_screen11_bullet4.
  ///
  /// In en, this message translates to:
  /// **'Time-saving shopping lists'**
  String get onboarding_screen11_bullet4;

  /// No description provided for @onboarding_screen11_pricing_highlight.
  ///
  /// In en, this message translates to:
  /// **'Highlight yearly plan (Save 40%), then monthly option.'**
  String get onboarding_screen11_pricing_highlight;

  /// No description provided for @onboarding_screen11_guarantee.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime. 7-day money-back guarantee.'**
  String get onboarding_screen11_guarantee;

  /// No description provided for @onboarding_screen11_cta.
  ///
  /// In en, this message translates to:
  /// **'Unlock My Plan'**
  String get onboarding_screen11_cta;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInToContinueToNiblin.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to Niblin'**
  String get signInToContinueToNiblin;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @youExampleCom.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get youExampleCom;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @enterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterAValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @minimum6Characters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get minimum6Characters;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signIn;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE WITH GOOGLE'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE WITH APPLE'**
  String get continueWithApple;

  /// No description provided for @bySigningInYouAgreeToOur.
  ///
  /// In en, this message translates to:
  /// **'By signing in you agree to our '**
  String get bySigningInYouAgreeToOur;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetEmailSent;

  /// No description provided for @enterYourEmailToReceiveAResetLink.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset link'**
  String get enterYourEmailToReceiveAResetLink;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noUserIsCurrentlyLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'No User Is Currently Logged In'**
  String get noUserIsCurrentlyLoggedIn;

  /// No description provided for @failedToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Failed to Delete Account'**
  String get failedToDeleteAccount;

  /// No description provided for @oopsSomethingWentWrongPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong. Please try again.'**
  String get oopsSomethingWentWrongPleaseTryAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sq'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sq':
      return AppLocalizationsSq();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

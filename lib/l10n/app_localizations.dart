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

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name required'**
  String get nameRequired;

  /// No description provided for @purees.
  ///
  /// In en, this message translates to:
  /// **'Purees'**
  String get purees;

  /// No description provided for @blw.
  ///
  /// In en, this message translates to:
  /// **'BLW'**
  String get blw;

  /// No description provided for @mixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get mixed;

  /// No description provided for @pleaseSelectAFeedingStyle.
  ///
  /// In en, this message translates to:
  /// **'Please select a feeding style'**
  String get pleaseSelectAFeedingStyle;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get selectDateOfBirth;

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

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @unlockMyPlan.
  ///
  /// In en, this message translates to:
  /// **'Unlock My Plan'**
  String get unlockMyPlan;

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

  /// No description provided for @category_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get category_breakfast;

  /// No description provided for @category_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get category_lunch;

  /// No description provided for @category_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get category_dinner;

  /// No description provided for @category_snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get category_snacks;

  /// No description provided for @category_desserts.
  ///
  /// In en, this message translates to:
  /// **'Desserts'**
  String get category_desserts;

  /// No description provided for @category_drinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get category_drinks;

  /// No description provided for @baby_stage_1.
  ///
  /// In en, this message translates to:
  /// **'Stage 1: 4-6 months'**
  String get baby_stage_1;

  /// No description provided for @baby_stage_2.
  ///
  /// In en, this message translates to:
  /// **'Stage 2: 6-8 months'**
  String get baby_stage_2;

  /// No description provided for @baby_stage_3.
  ///
  /// In en, this message translates to:
  /// **'Stage 3: 8-12 months'**
  String get baby_stage_3;

  /// No description provided for @baby_stage_toddler.
  ///
  /// In en, this message translates to:
  /// **'Toddler: 12-24 months'**
  String get baby_stage_toddler;

  /// No description provided for @development_benefit_brain.
  ///
  /// In en, this message translates to:
  /// **'Brain Development'**
  String get development_benefit_brain;

  /// No description provided for @development_benefit_immunity.
  ///
  /// In en, this message translates to:
  /// **'Immunity'**
  String get development_benefit_immunity;

  /// No description provided for @development_benefit_digestive.
  ///
  /// In en, this message translates to:
  /// **'Digestive Health'**
  String get development_benefit_digestive;

  /// No description provided for @development_benefit_bone.
  ///
  /// In en, this message translates to:
  /// **'Bone Growth'**
  String get development_benefit_bone;

  /// No description provided for @development_benefit_eye.
  ///
  /// In en, this message translates to:
  /// **'Eye Health'**
  String get development_benefit_eye;

  /// No description provided for @measurement_unit_metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get measurement_unit_metric;

  /// No description provided for @measurement_unit_imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get measurement_unit_imperial;

  /// No description provided for @recipe_prep_time.
  ///
  /// In en, this message translates to:
  /// **'Prep time'**
  String get recipe_prep_time;

  /// No description provided for @recipe_cook_time.
  ///
  /// In en, this message translates to:
  /// **'Cook time'**
  String get recipe_cook_time;

  /// No description provided for @recipe_total_time.
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get recipe_total_time;

  /// No description provided for @recipe_servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get recipe_servings;

  /// No description provided for @recipe_rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get recipe_rating;

  /// No description provided for @recipe_minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get recipe_minutes;

  /// No description provided for @recipe_portions.
  ///
  /// In en, this message translates to:
  /// **'portions'**
  String get recipe_portions;

  /// No description provided for @recipe_ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get recipe_ingredients;

  /// No description provided for @recipe_instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get recipe_instructions;

  /// No description provided for @recipe_serving_guidance.
  ///
  /// In en, this message translates to:
  /// **'Serving Guidance'**
  String get recipe_serving_guidance;

  /// No description provided for @recipe_storage_info.
  ///
  /// In en, this message translates to:
  /// **'Storage & Leftovers'**
  String get recipe_storage_info;

  /// No description provided for @recipe_troubleshooting.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get recipe_troubleshooting;

  /// No description provided for @recipe_why_kids_love_this.
  ///
  /// In en, this message translates to:
  /// **'Why Kids Love This'**
  String get recipe_why_kids_love_this;

  /// No description provided for @recipe_nutritional_info.
  ///
  /// In en, this message translates to:
  /// **'Nutritional Information'**
  String get recipe_nutritional_info;

  /// No description provided for @recipe_development_benefits.
  ///
  /// In en, this message translates to:
  /// **'Development Benefits'**
  String get recipe_development_benefits;

  /// No description provided for @recipe_fun_facts.
  ///
  /// In en, this message translates to:
  /// **'Fun Facts'**
  String get recipe_fun_facts;

  /// No description provided for @recipe_add_to_favorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get recipe_add_to_favorites;

  /// No description provided for @recipe_remove_from_favorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get recipe_remove_from_favorites;

  /// No description provided for @recipe_add_to_meal_plan.
  ///
  /// In en, this message translates to:
  /// **'Add to Meal Plan'**
  String get recipe_add_to_meal_plan;

  /// No description provided for @recipe_mark_as_tried.
  ///
  /// In en, this message translates to:
  /// **'Mark as Tried'**
  String get recipe_mark_as_tried;

  /// No description provided for @recipe_share.
  ///
  /// In en, this message translates to:
  /// **'Share Recipe'**
  String get recipe_share;

  /// No description provided for @recipe_personal_notes.
  ///
  /// In en, this message translates to:
  /// **'Personal Notes'**
  String get recipe_personal_notes;

  /// No description provided for @recipe_add_note.
  ///
  /// In en, this message translates to:
  /// **'Add a note...'**
  String get recipe_add_note;

  /// No description provided for @recipe_save_note.
  ///
  /// In en, this message translates to:
  /// **'Save Note'**
  String get recipe_save_note;

  /// No description provided for @recipe_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search recipes...'**
  String get recipe_search_hint;

  /// No description provided for @recipe_filter_by_category.
  ///
  /// In en, this message translates to:
  /// **'Filter by category'**
  String get recipe_filter_by_category;

  /// No description provided for @recipe_filter_by_stage.
  ///
  /// In en, this message translates to:
  /// **'Filter by stage'**
  String get recipe_filter_by_stage;

  /// No description provided for @recipe_filter_by_allergens.
  ///
  /// In en, this message translates to:
  /// **'Filter by allergens'**
  String get recipe_filter_by_allergens;

  /// No description provided for @recipe_clear_filters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get recipe_clear_filters;

  /// No description provided for @recipe_next_suggested.
  ///
  /// In en, this message translates to:
  /// **'Next Suggested Recipe'**
  String get recipe_next_suggested;

  /// No description provided for @recipe_related_recipes.
  ///
  /// In en, this message translates to:
  /// **'Related Recipes'**
  String get recipe_related_recipes;

  /// No description provided for @recipe_recommended_for_you.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get recipe_recommended_for_you;

  /// No description provided for @recipe_calories_per_serving.
  ///
  /// In en, this message translates to:
  /// **'Calories per serving'**
  String get recipe_calories_per_serving;

  /// No description provided for @recipe_vitamins.
  ///
  /// In en, this message translates to:
  /// **'Vitamins'**
  String get recipe_vitamins;

  /// No description provided for @recipe_minerals.
  ///
  /// In en, this message translates to:
  /// **'Minerals'**
  String get recipe_minerals;

  /// No description provided for @recipe_stage_variations.
  ///
  /// In en, this message translates to:
  /// **'Stage Variations'**
  String get recipe_stage_variations;

  /// No description provided for @recipe_texture_guide.
  ///
  /// In en, this message translates to:
  /// **'Texture Guide'**
  String get recipe_texture_guide;

  /// No description provided for @recipe_allergy_warning.
  ///
  /// In en, this message translates to:
  /// **'Allergy Warning'**
  String get recipe_allergy_warning;

  /// No description provided for @recipe_substitutions.
  ///
  /// In en, this message translates to:
  /// **'Substitutions'**
  String get recipe_substitutions;

  /// No description provided for @recipe_error_loading.
  ///
  /// In en, this message translates to:
  /// **'Error loading recipe'**
  String get recipe_error_loading;

  /// No description provided for @recipe_error_not_found.
  ///
  /// In en, this message translates to:
  /// **'Recipe not found'**
  String get recipe_error_not_found;

  /// No description provided for @recipe_error_network.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get recipe_error_network;

  /// No description provided for @recipe_error_try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get recipe_error_try_again;

  /// No description provided for @recipe_offline_message.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing cached content.'**
  String get recipe_offline_message;

  /// No description provided for @recipe_empty_state_title.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get recipe_empty_state_title;

  /// No description provided for @recipe_empty_state_message.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search terms'**
  String get recipe_empty_state_message;

  /// No description provided for @recipe_empty_favorites_title.
  ///
  /// In en, this message translates to:
  /// **'No favorite recipes yet'**
  String get recipe_empty_favorites_title;

  /// No description provided for @recipe_empty_favorites_message.
  ///
  /// In en, this message translates to:
  /// **'Heart recipes you love to see them here'**
  String get recipe_empty_favorites_message;

  /// No description provided for @recipe_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading recipes...'**
  String get recipe_loading;

  /// No description provided for @recipe_pull_to_refresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get recipe_pull_to_refresh;

  /// No description provided for @recipe_meal_plan_success.
  ///
  /// In en, this message translates to:
  /// **'Added to meal plan'**
  String get recipe_meal_plan_success;

  /// No description provided for @recipe_favorite_added.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get recipe_favorite_added;

  /// No description provided for @recipe_favorite_removed.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get recipe_favorite_removed;

  /// No description provided for @recipe_tried_marked.
  ///
  /// In en, this message translates to:
  /// **'Marked as tried'**
  String get recipe_tried_marked;

  /// No description provided for @recipe_note_saved.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get recipe_note_saved;

  /// No description provided for @recipe_unit_toggle.
  ///
  /// In en, this message translates to:
  /// **'Toggle units'**
  String get recipe_unit_toggle;

  /// No description provided for @recipe_metric_units.
  ///
  /// In en, this message translates to:
  /// **'Metric units'**
  String get recipe_metric_units;

  /// No description provided for @recipe_imperial_units.
  ///
  /// In en, this message translates to:
  /// **'Imperial units'**
  String get recipe_imperial_units;
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

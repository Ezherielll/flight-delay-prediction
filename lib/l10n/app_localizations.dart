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
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flight Delay Predictor'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @infoCenter.
  ///
  /// In en, this message translates to:
  /// **'Info Center'**
  String get infoCenter;

  /// No description provided for @estimatingDelay.
  ///
  /// In en, this message translates to:
  /// **'Estimating flight delay...'**
  String get estimatingDelay;

  /// No description provided for @flightDetailsForecast.
  ///
  /// In en, this message translates to:
  /// **'Flight Details & Forecast'**
  String get flightDetailsForecast;

  /// No description provided for @flightInformation.
  ///
  /// In en, this message translates to:
  /// **'Flight Information'**
  String get flightInformation;

  /// No description provided for @airlineCode.
  ///
  /// In en, this message translates to:
  /// **'Airline Code'**
  String get airlineCode;

  /// No description provided for @selectAirline.
  ///
  /// In en, this message translates to:
  /// **'Select Airline'**
  String get selectAirline;

  /// No description provided for @customAirline.
  ///
  /// In en, this message translates to:
  /// **'Custom Airline'**
  String get customAirline;

  /// No description provided for @customAirlineHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. SQ, MH'**
  String get customAirlineHint;

  /// No description provided for @movementType.
  ///
  /// In en, this message translates to:
  /// **'Movement Type'**
  String get movementType;

  /// No description provided for @selectMovement.
  ///
  /// In en, this message translates to:
  /// **'Select Movement'**
  String get selectMovement;

  /// No description provided for @flightOperationType.
  ///
  /// In en, this message translates to:
  /// **'Flight Operation Type'**
  String get flightOperationType;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get selectType;

  /// No description provided for @dateAndTimeSettings.
  ///
  /// In en, this message translates to:
  /// **'Date & Time Settings'**
  String get dateAndTimeSettings;

  /// No description provided for @selectFlightDate.
  ///
  /// In en, this message translates to:
  /// **'Select Flight Date'**
  String get selectFlightDate;

  /// No description provided for @hourOfFlight.
  ///
  /// In en, this message translates to:
  /// **'Hour of Flight (0–23)'**
  String get hourOfFlight;

  /// No description provided for @selectHour.
  ///
  /// In en, this message translates to:
  /// **'Select Hour'**
  String get selectHour;

  /// No description provided for @weatherAndWindMetrics.
  ///
  /// In en, this message translates to:
  /// **'Weather & Wind Metrics'**
  String get weatherAndWindMetrics;

  /// No description provided for @weatherPresetTemplates.
  ///
  /// In en, this message translates to:
  /// **'Weather Preset Templates'**
  String get weatherPresetTemplates;

  /// No description provided for @clearSky.
  ///
  /// In en, this message translates to:
  /// **'Clear Sky'**
  String get clearSky;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @rainyStorm.
  ///
  /// In en, this message translates to:
  /// **'Rainy Storm'**
  String get rainyStorm;

  /// No description provided for @windyStorm.
  ///
  /// In en, this message translates to:
  /// **'Windy Storm'**
  String get windyStorm;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @relHumidity.
  ///
  /// In en, this message translates to:
  /// **'Rel. Humidity'**
  String get relHumidity;

  /// No description provided for @rainVolume.
  ///
  /// In en, this message translates to:
  /// **'Rain Volume'**
  String get rainVolume;

  /// No description provided for @surfPressure.
  ///
  /// In en, this message translates to:
  /// **'Surf. Pressure'**
  String get surfPressure;

  /// No description provided for @totalClouds.
  ///
  /// In en, this message translates to:
  /// **'Total Clouds'**
  String get totalClouds;

  /// No description provided for @lowClouds.
  ///
  /// In en, this message translates to:
  /// **'Low Clouds'**
  String get lowClouds;

  /// No description provided for @midClouds.
  ///
  /// In en, this message translates to:
  /// **'Mid Clouds'**
  String get midClouds;

  /// No description provided for @highClouds.
  ///
  /// In en, this message translates to:
  /// **'High Clouds'**
  String get highClouds;

  /// No description provided for @windSpeed10m.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed 10m'**
  String get windSpeed10m;

  /// No description provided for @windSpeed100m.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed 100m'**
  String get windSpeed100m;

  /// No description provided for @windDir10m.
  ///
  /// In en, this message translates to:
  /// **'Wind Dir 10m'**
  String get windDir10m;

  /// No description provided for @windDir100m.
  ///
  /// In en, this message translates to:
  /// **'Wind Dir 100m'**
  String get windDir100m;

  /// No description provided for @windGusts10m.
  ///
  /// In en, this message translates to:
  /// **'Wind Gusts 10m'**
  String get windGusts10m;

  /// No description provided for @runDelayEstimation.
  ///
  /// In en, this message translates to:
  /// **'Run Delay Estimation'**
  String get runDelayEstimation;

  /// No description provided for @inferenceFailed.
  ///
  /// In en, this message translates to:
  /// **'Inference Failed'**
  String get inferenceFailed;

  /// No description provided for @inferenceFailedDesc.
  ///
  /// In en, this message translates to:
  /// **'Could not complete delay prediction. Check server configuration.'**
  String get inferenceFailedDesc;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @pleaseCorrectErrors.
  ///
  /// In en, this message translates to:
  /// **'Please correct validation errors'**
  String get pleaseCorrectErrors;

  /// No description provided for @appliedPreset.
  ///
  /// In en, this message translates to:
  /// **'Applied {type} weather preset'**
  String appliedPreset(String type);

  /// No description provided for @predictionResult.
  ///
  /// In en, this message translates to:
  /// **'Prediction Result'**
  String get predictionResult;

  /// No description provided for @onTime.
  ///
  /// In en, this message translates to:
  /// **'On-Time'**
  String get onTime;

  /// No description provided for @delayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get delayed;

  /// No description provided for @delayProbability.
  ///
  /// In en, this message translates to:
  /// **'Delay Probability: {probability}'**
  String delayProbability(String probability);

  /// No description provided for @makeAnotherPrediction.
  ///
  /// In en, this message translates to:
  /// **'Make Another Prediction'**
  String get makeAnotherPrediction;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @flightDelayPrediction.
  ///
  /// In en, this message translates to:
  /// **'Flight Delay Prediction'**
  String get flightDelayPrediction;

  /// No description provided for @aiPoweredFlightIntelligence.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Flight Intelligence'**
  String get aiPoweredFlightIntelligence;

  /// No description provided for @aiPoweredFlightIntelligenceDesc.
  ///
  /// In en, this message translates to:
  /// **'Predict airline departure and arrival delays using local weather conditions and real-time operational parameters.'**
  String get aiPoweredFlightIntelligenceDesc;

  /// No description provided for @startPrediction.
  ///
  /// In en, this message translates to:
  /// **'Start Prediction'**
  String get startPrediction;

  /// No description provided for @yourActivity.
  ///
  /// In en, this message translates to:
  /// **'Your Activity'**
  String get yourActivity;

  /// No description provided for @totalChecks.
  ///
  /// In en, this message translates to:
  /// **'Total Checks'**
  String get totalChecks;

  /// No description provided for @quickMenu.
  ///
  /// In en, this message translates to:
  /// **'Quick Menu'**
  String get quickMenu;

  /// No description provided for @predictionHistory.
  ///
  /// In en, this message translates to:
  /// **'Prediction History'**
  String get predictionHistory;

  /// No description provided for @predictionHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'View your past delay prediction results and parameter entries.'**
  String get predictionHistoryDesc;

  /// No description provided for @serverConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Server Configuration'**
  String get serverConfiguration;

  /// No description provided for @serverConfigurationDesc.
  ///
  /// In en, this message translates to:
  /// **'Configure server endpoints and verify host availability.'**
  String get serverConfigurationDesc;

  /// No description provided for @informationCenter.
  ///
  /// In en, this message translates to:
  /// **'Information Center'**
  String get informationCenter;

  /// No description provided for @informationCenterDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn about aviation terms, weather variables, FAQs, and system operations.'**
  String get informationCenterDesc;

  /// No description provided for @clearAllHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear All History'**
  String get clearAllHistory;

  /// No description provided for @confirmClearAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All History?'**
  String get confirmClearAllTitle;

  /// No description provided for @confirmClearAllDesc.
  ///
  /// In en, this message translates to:
  /// **'This action will permanently delete all saved prediction inputs and outcomes from local storage.'**
  String get confirmClearAllDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared successfully'**
  String get historyCleared;

  /// No description provided for @historyItemRemoved.
  ///
  /// In en, this message translates to:
  /// **'History item removed'**
  String get historyItemRemoved;

  /// No description provided for @noHistoryRecorded.
  ///
  /// In en, this message translates to:
  /// **'No history recorded yet'**
  String get noHistoryRecorded;

  /// No description provided for @runDelayEstimationToLog.
  ///
  /// In en, this message translates to:
  /// **'Run a flight delay estimation to log search data.'**
  String get runDelayEstimationToLog;

  /// No description provided for @xgboostPrediction.
  ///
  /// In en, this message translates to:
  /// **'XGBoost AI-Powered Prediction'**
  String get xgboostPrediction;

  /// No description provided for @aiModelPredictionForFlight.
  ///
  /// In en, this message translates to:
  /// **'AI model prediction for Flight {airline}'**
  String aiModelPredictionForFlight(String airline);

  /// No description provided for @delayChance.
  ///
  /// In en, this message translates to:
  /// **'Delay Chance'**
  String get delayChance;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @decisionThreshold.
  ///
  /// In en, this message translates to:
  /// **'Decision Threshold'**
  String get decisionThreshold;

  /// No description provided for @estimatedParameters.
  ///
  /// In en, this message translates to:
  /// **'Estimated Parameters'**
  String get estimatedParameters;

  /// No description provided for @copyResults.
  ///
  /// In en, this message translates to:
  /// **'Copy Results'**
  String get copyResults;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Prediction details copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get backToDashboard;

  /// No description provided for @knowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base'**
  String get knowledgeBase;

  /// No description provided for @retryLoading.
  ///
  /// In en, this message translates to:
  /// **'Retry Loading'**
  String get retryLoading;

  /// No description provided for @noDataLoaded.
  ///
  /// In en, this message translates to:
  /// **'No data loaded.'**
  String get noDataLoaded;

  /// No description provided for @searchInformation.
  ///
  /// In en, this message translates to:
  /// **'Search Information'**
  String get searchInformation;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search airlines, airports, glossary, FAQs, weather...'**
  String get searchPlaceholder;

  /// No description provided for @aboutFlightIntelligenceTitle.
  ///
  /// In en, this message translates to:
  /// **'About Flight Intelligence'**
  String get aboutFlightIntelligenceTitle;

  /// No description provided for @whyItMatters.
  ///
  /// In en, this message translates to:
  /// **'Why it matters:'**
  String get whyItMatters;

  /// No description provided for @modelLogic.
  ///
  /// In en, this message translates to:
  /// **'Model Logic:'**
  String get modelLogic;

  /// No description provided for @dataSourcesCombined.
  ///
  /// In en, this message translates to:
  /// **'Data Sources Combined:'**
  String get dataSourcesCombined;

  /// No description provided for @predictionSystemWorkflow.
  ///
  /// In en, this message translates to:
  /// **'Prediction System Workflow'**
  String get predictionSystemWorkflow;

  /// No description provided for @delayClassification.
  ///
  /// In en, this message translates to:
  /// **'Delay Classification'**
  String get delayClassification;

  /// No description provided for @predictionResultInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Prediction Result Interpretation'**
  String get predictionResultInterpretation;

  /// No description provided for @machineLearningAlgorithms.
  ///
  /// In en, this message translates to:
  /// **'Machine Learning Algorithms'**
  String get machineLearningAlgorithms;

  /// No description provided for @featureWeightImportance.
  ///
  /// In en, this message translates to:
  /// **'Feature Weight & Importance'**
  String get featureWeightImportance;

  /// No description provided for @loadingInformationCenter.
  ///
  /// In en, this message translates to:
  /// **'Loading Information Center...'**
  String get loadingInformationCenter;

  /// No description provided for @applicationSettings.
  ///
  /// In en, this message translates to:
  /// **'Application Settings'**
  String get applicationSettings;

  /// No description provided for @apiEndpointConfig.
  ///
  /// In en, this message translates to:
  /// **'API Endpoint Configuration'**
  String get apiEndpointConfig;

  /// No description provided for @apiEndpointDesc.
  ///
  /// In en, this message translates to:
  /// **'Specify the endpoint of your FastAPI backend server. Running in Android emulator requires 10.0.2.2:8000 for localhost access.'**
  String get apiEndpointDesc;

  /// No description provided for @backendUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Backend URL / Server IP'**
  String get backendUrlLabel;

  /// No description provided for @backendUrlHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. http://10.0.2.2:8000'**
  String get backendUrlHint;

  /// No description provided for @connectionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connection Test Successful!'**
  String get connectionSuccess;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection Test Failed'**
  String get connectionFailed;

  /// No description provided for @testing.
  ///
  /// In en, this message translates to:
  /// **'Testing...'**
  String get testing;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get testConnection;

  /// No description provided for @saveUrl.
  ///
  /// In en, this message translates to:
  /// **'Save URL'**
  String get saveUrl;

  /// No description provided for @enableDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Enable Dark Mode Theme'**
  String get enableDarkMode;

  /// No description provided for @enableDarkModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Toggle between sleek dark colors and light slate layouts.'**
  String get enableDarkModeDesc;

  /// No description provided for @selectLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Select application language / Pilih bahasa aplikasi'**
  String get selectLanguageDesc;

  /// No description provided for @systemAndMl.
  ///
  /// In en, this message translates to:
  /// **'System & ML'**
  String get systemAndMl;

  /// No description provided for @weatherGuide.
  ///
  /// In en, this message translates to:
  /// **'Weather Guide'**
  String get weatherGuide;

  /// No description provided for @directory.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get directory;

  /// No description provided for @faqAndGlossary.
  ///
  /// In en, this message translates to:
  /// **'FAQ & Glossary'**
  String get faqAndGlossary;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

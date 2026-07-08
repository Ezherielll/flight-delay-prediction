// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flight Delay Predictor';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get infoCenter => 'Info Center';

  @override
  String get estimatingDelay => 'Estimating flight delay...';

  @override
  String get flightDetailsForecast => 'Flight Details & Forecast';

  @override
  String get flightInformation => 'Flight Information';

  @override
  String get airlineCode => 'Airline Code';

  @override
  String get selectAirline => 'Select Airline';

  @override
  String get customAirline => 'Custom Airline';

  @override
  String get customAirlineHint => 'e.g. SQ, MH';

  @override
  String get movementType => 'Movement Type';

  @override
  String get selectMovement => 'Select Movement';

  @override
  String get flightOperationType => 'Flight Operation Type';

  @override
  String get selectType => 'Select Type';

  @override
  String get dateAndTimeSettings => 'Date & Time Settings';

  @override
  String get selectFlightDate => 'Select Flight Date';

  @override
  String get hourOfFlight => 'Hour of Flight (0–23)';

  @override
  String get selectHour => 'Select Hour';

  @override
  String get weatherAndWindMetrics => 'Weather & Wind Metrics';

  @override
  String get weatherPresetTemplates => 'Weather Preset Templates';

  @override
  String get clearSky => 'Clear Sky';

  @override
  String get moderate => 'Moderate';

  @override
  String get rainyStorm => 'Rainy Storm';

  @override
  String get windyStorm => 'Windy Storm';

  @override
  String get temperature => 'Temperature';

  @override
  String get relHumidity => 'Rel. Humidity';

  @override
  String get rainVolume => 'Rain Volume';

  @override
  String get surfPressure => 'Surf. Pressure';

  @override
  String get totalClouds => 'Total Clouds';

  @override
  String get lowClouds => 'Low Clouds';

  @override
  String get midClouds => 'Mid Clouds';

  @override
  String get highClouds => 'High Clouds';

  @override
  String get windSpeed10m => 'Wind Speed 10m';

  @override
  String get windSpeed100m => 'Wind Speed 100m';

  @override
  String get windDir10m => 'Wind Dir 10m';

  @override
  String get windDir100m => 'Wind Dir 100m';

  @override
  String get windGusts10m => 'Wind Gusts 10m';

  @override
  String get runDelayEstimation => 'Run Delay Estimation';

  @override
  String get inferenceFailed => 'Inference Failed';

  @override
  String get inferenceFailedDesc =>
      'Could not complete delay prediction. Check server configuration.';

  @override
  String get ok => 'OK';

  @override
  String get required => 'Required';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get pleaseCorrectErrors => 'Please correct validation errors';

  @override
  String appliedPreset(String type) {
    return 'Applied $type weather preset';
  }

  @override
  String get predictionResult => 'Prediction Result';

  @override
  String get onTime => 'On-Time';

  @override
  String get delayed => 'Delayed';

  @override
  String delayProbability(String probability) {
    return 'Delay Probability: $probability';
  }

  @override
  String get makeAnotherPrediction => 'Make Another Prediction';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get flightDelayPrediction => 'Flight Delay Prediction';

  @override
  String get aiPoweredFlightIntelligence => 'AI-Powered Flight Intelligence';

  @override
  String get aiPoweredFlightIntelligenceDesc =>
      'Predict airline departure and arrival delays using local weather conditions and real-time operational parameters.';

  @override
  String get startPrediction => 'Start Prediction';

  @override
  String get yourActivity => 'Your Activity';

  @override
  String get totalChecks => 'Total Checks';

  @override
  String get quickMenu => 'Quick Menu';

  @override
  String get predictionHistory => 'Prediction History';

  @override
  String get predictionHistoryDesc =>
      'View your past delay prediction results and parameter entries.';

  @override
  String get serverConfiguration => 'Server Configuration';

  @override
  String get serverConfigurationDesc =>
      'Configure server endpoints and verify host availability.';

  @override
  String get informationCenter => 'Information Center';

  @override
  String get informationCenterDesc =>
      'Learn about aviation terms, weather variables, FAQs, and system operations.';

  @override
  String get clearAllHistory => 'Clear All History';

  @override
  String get confirmClearAllTitle => 'Clear All History?';

  @override
  String get confirmClearAllDesc =>
      'This action will permanently delete all saved prediction inputs and outcomes from local storage.';

  @override
  String get cancel => 'Cancel';

  @override
  String get clearAll => 'Clear All';

  @override
  String get historyCleared => 'History cleared successfully';

  @override
  String get historyItemRemoved => 'History item removed';

  @override
  String get noHistoryRecorded => 'No history recorded yet';

  @override
  String get runDelayEstimationToLog =>
      'Run a flight delay estimation to log search data.';

  @override
  String get xgboostPrediction => 'XGBoost AI-Powered Prediction';

  @override
  String aiModelPredictionForFlight(String airline) {
    return 'AI model prediction for Flight $airline';
  }

  @override
  String get delayChance => 'Delay Chance';

  @override
  String get confidence => 'Confidence';

  @override
  String get decisionThreshold => 'Decision Threshold';

  @override
  String get estimatedParameters => 'Estimated Parameters';

  @override
  String get copyResults => 'Copy Results';

  @override
  String get copiedToClipboard => 'Prediction details copied to clipboard';

  @override
  String get backToDashboard => 'Back to Dashboard';

  @override
  String get knowledgeBase => 'Knowledge Base';

  @override
  String get retryLoading => 'Retry Loading';

  @override
  String get noDataLoaded => 'No data loaded.';

  @override
  String get searchInformation => 'Search Information';

  @override
  String get searchPlaceholder =>
      'Search airlines, airports, glossary, FAQs, weather...';

  @override
  String get aboutFlightIntelligenceTitle => 'About Flight Intelligence';

  @override
  String get whyItMatters => 'Why it matters:';

  @override
  String get modelLogic => 'Model Logic:';

  @override
  String get dataSourcesCombined => 'Data Sources Combined:';

  @override
  String get predictionSystemWorkflow => 'Prediction System Workflow';

  @override
  String get delayClassification => 'Delay Classification';

  @override
  String get predictionResultInterpretation =>
      'Prediction Result Interpretation';

  @override
  String get machineLearningAlgorithms => 'Machine Learning Algorithms';

  @override
  String get featureWeightImportance => 'Feature Weight & Importance';

  @override
  String get loadingInformationCenter => 'Loading Information Center...';

  @override
  String get applicationSettings => 'Application Settings';

  @override
  String get apiEndpointConfig => 'API Endpoint Configuration';

  @override
  String get apiEndpointDesc =>
      'Specify the endpoint of your FastAPI backend server. Running in Android emulator requires 10.0.2.2:8000 for localhost access.';

  @override
  String get backendUrlLabel => 'Backend URL / Server IP';

  @override
  String get backendUrlHint => 'e.g. http://10.0.2.2:8000';

  @override
  String get connectionSuccess => 'Connection Test Successful!';

  @override
  String get connectionFailed => 'Connection Test Failed';

  @override
  String get testing => 'Testing...';

  @override
  String get testConnection => 'Test Connection';

  @override
  String get saveUrl => 'Save URL';

  @override
  String get enableDarkMode => 'Enable Dark Mode Theme';

  @override
  String get enableDarkModeDesc =>
      'Toggle between sleek dark colors and light slate layouts.';

  @override
  String get selectLanguageDesc =>
      'Select application language / Pilih bahasa aplikasi';

  @override
  String get systemAndMl => 'System & ML';

  @override
  String get weatherGuide => 'Weather Guide';

  @override
  String get directory => 'Directory';

  @override
  String get faqAndGlossary => 'FAQ & Glossary';
}

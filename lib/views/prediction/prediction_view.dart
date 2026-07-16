import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/app_toast.dart';
import 'package:flight_delay_predict/l10n/app_localizations.dart';
import '../../core/theme/theme.dart';
import '../../models/prediction_request.dart';
import '../../viewmodels/prediction_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/app_drawer.dart';
import 'widgets/flight_info_card.dart';
import 'widgets/date_time_card.dart';
import 'widgets/weather_card.dart';

class PredictionView extends ConsumerStatefulWidget {
  const PredictionView({super.key});

  @override
  ConsumerState<PredictionView> createState() => _PredictionViewState();
}

class _PredictionViewState extends ConsumerState<PredictionView> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  // Flight Controllers & Dropdowns
  String? _selectedAirline;
  String? _selectedMovementType;
  String? _selectedFltType = 'schedule';
  String? _selectedOrigin;
  String? _selectedDestination;

  // Time: date picker + hour dropdown
  DateTime? _selectedDate;
  int? _selectedHour;

  // Weather Controllers
  final _tempController = TextEditingController();
  final _humidityController = TextEditingController();
  final _rainController = TextEditingController();
  final _pressureController = TextEditingController();
  final _cloudCoverController = TextEditingController();
  final _cloudCoverLowController = TextEditingController();
  final _cloudCoverMidController = TextEditingController();
  final _cloudCoverHighController = TextEditingController();
  final _windSpeed10mController = TextEditingController();
  final _windSpeed100mController = TextEditingController();
  final _windDir10mController = TextEditingController();
  final _windDir100mController = TextEditingController();
  final _windGustsController = TextEditingController();
  final _customAirlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Setup listener to re-evaluate form validity
    _tempController.addListener(_checkFormValidity);
    _humidityController.addListener(_checkFormValidity);
    _rainController.addListener(_checkFormValidity);
    _pressureController.addListener(_checkFormValidity);
    _cloudCoverController.addListener(_checkFormValidity);
    _cloudCoverLowController.addListener(_checkFormValidity);
    _cloudCoverMidController.addListener(_checkFormValidity);
    _cloudCoverHighController.addListener(_checkFormValidity);
    _windSpeed10mController.addListener(_checkFormValidity);
    _windSpeed100mController.addListener(_checkFormValidity);
    _windDir10mController.addListener(_checkFormValidity);
    _windDir100mController.addListener(_checkFormValidity);
    _windGustsController.addListener(_checkFormValidity);
    _customAirlineController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _tempController.dispose();
    _humidityController.dispose();
    _rainController.dispose();
    _pressureController.dispose();
    _cloudCoverController.dispose();
    _cloudCoverLowController.dispose();
    _cloudCoverMidController.dispose();
    _cloudCoverHighController.dispose();
    _windSpeed10mController.dispose();
    _windSpeed100mController.dispose();
    _windDir10mController.dispose();
    _windDir100mController.dispose();
    _windGustsController.dispose();
    _customAirlineController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    final airlineOk =
        _selectedAirline != null &&
        (_selectedAirline != 'Other' ||
            _customAirlineController.text.trim().isNotEmpty);
    final movementOk = _selectedMovementType != null;
    final fltOk = _selectedFltType != null;
    final dateOk = _selectedDate != null;
    final hourOk = _selectedHour != null;

    final tempVal = double.tryParse(_tempController.text);
    final tempOk = tempVal != null && tempVal >= -20 && tempVal <= 50;

    final humVal = double.tryParse(_humidityController.text);
    final humOk = humVal != null && humVal >= 0 && humVal <= 100;

    final rainVal = double.tryParse(_rainController.text);
    final rainOk = rainVal != null && rainVal >= 0 && rainVal <= 300;

    final pressVal = double.tryParse(_pressureController.text);
    final pressOk = pressVal != null && pressVal >= 850 && pressVal <= 1100;

    final ccVal = double.tryParse(_cloudCoverController.text);
    final ccOk = ccVal != null && ccVal >= 0 && ccVal <= 100;

    final cclVal = double.tryParse(_cloudCoverLowController.text);
    final cclOk = cclVal != null && cclVal >= 0 && cclVal <= 100;

    final ccmVal = double.tryParse(_cloudCoverMidController.text);
    final ccmOk = ccmVal != null && ccmVal >= 0 && ccmVal <= 100;

    final cchVal = double.tryParse(_cloudCoverHighController.text);
    final cchOk = cchVal != null && cchVal >= 0 && cchVal <= 100;

    final ws10Val = double.tryParse(_windSpeed10mController.text);
    final ws10Ok = ws10Val != null && ws10Val >= 0 && ws10Val <= 150;

    final ws100Val = double.tryParse(_windSpeed100mController.text);
    final ws100Ok = ws100Val != null && ws100Val >= 0 && ws100Val <= 200;

    final wd10Val = double.tryParse(_windDir10mController.text);
    final wd10Ok = wd10Val != null && wd10Val >= 0 && wd10Val <= 360;

    final wd100Val = double.tryParse(_windDir100mController.text);
    final wd100Ok = wd100Val != null && wd100Val >= 0 && wd100Val <= 360;

    final wgVal = double.tryParse(_windGustsController.text);
    final wgOk = wgVal != null && wgVal >= 0 && wgVal <= 200;

    final isValid =
        airlineOk &&
        movementOk &&
        fltOk &&
        dateOk &&
        hourOk &&
        tempOk &&
        humOk &&
        rainOk &&
        pressOk &&
        ccOk &&
        cclOk &&
        ccmOk &&
        cchOk &&
        ws10Ok &&
        ws100Ok &&
        wd10Ok &&
        wd100Ok &&
        wgOk;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  // Predefined Weather Presets
  void _applyWeatherPreset(String type) {
    setState(() {
      switch (type) {
        case 'clear':
          _tempController.text = '32.0';
          _humidityController.text = '50.0';
          _rainController.text = '0.0';
          _pressureController.text = '1012.0';
          _cloudCoverController.text = '5.0';
          _cloudCoverLowController.text = '0.0';
          _cloudCoverMidController.text = '0.0';
          _cloudCoverHighController.text = '10.0';
          _windSpeed10mController.text = '5.0';
          _windSpeed100mController.text = '8.0';
          _windDir10mController.text = '90.0';
          _windDir100mController.text = '90.0';
          _windGustsController.text = '6.0';
          break;
        case 'rainy':
          _tempController.text = '24.0';
          _humidityController.text = '95.0';
          _rainController.text = '15.0';
          _pressureController.text = '1002.0';
          _cloudCoverController.text = '100.0';
          _cloudCoverLowController.text = '90.0';
          _cloudCoverMidController.text = '80.0';
          _cloudCoverHighController.text = '100.0';
          _windSpeed10mController.text = '25.0';
          _windSpeed100mController.text = '35.0';
          _windDir10mController.text = '270.0';
          _windDir100mController.text = '270.0';
          _windGustsController.text = '45.0';
          break;
        case 'windy':
          _tempController.text = '26.0';
          _humidityController.text = '85.0';
          _rainController.text = '5.0';
          _pressureController.text = '1005.0';
          _cloudCoverController.text = '90.0';
          _cloudCoverLowController.text = '60.0';
          _cloudCoverMidController.text = '70.0';
          _cloudCoverHighController.text = '90.0';
          _windSpeed10mController.text = '35.0';
          _windSpeed100mController.text = '50.0';
          _windDir10mController.text = '230.0';
          _windDir100mController.text = '228.0';
          _windGustsController.text = '60.0';
          break;
        case 'moderate':
        default:
          _tempController.text = '28.0';
          _humidityController.text = '70.0';
          _rainController.text = '0.0';
          _pressureController.text = '1010.0';
          _cloudCoverController.text = '40.0';
          _cloudCoverLowController.text = '10.0';
          _cloudCoverMidController.text = '20.0';
          _cloudCoverHighController.text = '30.0';
          _windSpeed10mController.text = '10.0';
          _windSpeed100mController.text = '15.0';
          _windDir10mController.text = '180.0';
          _windDir100mController.text = '180.0';
          _windGustsController.text = '12.0';
          break;
      }
    });
    AppToast.show('Applied ${type.toUpperCase()} weather preset');
    _checkFormValidity();
  }

  Future<void> _submitPrediction() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) {
      AppToast.show('Please correct validation errors', isError: true);
      return;
    }

    final finalAirline = _selectedAirline == 'Other'
        ? _customAirlineController.text.trim().toUpperCase()
        : _selectedAirline!;

    // Format date to ISO string: YYYY-MM-DD
    final d = _selectedDate!;
    final dateStr =
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    final request = PredictionRequest(
      airline: finalAirline,
      movementType: _selectedMovementType!,
      fltType: _selectedFltType!,
      date: dateStr,
      hour: _selectedHour!,
      temperature2m: double.parse(_tempController.text),
      relativeHumidity2m: double.parse(_humidityController.text),
      rain: double.parse(_rainController.text),
      surfacePressure: double.parse(_pressureController.text),
      cloudCover: double.parse(_cloudCoverController.text),
      cloudCoverLow: double.parse(_cloudCoverLowController.text),
      cloudCoverMid: double.parse(_cloudCoverMidController.text),
      cloudCoverHigh: double.parse(_cloudCoverHighController.text),
      windSpeed10m: double.parse(_windSpeed10mController.text),
      windSpeed100m: double.parse(_windSpeed100mController.text),
      windDirection10m: double.parse(_windDir10mController.text),
      windDirection100m: double.parse(_windDir100mController.text),
      windGusts10m: double.parse(_windGustsController.text),
      origin: _selectedOrigin,
      destination: _selectedDestination,
    );

    if (!mounted) return;
    LoadingDialog.show(context);

    final success = await ref
        .read(predictionProvider.notifier)
        .runPrediction(request);

    if (!mounted) return;
    LoadingDialog.hide(context);

    if (success) {
      context.replace('/result');
    } else {
      final err = ref.read(predictionProvider).errorMessage;
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: AppTheme.dangerColor),
              SizedBox(width: 8),
              Text('Inference Failed'),
            ],
          ),
          content: Text(
            err ??
                'Could not complete delay prediction. Check server configuration.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(l10n?.flightDetailsForecast ?? 'Flight Details & Forecast'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            children: [
              // 1. FLIGHT INFORMATION CARD
              FlightInfoCard(
                selectedAirline: _selectedAirline,
                selectedMovementType: _selectedMovementType,
                selectedFltType: _selectedFltType,
                selectedOrigin: _selectedOrigin,
                selectedDestination: _selectedDestination,
                customAirlineController: _customAirlineController,
                onAirlineChanged: (val) {
                  setState(() {
                    _selectedAirline = val;
                    if (val != 'Other') {
                      _customAirlineController.clear();
                    }
                  });
                  _checkFormValidity();
                },
                onMovementChanged: (val) {
                  setState(() => _selectedMovementType = val);
                  _checkFormValidity();
                },
                onFltTypeChanged: (val) {
                  setState(() => _selectedFltType = val);
                  _checkFormValidity();
                },
                onOriginChanged: (val) {
                  setState(() => _selectedOrigin = val);
                },
                onDestinationChanged: (val) {
                  setState(() => _selectedDestination = val);
                },
              ),

              // 2. TIME / DATE INFORMATION CARD
              DateTimeCard(
                selectedDate: _selectedDate,
                selectedHour: _selectedHour,
                onDateChanged: (val) {
                  setState(() => _selectedDate = val);
                  _checkFormValidity();
                },
                onHourChanged: (val) {
                  setState(() => _selectedHour = val);
                  _checkFormValidity();
                },
              ),

              // 3. WEATHER CONDITIONS CARD
              WeatherCard(
                tempController: _tempController,
                humidityController: _humidityController,
                rainController: _rainController,
                pressureController: _pressureController,
                cloudCoverController: _cloudCoverController,
                cloudCoverLowController: _cloudCoverLowController,
                cloudCoverMidController: _cloudCoverMidController,
                cloudCoverHighController: _cloudCoverHighController,
                windSpeed10mController: _windSpeed10mController,
                windSpeed100mController: _windSpeed100mController,
                windDir10mController: _windDir10mController,
                windDir100mController: _windDir100mController,
                windGustsController: _windGustsController,
                onPresetSelected: _applyWeatherPreset,
              ),

              const SizedBox(height: 20),

              // SUBMIT BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(
                  text: 'Run Delay Estimation',
                  icon: Icons.online_prediction,
                  onPressed: _isFormValid ? _submitPrediction : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/theme/theme.dart';
import '../../models/prediction_request.dart';
import '../../viewmodels/prediction_viewmodel.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/app_drawer.dart';

class PredictionView extends ConsumerStatefulWidget {
  const PredictionView({Key? key}) : super(key: key);

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

  final List<String> _airlines = ['GA', 'QG', 'JT', 'ID', 'IW', 'QZ', 'SJ', 'Other'];
  final List<Map<String, String>> _movementTypes = [
    {'label': 'Arrival', 'value': 'arrival'},
    {'label': 'Departure', 'value': 'departure'},
    {'label': 'Turnaround', 'value': 'turnaround'},
    {'label': 'Arrival RON', 'value': 'arr_ron'},
  ];
  final List<Map<String, String>> _fltTypes = [
    {'label': 'Commercial / Schedule', 'value': 'schedule'},
    {'label': 'Charter', 'value': 'charter'},
    {'label': 'Ferry Flight', 'value': 'ferry'},
    {'label': 'Extra Flight', 'value': 'extra flight'},
    {'label': 'Unscheduled', 'value': 'unschedule'},
    {'label': 'Freighter', 'value': 'freighter'},
    {'label': 'Military', 'value': 'military'},
    {'label': 'RON', 'value': 'ron'},
    {'label': 'Divert', 'value': 'divert'},
    {'label': 'Tech Landing', 'value': 'tech landing'},
    {'label': 'State / VIP Flight', 'value': 'state flight'},
    {'label': 'Hajj Flight', 'value': 'hajj'},
  ];

  // Time: date picker + hour dropdown
  DateTime? _selectedDate;
  int? _selectedHour;

  final List<int> _hours = List.generate(24, (i) => i);

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
    final airlineOk = _selectedAirline != null &&
        (_selectedAirline != 'Other' || _customAirlineController.text.trim().isNotEmpty);
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
    final ws10Ok = ws10Val != null && ws10Val >= 0 && ws10Val <= 30;

    final ws100Val = double.tryParse(_windSpeed100mController.text);
    final ws100Ok = ws100Val != null && ws100Val >= 0 && ws100Val <= 50;

    final wd10Val = double.tryParse(_windDir10mController.text);
    final wd10Ok = wd10Val != null && wd10Val >= 0 && wd10Val <= 360;

    final wd100Val = double.tryParse(_windDir100mController.text);
    final wd100Ok = wd100Val != null && wd100Val >= 0 && wd100Val <= 360;

    final wgVal = double.tryParse(_windGustsController.text);
    final wgOk = wgVal != null && wgVal >= 0 && wgVal <= 200;

    final isValid = airlineOk &&
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
    Fluttertoast.showToast(msg: 'Applied ${type.toUpperCase()} weather preset');
    _checkFormValidity();
  }

  Future<void> _submitPrediction() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) {
      Fluttertoast.showToast(msg: 'Please correct validation errors');
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
    );

    LoadingDialog.show(context);

    final success = await ref.read(predictionProvider.notifier).runPrediction(request);

    LoadingDialog.hide(context);

    if (success) {
      context.replace('/result');
    } else {
      final err = ref.read(predictionProvider).errorMessage;
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
          content: Text(err ?? 'Could not complete delay prediction. Check server configuration.'),
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
    final theme = Theme.of(context);
    
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Flight Details & Forecast'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            children: [
              // 1. FLIGHT INFORMATION CARD
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CardTitle(title: 'Flight Information', icon: Icons.flight),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomDropdown<String>(
                              label: 'Airline Code',
                              value: _selectedAirline,
                              hint: 'Select Airline',
                              prefixIcon: Icons.airplanemode_active,
                              items: _airlines
                                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedAirline = val;
                                  if (val != 'Other') {
                                    _customAirlineController.clear();
                                  }
                                });
                                _checkFormValidity();
                              },
                            ),
                          ),
                          if (_selectedAirline == 'Other') ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                controller: _customAirlineController,
                                label: 'Custom Airline',
                                hint: 'e.g. SQ, MH',
                                keyboardType: TextInputType.text,
                                validator: (val) {
                                  if (_selectedAirline == 'Other' && (val == null || val.trim().isEmpty)) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                      CustomDropdown<String>(
                        label: 'Movement Type',
                        value: _selectedMovementType,
                        hint: 'Select Movement',
                        prefixIcon: Icons.swap_horiz,
                        items: _movementTypes
                            .map((m) => DropdownMenuItem(
                                  value: m['value'],
                                  child: Text(m['label']!),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() => _selectedMovementType = val);
                          _checkFormValidity();
                        },
                      ),
                      CustomDropdown<String>(
                        label: 'Flight Operation Type',
                        value: _selectedFltType,
                        hint: 'Select Type',
                        prefixIcon: Icons.business_center,
                        items: _fltTypes
                            .map((f) => DropdownMenuItem(
                                  value: f['value'],
                                  child: Text(f['label']!),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() => _selectedFltType = val);
                          _checkFormValidity();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 2. TIME / DATE INFORMATION CARD
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CardTitle(title: 'Date & Time Settings', icon: Icons.access_time),
                      const SizedBox(height: 8),
                      // Date Picker
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030, 12, 31),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                            _checkFormValidity();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedDate == null
                                  ? theme.colorScheme.outline
                                  : theme.colorScheme.primary,
                              width: _selectedDate == null ? 1 : 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: _selectedDate == null
                                    ? theme.colorScheme.onSurface.withOpacity(0.5)
                                    : theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? 'Select Flight Date'
                                      : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: _selectedDate == null
                                        ? theme.colorScheme.onSurface.withOpacity(0.5)
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (_selectedDate != null)
                                Text(
                                  _getDayLabel(_selectedDate!),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Hour Dropdown
                      CustomDropdown<int>(
                        label: 'Hour of Flight (0–23)',
                        value: _selectedHour,
                        hint: 'Select Hour',
                        prefixIcon: Icons.schedule,
                        items: _hours
                            .map((h) => DropdownMenuItem(
                                  value: h,
                                  child: Text('${h.toString().padLeft(2, '0')}:00'),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() => _selectedHour = val);
                          _checkFormValidity();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 3. WEATHER CONDITIONS CARD
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CardTitle(title: 'Weather & Wind Metrics', icon: Icons.wb_sunny_outlined),
                      const SizedBox(height: 8),
                      
                      // PRESETS ROW
                      Text(
                        'Weather Preset Templates',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildPresetChip('Clear Sky', 'clear', Icons.wb_sunny_rounded, Colors.orange),
                            _buildPresetChip('Moderate', 'moderate', Icons.cloud_queue, Colors.blue),
                            _buildPresetChip('Rainy Storm', 'rainy', Icons.thunderstorm_rounded, Colors.teal),
                            _buildPresetChip('Windy Storm', 'windy', Icons.air, Colors.red),
                          ],
                        ),
                      ),
                      const Divider(height: 24),

                      // Weather Fields
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _tempController,
                              label: 'Temperature',
                              hint: 'e.g. 28.5',
                              suffixText: '°C',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, -20, 50),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _humidityController,
                              label: 'Rel. Humidity',
                              hint: 'e.g. 82',
                              suffixText: '%',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 0, 100),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _rainController,
                              label: 'Rain Volume',
                              hint: 'e.g. 3.5',
                              suffixText: 'mm',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 0, 300),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _pressureController,
                              // Surface pressure validator updated: 850–1100 hPa
                              label: 'Surf. Pressure',
                              hint: 'e.g. 1009',
                              suffixText: 'hPa',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 850, 1100),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _cloudCoverController,
                              label: 'Total Clouds',
                              hint: '0 - 100',
                              suffixText: '%',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 0, 100),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _cloudCoverLowController,
                              label: 'Low Clouds',
                              hint: '0 - 100',
                              suffixText: '%',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 0, 100),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _cloudCoverMidController,
                              label: 'Mid Clouds',
                              hint: '0 - 100',
                              suffixText: '%',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 0, 100),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _cloudCoverHighController,
                              label: 'High Clouds',
                              hint: '0 - 100',
                              suffixText: '%',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 0, 100),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _windSpeed10mController,
                              label: 'Wind Speed 10m',
                              hint: 'e.g. 17',
                              suffixText: 'km/h',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 0, 150),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _windSpeed100mController,
                              label: 'Wind Speed 100m',
                              hint: 'e.g. 21',
                              suffixText: 'km/h',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 0, 200),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _windDir10mController,
                              label: 'Wind Dir 10m',
                              hint: '0 - 360',
                              suffixText: '°',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 0, 360),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _windDir100mController,
                              label: 'Wind Dir 100m',
                              hint: '0 - 360',
                              suffixText: '°',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (val) => _validateRange(val, 0, 360),
                            ),
                          ),
                        ],
                      ),

                      CustomTextField(
                        controller: _windGustsController,
                        label: 'Wind Gusts 10m',
                        hint: 'e.g. 29',
                        suffixText: 'km/h',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (val) => _validateRange(val, 0, 200),
                      ),
                    ],
                  ),
                ),
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

  Widget _buildPresetChip(String label, String presetCode, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(icon, color: color, size: 16),
        label: Text(label),
        onPressed: () => _applyWeatherPreset(presetCode),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  String _getDayLabel(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String? _validateRange(String? value, double min, double max) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    final numVal = double.tryParse(value);
    if (numVal == null) {
      return 'Invalid number';
    }
    if (numVal < min || numVal > max) {
      return '$min - $max';
    }
    return null;
  }
}

class _CardTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _CardTitle({Key? key, required this.title, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

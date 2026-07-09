import 'package:flutter/material.dart';
import 'package:flight_delay_predict/l10n/app_localizations.dart';
import '../../../widgets/custom_textfield.dart';

class WeatherCard extends StatelessWidget {
  final TextEditingController tempController;
  final TextEditingController humidityController;
  final TextEditingController rainController;
  final TextEditingController pressureController;
  final TextEditingController cloudCoverController;
  final TextEditingController cloudCoverLowController;
  final TextEditingController cloudCoverMidController;
  final TextEditingController cloudCoverHighController;
  final TextEditingController windSpeed10mController;
  final TextEditingController windSpeed100mController;
  final TextEditingController windDir10mController;
  final TextEditingController windDir100mController;
  final TextEditingController windGustsController;
  final ValueChanged<String> onPresetSelected;

  const WeatherCard({
    super.key,
    required this.tempController,
    required this.humidityController,
    required this.rainController,
    required this.pressureController,
    required this.cloudCoverController,
    required this.cloudCoverLowController,
    required this.cloudCoverMidController,
    required this.cloudCoverHighController,
    required this.windSpeed10mController,
    required this.windSpeed100mController,
    required this.windDir10mController,
    required this.windDir100mController,
    required this.windGustsController,
    required this.onPresetSelected,
  });

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

  Widget _buildPresetChip({
    required String label,
    required String presetCode,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(icon, color: color, size: 16),
        label: Text(label),
        onPressed: () => onPresetSelected(presetCode),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wb_sunny_outlined, color: theme.colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  l10n?.weatherAndWindMetrics ?? 'Weather & Wind Metrics',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // PRESETS ROW
            Text(
              l10n?.weatherPresetTemplates ?? 'Weather Preset Templates',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetChip(
                    label: l10n?.clearSky ?? 'Clear Sky',
                    presetCode: 'clear',
                    icon: Icons.wb_sunny_rounded,
                    color: Colors.orange,
                  ),
                  _buildPresetChip(
                    label: l10n?.moderate ?? 'Moderate',
                    presetCode: 'moderate',
                    icon: Icons.cloud_queue,
                    color: Colors.blue,
                  ),
                  _buildPresetChip(
                    label: l10n?.rainyStorm ?? 'Rainy Storm',
                    presetCode: 'rainy',
                    icon: Icons.thunderstorm_rounded,
                    color: Colors.teal,
                  ),
                  _buildPresetChip(
                    label: l10n?.windyStorm ?? 'Windy Storm',
                    presetCode: 'windy',
                    icon: Icons.air,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            const Divider(height: 24),

            // Weather Fields
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: tempController,
                    label: 'Temperature',
                    hint: 'e.g. 28.5',
                    suffixText: '°C',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, -20, 50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: humidityController,
                    label: 'Rel. Humidity',
                    hint: 'e.g. 82',
                    suffixText: '%',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 0, 100),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: rainController,
                    label: 'Rain Volume',
                    hint: 'e.g. 3.5',
                    suffixText: 'mm',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 0, 300),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: pressureController,
                    label: 'Surf. Pressure',
                    hint: 'e.g. 1009',
                    suffixText: 'hPa',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 850, 1100),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: cloudCoverController,
                    label: 'Total Clouds',
                    hint: '0 - 100',
                    suffixText: '%',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 0, 100),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: cloudCoverLowController,
                    label: 'Low Clouds',
                    hint: '0 - 100',
                    suffixText: '%',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 0, 100),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: cloudCoverMidController,
                    label: 'Mid Clouds',
                    hint: '0 - 100',
                    suffixText: '%',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 0, 100),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: cloudCoverHighController,
                    label: 'High Clouds',
                    hint: '0 - 100',
                    suffixText: '%',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 0, 100),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: windSpeed10mController,
                    label: 'Wind Speed 10m',
                    hint: 'e.g. 17',
                    suffixText: 'km/h',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 0, 150),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: windSpeed100mController,
                    label: 'Wind Speed 100m',
                    hint: 'e.g. 21',
                    suffixText: 'km/h',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 0, 200),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: windDir10mController,
                    label: 'Wind Dir 10m',
                    hint: '0 - 360',
                    suffixText: '°',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 0, 360),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: windDir100mController,
                    label: 'Wind Dir 100m',
                    hint: '0 - 360',
                    suffixText: '°',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) => _validateRange(val, 0, 360),
                  ),
                ),
              ],
            ),

            CustomTextField(
              controller: windGustsController,
              label: 'Wind Gusts 10m',
              hint: 'e.g. 29',
              suffixText: 'km/h',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (val) => _validateRange(val, 0, 200),
            ),
          ],
        ),
      ),
    );
  }
}

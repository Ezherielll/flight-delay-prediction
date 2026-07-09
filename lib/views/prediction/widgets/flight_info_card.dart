import 'package:flutter/material.dart';
import 'package:flight_delay_predict/l10n/app_localizations.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_textfield.dart';

class FlightInfoCard extends StatelessWidget {
  final String? selectedAirline;
  final String? selectedMovementType;
  final String? selectedFltType;
  final TextEditingController customAirlineController;
  final ValueChanged<String?> onAirlineChanged;
  final ValueChanged<String?> onMovementChanged;
  final ValueChanged<String?> onFltTypeChanged;

  static const List<String> _airlines = [
    'GA',
    'QG',
    'JT',
    'ID',
    'IW',
    'QZ',
    'SJ',
    'Other',
  ];

  static const List<Map<String, String>> _movementTypes = [
    {'label': 'Arrival', 'value': 'arrival'},
    {'label': 'Departure', 'value': 'departure'},
    {'label': 'Turnaround', 'value': 'turnaround'},
    {'label': 'Arrival RON', 'value': 'arr_ron'},
  ];

  static const List<Map<String, String>> _fltTypes = [
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

  const FlightInfoCard({
    super.key,
    required this.selectedAirline,
    required this.selectedMovementType,
    required this.selectedFltType,
    required this.customAirlineController,
    required this.onAirlineChanged,
    required this.onMovementChanged,
    required this.onFltTypeChanged,
  });

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
                Icon(Icons.flight, color: theme.colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  l10n?.flightInformation ?? 'Flight Information',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomDropdown<String>(
                    label: 'Airline Code',
                    value: selectedAirline,
                    hint: 'Select Airline',
                    prefixIcon: Icons.airplanemode_active,
                    items: _airlines
                        .map(
                          (a) => DropdownMenuItem(
                            value: a,
                            child: Text(a),
                          ),
                        )
                        .toList(),
                    onChanged: onAirlineChanged,
                  ),
                ),
                if (selectedAirline == 'Other') ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: customAirlineController,
                      label: 'Custom Airline',
                      hint: 'e.g. SQ, MH',
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (selectedAirline == 'Other' &&
                            (val == null || val.trim().isEmpty)) {
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
              value: selectedMovementType,
              hint: 'Select Movement',
              prefixIcon: Icons.swap_horiz,
              items: _movementTypes
                  .map(
                    (m) => DropdownMenuItem(
                      value: m['value'],
                      child: Text(m['label']!),
                    ),
                  )
                  .toList(),
              onChanged: onMovementChanged,
            ),
            CustomDropdown<String>(
              label: 'Flight Operation Type',
              value: selectedFltType,
              hint: 'Select Type',
              prefixIcon: Icons.business_center,
              items: _fltTypes
                  .map(
                    (f) => DropdownMenuItem(
                      value: f['value'],
                      child: Text(f['label']!),
                    ),
                  )
                  .toList(),
              onChanged: onFltTypeChanged,
            ),
          ],
        ),
      ),
    );
  }
}

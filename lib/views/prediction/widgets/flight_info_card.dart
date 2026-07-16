import 'package:flight_delay_predict/l10n/app_localizations.dart';
import 'package:flight_delay_predict/widgets/custom_dropdown.dart';
import 'package:flight_delay_predict/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class FlightInfoCard extends StatelessWidget {

  const FlightInfoCard({
    required this.selectedAirline, required this.selectedMovementType, required this.selectedFltType, required this.selectedOrigin, required this.selectedDestination, required this.customAirlineController, required this.onAirlineChanged, required this.onMovementChanged, required this.onFltTypeChanged, required this.onOriginChanged, required this.onDestinationChanged, super.key,
  });
  final String? selectedAirline;
  final String? selectedMovementType;
  final String? selectedFltType;
  final String? selectedOrigin;
  final String? selectedDestination;
  final TextEditingController customAirlineController;
  final ValueChanged<String?> onAirlineChanged;
  final ValueChanged<String?> onMovementChanged;
  final ValueChanged<String?> onFltTypeChanged;
  final ValueChanged<String?> onOriginChanged;
  final ValueChanged<String?> onDestinationChanged;

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

  /// Daftar bandara utama Indonesia (kode IATA) + opsi "Other" untuk input manual.
  static const List<Map<String, String>> _airports = [
    {'label': 'CGK – Soekarno-Hatta, Jakarta', 'value': 'CGK'},
    {'label': 'DPS – Ngurah Rai, Bali', 'value': 'DPS'},
    {'label': 'SUB – Juanda, Surabaya', 'value': 'SUB'},
    {'label': 'KNO – Kualanamu, Medan', 'value': 'KNO'},
    {'label': 'UPG – Sultan Hasanuddin, Makassar', 'value': 'UPG'},
    {'label': 'BPN – Sultan Aji Muhammad Sulaiman, Balikpapan', 'value': 'BPN'},
    {'label': 'PLM – Sultan Mahmud Badaruddin II, Palembang', 'value': 'PLM'},
    {'label': 'PNK – Supadio, Pontianak', 'value': 'PNK'},
    {'label': 'LOP – Lombok Praya, Mataram', 'value': 'LOP'},
    {'label': 'SOC – Adi Sumarmo, Solo', 'value': 'SOC'},
    {'label': 'JOG – Adisutjipto, Yogyakarta', 'value': 'JOG'},
    {'label': 'SRG – Semarang', 'value': 'SRG'},
    {'label': 'MDC – Sam Ratulangi, Manado', 'value': 'MDC'},
    {'label': 'AMQ – Pattimura, Ambon', 'value': 'AMQ'},
    {'label': 'DJJ – Sentani, Jayapura', 'value': 'DJJ'},
    {'label': 'TIM – Moses Kilangin, Timika', 'value': 'TIM'},
    {'label': 'BTH – Hang Nadim, Batam', 'value': 'BTH'},
    {'label': 'PKU – Sultan Syarif Kasim II, Pekanbaru', 'value': 'PKU'},
    {'label': 'BDJ – Syamsudin Noor, Banjarmasin', 'value': 'BDJ'},
    {'label': 'TRK – Juwata, Tarakan', 'value': 'TRK'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            // ── Origin & Destination (optional) ─────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomDropdown<String>(
                    label: 'Origin (Optional)',
                    value: selectedOrigin,
                    hint: 'Default: CGK',
                    prefixIcon: Icons.flight_takeoff,
                    items: _airports
                        .map(
                          (a) => DropdownMenuItem(
                            value: a['value'],
                            child: Text(a['label']!),
                          ),
                        )
                        .toList(),
                    onChanged: onOriginChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown<String>(
                    label: 'Destination (Optional)',
                    value: selectedDestination,
                    hint: 'Default: CGK',
                    prefixIcon: Icons.flight_land,
                    items: _airports
                        .map(
                          (a) => DropdownMenuItem(
                            value: a['value'],
                            child: Text(a['label']!),
                          ),
                        )
                        .toList(),
                    onChanged: onDestinationChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

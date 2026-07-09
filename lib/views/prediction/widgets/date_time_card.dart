import 'package:flutter/material.dart';
import 'package:flight_delay_predict/l10n/app_localizations.dart';
import '../../../widgets/custom_dropdown.dart';

class DateTimeCard extends StatelessWidget {
  final DateTime? selectedDate;
  final int? selectedHour;
  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<int?> onHourChanged;

  static final List<int> _hours = List.generate(24, (i) => i);

  const DateTimeCard({
    super.key,
    required this.selectedDate,
    required this.selectedHour,
    required this.onDateChanged,
    required this.onHourChanged,
  });

  String _getDayLabel(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
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
                Icon(Icons.access_time, color: theme.colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  l10n?.dateAndTimeSettings ?? 'Date & Time Settings',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Date Picker
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030, 12, 31),
                );
                if (picked != null) {
                  onDateChanged(picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedDate == null
                        ? theme.colorScheme.outline
                        : theme.colorScheme.primary,
                    width: selectedDate == null ? 1 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: selectedDate == null
                          ? theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            )
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'Select Flight Date'
                            : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 15,
                          color: selectedDate == null
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (selectedDate != null)
                      Text(
                        _getDayLabel(selectedDate!),
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
              value: selectedHour,
              hint: 'Select Hour',
              prefixIcon: Icons.schedule,
              items: _hours
                  .map(
                    (h) => DropdownMenuItem(
                      value: h,
                      child: Text(
                        '${h.toString().padLeft(2, '0')}:00',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onHourChanged,
            ),
          ],
        ),
      ),
    );
  }
}

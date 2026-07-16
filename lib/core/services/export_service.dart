import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/history_item.dart';
import 'package:flight_server_client/flight_server_client.dart' as sp;
import '../utils/csv_downloader.dart';

class ExportService {
  /// Exports Petugas AMC prediction history to CSV
  static Future<void> exportHistoryToCsv(List<HistoryItem> items) async {
    final List<List<dynamic>> rows = [
      [
        'Timestamp',
        'Airline',
        'Origin',
        'Destination',
        'Movement Type',
        'Flight Type',
        'Date',
        'Hour',
        'Temperature (C)',
        'Humidity (%)',
        'Rain (mm)',
        'Surface Pressure (hPa)',
        'Cloud Cover (%)',
        'Wind Speed (km/h)',
        'Wind Direction (deg)',
        'Wind Gusts (km/h)',
        'Prediction',
        'Probability (%)',
        'Confidence'
      ]
    ];

    for (final item in items) {
      rows.add([
        item.timestamp.toLocal().toString().split('.')[0],
        item.request.airline,
        item.request.origin ?? 'CGK',
        item.request.destination ?? 'CGK',
        item.request.movementType,
        item.request.fltType,
        item.request.date,
        item.request.hour,
        item.request.temperature2m,
        item.request.relativeHumidity2m,
        item.request.rain,
        item.request.surfacePressure,
        item.request.cloudCover,
        item.request.windSpeed10m,
        item.request.windDirection10m,
        item.request.windGusts10m,
        item.response.prediction,
        (item.response.probability * 100).toStringAsFixed(1),
        item.response.confidence,
      ]);
    }

    final csvString = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csvString);
    final filename = 'flight_delay_history_${DateTime.now().millisecondsSinceEpoch}.csv';
    await downloadCsvFile(bytes, filename);
  }

  /// Exports Admin bulk prediction records to CSV
  static Future<void> exportRecordsToCsv(List<sp.PredictionRecord> records) async {
    final List<List<dynamic>> rows = [
      [
        'Timestamp',
        'User ID',
        'Airline',
        'Origin',
        'Destination',
        'Movement Type',
        'Flight Type',
        'Date',
        'Hour',
        'Temperature (C)',
        'Rain (mm)',
        'Wind Speed (km/h)',
        'Prediction',
        'Probability (%)',
        'Confidence'
      ]
    ];

    for (final record in records) {
      rows.add([
        record.createdAt.toLocal().toString().split('.')[0],
        record.userInfoId,
        record.airline,
        record.origin ?? 'CGK',
        record.destination ?? 'CGK',
        record.movementType,
        record.fltType,
        record.date,
        record.hour,
        record.temperature2m,
        record.rain,
        record.windSpeed10m,
        record.prediction,
        (record.probability * 100).toStringAsFixed(1),
        record.confidence,
      ]);
    }

    final csvString = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csvString);
    final filename = 'all_predictions_${DateTime.now().millisecondsSinceEpoch}.csv';
    await downloadCsvFile(bytes, filename);
  }

  /// Exports Petugas AMC prediction history to PDF table
  static Future<void> exportHistoryToPdf(List<HistoryItem> items) async {
    final pdf = pw.Document();

    // Chunk size: 12 items per page to prevent A4 Landscape overflow
    final List<List<HistoryItem>> chunks = [];
    for (var i = 0; i < items.length; i += 12) {
      chunks.add(items.sublist(i, i + 12 > items.length ? items.length : i + 12));
    }

    for (var pageIdx = 0; pageIdx < chunks.length; pageIdx++) {
      final chunk = chunks[pageIdx];
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Flight Delay Predictor - History Report',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900),
                    ),
                    pw.Text(
                      'Page ${pageIdx + 1} of ${chunks.length}',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Generated on: ${DateTime.now().toLocal().toString().split('.')[0]}',
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
                ),
                pw.SizedBox(height: 12),
                pw.TableHelper.fromTextArray(
                  headers: [
                    'Date & Time',
                    'Airline',
                    'Route',
                    'Movement',
                    'Flight Type',
                    'Temp',
                    'Rain',
                    'Wind',
                    'Prediction',
                    'Prob %',
                    'Confidence'
                  ],
                  data: chunk.map((item) {
                    return [
                      item.timestamp.toLocal().toString().split('.')[0].substring(5, 16),
                      item.request.airline,
                      '${item.request.origin ?? 'CGK'} -> ${item.request.destination ?? 'CGK'}',
                      item.request.movementType,
                      item.request.fltType,
                      '${item.request.temperature2m.toStringAsFixed(1)}C',
                      '${item.request.rain.toStringAsFixed(1)}mm',
                      '${item.request.windSpeed10m.toStringAsFixed(1)}km/h',
                      item.response.prediction,
                      '${(item.response.probability * 100).toStringAsFixed(1)}%',
                      item.response.confidence
                    ];
                  }).toList(),
                  border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey300),
                  headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  cellStyle: const pw.TextStyle(fontSize: 8),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
              ],
            );
          },
        ),
      );
    }

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'flight_delay_history_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}

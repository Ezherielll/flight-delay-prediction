import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flight_delay_predict/core/utils/app_toast.dart';
import 'package:web/web.dart' as web;

/// Web-specific CSV download using the browser's native download mechanism.
/// Works for both Flutter Web (JS) and Flutter Web (WASM) builds.
Future<void> downloadCsvFile(List<int> bytes, String filename) async {
  try {
    final uint8List = Uint8List.fromList(bytes);
    final blob = web.Blob(
      <JSAny>[uint8List.buffer.toJS].toJS,
      web.BlobPropertyBag(type: 'text/csv;charset=utf-8;'),
    );
    final url = web.URL.createObjectURL(blob);

    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..setAttribute('download', filename);
    web.document.body!
      ..appendChild(anchor)
      ..removeChild(anchor..click());
    web.URL.revokeObjectURL(url);

    AppToast.show('✅ File berhasil diunduh: $filename');
  } on Exception catch (e) {
    AppToast.show('Gagal mengunduh file: $e', isError: true);
  }
}

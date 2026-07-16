import 'dart:io';

import 'package:flight_delay_predict/core/utils/app_toast.dart';
import 'package:path_provider/path_provider.dart';

/// Mobile & Desktop CSV download using path_provider and dart:io.
Future<void> downloadCsvFile(List<int> bytes, String filename) async {
  try {
    Directory? dir;

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      dir = await getDownloadsDirectory();
    } else if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
    }
    // Fallback for iOS or if the above returns null
    dir ??= await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);

    AppToast.show('✅ File tersimpan:\n${file.path}');
  } on Exception catch (e) {
    AppToast.show('Gagal menyimpan file: $e', isError: true);
  }
}

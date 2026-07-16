// Conditional import router for platform-specific CSV download implementations.
//
// - Web (JS & WASM): uses csv_downloader_web.dart via dart:js_interop + package:web
// - Mobile/Desktop:  uses csv_downloader_io.dart  via dart:io + path_provider
// - Other:           uses csv_downloader_stub.dart (no-op)
export 'csv_downloader_stub.dart'
    if (dart.library.js_interop) 'csv_downloader_web.dart'
    if (dart.library.io) 'csv_downloader_io.dart';

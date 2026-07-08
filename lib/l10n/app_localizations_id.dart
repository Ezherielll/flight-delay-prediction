// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Prediksi Keterlambatan Penerbangan';

  @override
  String get home => 'Beranda';

  @override
  String get history => 'Riwayat';

  @override
  String get settings => 'Pengaturan';

  @override
  String get infoCenter => 'Pusat Info';

  @override
  String get estimatingDelay => 'Mengestimasi keterlambatan...';

  @override
  String get flightDetailsForecast => 'Detail Penerbangan & Prakiraan';

  @override
  String get flightInformation => 'Informasi Penerbangan';

  @override
  String get airlineCode => 'Kode Maskapai';

  @override
  String get selectAirline => 'Pilih Maskapai';

  @override
  String get customAirline => 'Maskapai Kustom';

  @override
  String get customAirlineHint => 'cth. SQ, MH';

  @override
  String get movementType => 'Tipe Pergerakan';

  @override
  String get selectMovement => 'Pilih Pergerakan';

  @override
  String get flightOperationType => 'Tipe Operasi Penerbangan';

  @override
  String get selectType => 'Pilih Tipe';

  @override
  String get dateAndTimeSettings => 'Pengaturan Tanggal & Waktu';

  @override
  String get selectFlightDate => 'Pilih Tanggal Penerbangan';

  @override
  String get hourOfFlight => 'Jam Penerbangan (0–23)';

  @override
  String get selectHour => 'Pilih Jam';

  @override
  String get weatherAndWindMetrics => 'Metrik Cuaca & Angin';

  @override
  String get weatherPresetTemplates => 'Template Preset Cuaca';

  @override
  String get clearSky => 'Langit Cerah';

  @override
  String get moderate => 'Sedang';

  @override
  String get rainyStorm => 'Badai Hujan';

  @override
  String get windyStorm => 'Badai Angin';

  @override
  String get temperature => 'Suhu';

  @override
  String get relHumidity => 'Kelembapan Rel.';

  @override
  String get rainVolume => 'Curah Hujan';

  @override
  String get surfPressure => 'Tekanan Permukaan';

  @override
  String get totalClouds => 'Total Awan';

  @override
  String get lowClouds => 'Awan Rendah';

  @override
  String get midClouds => 'Awan Menengah';

  @override
  String get highClouds => 'Awan Tinggi';

  @override
  String get windSpeed10m => 'Kec. Angin 10m';

  @override
  String get windSpeed100m => 'Kec. Angin 100m';

  @override
  String get windDir10m => 'Arah Angin 10m';

  @override
  String get windDir100m => 'Arah Angin 100m';

  @override
  String get windGusts10m => 'Hembusan Angin 10m';

  @override
  String get runDelayEstimation => 'Jalankan Estimasi Keterlambatan';

  @override
  String get inferenceFailed => 'Inferensi Gagal';

  @override
  String get inferenceFailedDesc =>
      'Tidak dapat menyelesaikan prediksi keterlambatan. Periksa konfigurasi server.';

  @override
  String get ok => 'OK';

  @override
  String get required => 'Wajib diisi';

  @override
  String get invalidNumber => 'Angka tidak valid';

  @override
  String get pleaseCorrectErrors => 'Harap perbaiki kesalahan validasi';

  @override
  String appliedPreset(String type) {
    return 'Preset cuaca $type diterapkan';
  }

  @override
  String get predictionResult => 'Hasil Prediksi';

  @override
  String get onTime => 'Tepat Waktu';

  @override
  String get delayed => 'Terlambat';

  @override
  String delayProbability(String probability) {
    return 'Peluang Keterlambatan: $probability';
  }

  @override
  String get makeAnotherPrediction => 'Buat Prediksi Lain';

  @override
  String get appearance => 'Tampilan';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get language => 'Bahasa';

  @override
  String get about => 'Tentang';

  @override
  String get version => 'Versi';

  @override
  String get noHistoryYet => 'Belum ada riwayat';

  @override
  String get flightDelayPrediction => 'Prediksi Keterlambatan Penerbangan';

  @override
  String get aiPoweredFlightIntelligence =>
      'Kecerdasan Penerbangan Berbasis AI';

  @override
  String get aiPoweredFlightIntelligenceDesc =>
      'Prediksi keterlambatan keberangkatan dan kedatangan maskapai menggunakan kondisi cuaca lokal dan parameter operasional real-time.';

  @override
  String get startPrediction => 'Mulai Prediksi';

  @override
  String get yourActivity => 'Aktivitas Anda';

  @override
  String get totalChecks => 'Total Pemeriksaan';

  @override
  String get quickMenu => 'Menu Cepat';

  @override
  String get predictionHistory => 'Riwayat Prediksi';

  @override
  String get predictionHistoryDesc =>
      'Lihat hasil prediksi keterlambatan dan input parameter Anda sebelumnya.';

  @override
  String get serverConfiguration => 'Konfigurasi Server';

  @override
  String get serverConfigurationDesc =>
      'Konfigurasi endpoint server dan verifikasi ketersediaan host.';

  @override
  String get informationCenter => 'Pusat Informasi';

  @override
  String get informationCenterDesc =>
      'Pelajari istilah penerbangan, variabel cuaca, FAQ, dan operasi sistem.';

  @override
  String get clearAllHistory => 'Hapus Semua Riwayat';

  @override
  String get confirmClearAllTitle => 'Hapus Semua Riwayat?';

  @override
  String get confirmClearAllDesc =>
      'Tindakan ini akan menghapus semua input prediksi dan hasil yang disimpan dari penyimpanan lokal secara permanen.';

  @override
  String get cancel => 'Batal';

  @override
  String get clearAll => 'Hapus Semua';

  @override
  String get historyCleared => 'Riwayat berhasil dihapus';

  @override
  String get historyItemRemoved => 'Item riwayat dihapus';

  @override
  String get noHistoryRecorded => 'Belum ada riwayat tercatat';

  @override
  String get runDelayEstimationToLog =>
      'Jalankan estimasi keterlambatan penerbangan untuk mencatat data pencarian.';

  @override
  String get xgboostPrediction => 'Prediksi AI Berbasis XGBoost';

  @override
  String aiModelPredictionForFlight(String airline) {
    return 'Prediksi model AI untuk Penerbangan $airline';
  }

  @override
  String get delayChance => 'Peluang Keterlambatan';

  @override
  String get confidence => 'Keyakinan';

  @override
  String get decisionThreshold => 'Ambang Keputusan';

  @override
  String get estimatedParameters => 'Parameter Terestimasi';

  @override
  String get copyResults => 'Salin Hasil';

  @override
  String get copiedToClipboard => 'Detail prediksi berhasil disalin';

  @override
  String get backToDashboard => 'Kembali ke Beranda';

  @override
  String get knowledgeBase => 'Basis Pengetahuan';

  @override
  String get retryLoading => 'Coba Lagi';

  @override
  String get noDataLoaded => 'Data tidak termuat.';

  @override
  String get searchInformation => 'Cari Informasi';

  @override
  String get searchPlaceholder =>
      'Cari maskapai, bandara, istilah, FAQ, cuaca...';

  @override
  String get aboutFlightIntelligenceTitle => 'Tentang Kecerdasan Penerbangan';

  @override
  String get whyItMatters => 'Mengapa ini penting:';

  @override
  String get modelLogic => 'Logika Model:';

  @override
  String get dataSourcesCombined => 'Sumber Data Gabungan:';

  @override
  String get predictionSystemWorkflow => 'Alur Kerja Sistem Prediksi';

  @override
  String get delayClassification => 'Klasifikasi Keterlambatan';

  @override
  String get predictionResultInterpretation => 'Interpretasi Hasil Prediksi';

  @override
  String get machineLearningAlgorithms => 'Algoritma Machine Learning';

  @override
  String get featureWeightImportance => 'Bobot & Kepentingan Fitur';

  @override
  String get loadingInformationCenter => 'Memuat Pusat Informasi...';

  @override
  String get applicationSettings => 'Pengaturan Aplikasi';

  @override
  String get apiEndpointConfig => 'Konfigurasi Endpoint API';

  @override
  String get apiEndpointDesc =>
      'Tentukan endpoint server backend FastAPI Anda. Menjalankan di emulator Android memerlukan 10.0.2.2:8000 untuk akses localhost.';

  @override
  String get backendUrlLabel => 'URL Backend / IP Server';

  @override
  String get backendUrlHint => 'cth. http://10.0.2.2:8000';

  @override
  String get connectionSuccess => 'Uji Koneksi Berhasil!';

  @override
  String get connectionFailed => 'Uji Koneksi Gagal';

  @override
  String get testing => 'Menguji...';

  @override
  String get testConnection => 'Uji Koneksi';

  @override
  String get saveUrl => 'Simpan URL';

  @override
  String get enableDarkMode => 'Aktifkan Tema Mode Gelap';

  @override
  String get enableDarkModeDesc =>
      'Beralih antara warna gelap yang elegan dan tata letak slate terang.';

  @override
  String get selectLanguageDesc =>
      'Pilih bahasa aplikasi / Select application language';

  @override
  String get systemAndMl => 'Sistem & ML';

  @override
  String get weatherGuide => 'Panduan Cuaca';

  @override
  String get directory => 'Direktori';

  @override
  String get faqAndGlossary => 'FAQ & Glosarium';
}

class PredictionRequest {
  PredictionRequest({
    required this.airline,
    required this.movementType,
    required this.fltType,
    required this.date,
    required this.hour,
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.rain,
    required this.surfacePressure,
    required this.cloudCover,
    required this.cloudCoverLow,
    required this.cloudCoverMid,
    required this.cloudCoverHigh,
    required this.windSpeed10m,
    required this.windSpeed100m,
    required this.windDirection10m,
    required this.windDirection100m,
    required this.windGusts10m,
    this.acType,
    this.origin,
    this.destination,
    this.weatherCode,
  });

  factory PredictionRequest.fromJson(Map<String, dynamic> json) {
    return PredictionRequest(
      airline: json['airline'] as String,
      movementType: json['movement_type'] as String,
      fltType: json['flt_type'] as String,
      date: json['date'] as String,
      hour: json['hour'] as int,
      temperature2m: (json['temperature_2m'] as num).toDouble(),
      relativeHumidity2m: (json['relative_humidity_2m'] as num).toDouble(),
      rain: (json['rain'] as num).toDouble(),
      surfacePressure: (json['surface_pressure'] as num).toDouble(),
      cloudCover: (json['cloud_cover'] as num).toDouble(),
      cloudCoverLow: (json['cloud_cover_low'] as num).toDouble(),
      cloudCoverMid: (json['cloud_cover_mid'] as num).toDouble(),
      cloudCoverHigh: (json['cloud_cover_high'] as num).toDouble(),
      windSpeed10m: (json['wind_speed_10m'] as num).toDouble(),
      windSpeed100m: (json['wind_speed_100m'] as num).toDouble(),
      windDirection10m: (json['wind_direction_10m'] as num).toDouble(),
      windDirection100m: (json['wind_direction_100m'] as num).toDouble(),
      windGusts10m: (json['wind_gusts_10m'] as num).toDouble(),
      acType: json['ac_type'] as String?,
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      weatherCode: json['weather_code'] as int?,
    );
  }

  final String airline;
  final String movementType;
  final String fltType;

  // New: date replaces dayOfWeek, month, isWeekend, dayOfMonth
  final String date; // ISO format: "2025-08-21"
  final int hour;

  // Weather fields
  final double temperature2m;
  final double relativeHumidity2m;
  final double rain;
  final double surfacePressure;
  final double cloudCover;
  final double cloudCoverLow;
  final double cloudCoverMid;
  final double cloudCoverHigh;
  final double windSpeed10m;
  final double windSpeed100m;
  final double windDirection10m;
  final double windDirection100m;
  final double windGusts10m;

  // Optional pipeline parameters
  // Note: windGustRatio and rainCloudInteraction are now computed server-side
  final String? acType;
  final String? origin;
  final String? destination;
  final int? weatherCode;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'airline': airline,
      'movement_type': movementType,
      'flt_type': fltType,
      'date': date,
      'hour': hour,
      'temperature_2m': temperature2m,
      'relative_humidity_2m': relativeHumidity2m,
      'rain': rain,
      'surface_pressure': surfacePressure,
      'cloud_cover': cloudCover,
      'cloud_cover_low': cloudCoverLow,
      'cloud_cover_mid': cloudCoverMid,
      'cloud_cover_high': cloudCoverHigh,
      'wind_speed_10m': windSpeed10m,
      'wind_speed_100m': windSpeed100m,
      'wind_direction_10m': windDirection10m,
      'wind_direction_100m': windDirection100m,
      'wind_gusts_10m': windGusts10m,
    };

    if (acType != null) data['ac_type'] = acType;
    if (origin != null) data['origin'] = origin;
    if (destination != null) data['destination'] = destination;
    if (weatherCode != null) data['weather_code'] = weatherCode;

    return data;
  }
}

class PredictionRequest {
  final String airline;
  final String movementType;
  final String fltType;
  final int hour;
  final int dayOfWeek;
  final int month;
  final int isWeekend;
  final int? dayOfMonth;

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

  // Optional derived/pipeline parameters
  final double? windGustRatio;
  final double? rainCloudInteraction;
  final String? acType;
  final String? origin;
  final String? destination;
  final int? weatherCode;

  PredictionRequest({
    required this.airline,
    required this.movementType,
    required this.fltType,
    required this.hour,
    required this.dayOfWeek,
    required this.month,
    required this.isWeekend,
    this.dayOfMonth,
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
    this.windGustRatio,
    this.rainCloudInteraction,
    this.acType,
    this.origin,
    this.destination,
    this.weatherCode,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'airline': airline,
      'movement_type': movementType,
      'flt_type': fltType,
      'hour': hour,
      'day_of_week': dayOfWeek,
      'month': month,
      'is_weekend': isWeekend,
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

    if (dayOfMonth != null) data['day_of_month'] = dayOfMonth;
    if (windGustRatio != null) data['wind_gust_ratio'] = windGustRatio;
    if (rainCloudInteraction != null) {
      data['rain_cloud_interaction'] = rainCloudInteraction;
    }
    if (acType != null) data['ac_type'] = acType;
    if (origin != null) data['origin'] = origin;
    if (destination != null) data['destination'] = destination;
    if (weatherCode != null) data['weather_code'] = weatherCode;

    return data;
  }

  factory PredictionRequest.fromJson(Map<String, dynamic> json) {
    return PredictionRequest(
      airline: json['airline'] as String,
      movementType: json['movement_type'] as String,
      fltType: json['flt_type'] as String,
      hour: json['hour'] as int,
      dayOfWeek: json['day_of_week'] as int,
      month: json['month'] as int,
      isWeekend: json['is_weekend'] as int,
      dayOfMonth: json['day_of_month'] as int?,
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
      windGustRatio: (json['wind_gust_ratio'] as num?)?.toDouble(),
      rainCloudInteraction: (json['rain_cloud_interaction'] as num?)?.toDouble(),
      acType: json['ac_type'] as String?,
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      weatherCode: json['weather_code'] as int?,
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PredictionHistoryTable extends PredictionHistory
    with TableInfo<$PredictionHistoryTable, PredictionHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PredictionHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _airlineMeta = const VerificationMeta(
    'airline',
  );
  @override
  late final GeneratedColumn<String> airline = GeneratedColumn<String>(
    'airline',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movementTypeMeta = const VerificationMeta(
    'movementType',
  );
  @override
  late final GeneratedColumn<String> movementType = GeneratedColumn<String>(
    'movement_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fltTypeMeta = const VerificationMeta(
    'fltType',
  );
  @override
  late final GeneratedColumn<String> fltType = GeneratedColumn<String>(
    'flt_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flightDateMeta = const VerificationMeta(
    'flightDate',
  );
  @override
  late final GeneratedColumn<DateTime> flightDate = GeneratedColumn<DateTime>(
    'flight_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flightHourMeta = const VerificationMeta(
    'flightHour',
  );
  @override
  late final GeneratedColumn<int> flightHour = GeneratedColumn<int>(
    'flight_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rainMeta = const VerificationMeta('rain');
  @override
  late final GeneratedColumn<double> rain = GeneratedColumn<double>(
    'rain',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cloudCoverMeta = const VerificationMeta(
    'cloudCover',
  );
  @override
  late final GeneratedColumn<double> cloudCover = GeneratedColumn<double>(
    'cloud_cover',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _predictionMeta = const VerificationMeta(
    'prediction',
  );
  @override
  late final GeneratedColumn<String> prediction = GeneratedColumn<String>(
    'prediction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _predictedClassMeta = const VerificationMeta(
    'predictedClass',
  );
  @override
  late final GeneratedColumn<int> predictedClass = GeneratedColumn<int>(
    'predicted_class',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _probabilityMeta = const VerificationMeta(
    'probability',
  );
  @override
  late final GeneratedColumn<double> probability = GeneratedColumn<double>(
    'probability',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thresholdMeta = const VerificationMeta(
    'threshold',
  );
  @override
  late final GeneratedColumn<double> threshold = GeneratedColumn<double>(
    'threshold',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    airline,
    movementType,
    fltType,
    origin,
    destination,
    flightDate,
    flightHour,
    temperature,
    rain,
    cloudCover,
    prediction,
    predictedClass,
    probability,
    confidence,
    threshold,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prediction_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<PredictionHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('airline')) {
      context.handle(
        _airlineMeta,
        airline.isAcceptableOrUnknown(data['airline']!, _airlineMeta),
      );
    } else if (isInserting) {
      context.missing(_airlineMeta);
    }
    if (data.containsKey('movement_type')) {
      context.handle(
        _movementTypeMeta,
        movementType.isAcceptableOrUnknown(
          data['movement_type']!,
          _movementTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_movementTypeMeta);
    }
    if (data.containsKey('flt_type')) {
      context.handle(
        _fltTypeMeta,
        fltType.isAcceptableOrUnknown(data['flt_type']!, _fltTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fltTypeMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    }
    if (data.containsKey('flight_date')) {
      context.handle(
        _flightDateMeta,
        flightDate.isAcceptableOrUnknown(data['flight_date']!, _flightDateMeta),
      );
    } else if (isInserting) {
      context.missing(_flightDateMeta);
    }
    if (data.containsKey('flight_hour')) {
      context.handle(
        _flightHourMeta,
        flightHour.isAcceptableOrUnknown(data['flight_hour']!, _flightHourMeta),
      );
    } else if (isInserting) {
      context.missing(_flightHourMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_temperatureMeta);
    }
    if (data.containsKey('rain')) {
      context.handle(
        _rainMeta,
        rain.isAcceptableOrUnknown(data['rain']!, _rainMeta),
      );
    } else if (isInserting) {
      context.missing(_rainMeta);
    }
    if (data.containsKey('cloud_cover')) {
      context.handle(
        _cloudCoverMeta,
        cloudCover.isAcceptableOrUnknown(data['cloud_cover']!, _cloudCoverMeta),
      );
    } else if (isInserting) {
      context.missing(_cloudCoverMeta);
    }
    if (data.containsKey('prediction')) {
      context.handle(
        _predictionMeta,
        prediction.isAcceptableOrUnknown(data['prediction']!, _predictionMeta),
      );
    } else if (isInserting) {
      context.missing(_predictionMeta);
    }
    if (data.containsKey('predicted_class')) {
      context.handle(
        _predictedClassMeta,
        predictedClass.isAcceptableOrUnknown(
          data['predicted_class']!,
          _predictedClassMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_predictedClassMeta);
    }
    if (data.containsKey('probability')) {
      context.handle(
        _probabilityMeta,
        probability.isAcceptableOrUnknown(
          data['probability']!,
          _probabilityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_probabilityMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('threshold')) {
      context.handle(
        _thresholdMeta,
        threshold.isAcceptableOrUnknown(data['threshold']!, _thresholdMeta),
      );
    } else if (isInserting) {
      context.missing(_thresholdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PredictionHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PredictionHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      airline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}airline'],
      )!,
      movementType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement_type'],
      )!,
      fltType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flt_type'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      ),
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      ),
      flightDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}flight_date'],
      )!,
      flightHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flight_hour'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      )!,
      rain: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rain'],
      )!,
      cloudCover: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cloud_cover'],
      )!,
      prediction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prediction'],
      )!,
      predictedClass: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}predicted_class'],
      )!,
      probability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}probability'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      )!,
      threshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}threshold'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $PredictionHistoryTable createAlias(String alias) {
    return $PredictionHistoryTable(attachedDatabase, alias);
  }
}

class PredictionHistoryData extends DataClass
    implements Insertable<PredictionHistoryData> {
  final int id;
  final String? serverId;
  final String airline;
  final String movementType;
  final String fltType;
  final String? origin;
  final String? destination;
  final DateTime flightDate;
  final int flightHour;
  final double temperature;
  final double rain;
  final double cloudCover;
  final String prediction;
  final int predictedClass;
  final double probability;
  final String confidence;
  final double threshold;
  final DateTime createdAt;
  final bool isSynced;
  const PredictionHistoryData({
    required this.id,
    this.serverId,
    required this.airline,
    required this.movementType,
    required this.fltType,
    this.origin,
    this.destination,
    required this.flightDate,
    required this.flightHour,
    required this.temperature,
    required this.rain,
    required this.cloudCover,
    required this.prediction,
    required this.predictedClass,
    required this.probability,
    required this.confidence,
    required this.threshold,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['airline'] = Variable<String>(airline);
    map['movement_type'] = Variable<String>(movementType);
    map['flt_type'] = Variable<String>(fltType);
    if (!nullToAbsent || origin != null) {
      map['origin'] = Variable<String>(origin);
    }
    if (!nullToAbsent || destination != null) {
      map['destination'] = Variable<String>(destination);
    }
    map['flight_date'] = Variable<DateTime>(flightDate);
    map['flight_hour'] = Variable<int>(flightHour);
    map['temperature'] = Variable<double>(temperature);
    map['rain'] = Variable<double>(rain);
    map['cloud_cover'] = Variable<double>(cloudCover);
    map['prediction'] = Variable<String>(prediction);
    map['predicted_class'] = Variable<int>(predictedClass);
    map['probability'] = Variable<double>(probability);
    map['confidence'] = Variable<String>(confidence);
    map['threshold'] = Variable<double>(threshold);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  PredictionHistoryCompanion toCompanion(bool nullToAbsent) {
    return PredictionHistoryCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      airline: Value(airline),
      movementType: Value(movementType),
      fltType: Value(fltType),
      origin: origin == null && nullToAbsent
          ? const Value.absent()
          : Value(origin),
      destination: destination == null && nullToAbsent
          ? const Value.absent()
          : Value(destination),
      flightDate: Value(flightDate),
      flightHour: Value(flightHour),
      temperature: Value(temperature),
      rain: Value(rain),
      cloudCover: Value(cloudCover),
      prediction: Value(prediction),
      predictedClass: Value(predictedClass),
      probability: Value(probability),
      confidence: Value(confidence),
      threshold: Value(threshold),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory PredictionHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PredictionHistoryData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      airline: serializer.fromJson<String>(json['airline']),
      movementType: serializer.fromJson<String>(json['movementType']),
      fltType: serializer.fromJson<String>(json['fltType']),
      origin: serializer.fromJson<String?>(json['origin']),
      destination: serializer.fromJson<String?>(json['destination']),
      flightDate: serializer.fromJson<DateTime>(json['flightDate']),
      flightHour: serializer.fromJson<int>(json['flightHour']),
      temperature: serializer.fromJson<double>(json['temperature']),
      rain: serializer.fromJson<double>(json['rain']),
      cloudCover: serializer.fromJson<double>(json['cloudCover']),
      prediction: serializer.fromJson<String>(json['prediction']),
      predictedClass: serializer.fromJson<int>(json['predictedClass']),
      probability: serializer.fromJson<double>(json['probability']),
      confidence: serializer.fromJson<String>(json['confidence']),
      threshold: serializer.fromJson<double>(json['threshold']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'airline': serializer.toJson<String>(airline),
      'movementType': serializer.toJson<String>(movementType),
      'fltType': serializer.toJson<String>(fltType),
      'origin': serializer.toJson<String?>(origin),
      'destination': serializer.toJson<String?>(destination),
      'flightDate': serializer.toJson<DateTime>(flightDate),
      'flightHour': serializer.toJson<int>(flightHour),
      'temperature': serializer.toJson<double>(temperature),
      'rain': serializer.toJson<double>(rain),
      'cloudCover': serializer.toJson<double>(cloudCover),
      'prediction': serializer.toJson<String>(prediction),
      'predictedClass': serializer.toJson<int>(predictedClass),
      'probability': serializer.toJson<double>(probability),
      'confidence': serializer.toJson<String>(confidence),
      'threshold': serializer.toJson<double>(threshold),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  PredictionHistoryData copyWith({
    int? id,
    Value<String?> serverId = const Value.absent(),
    String? airline,
    String? movementType,
    String? fltType,
    Value<String?> origin = const Value.absent(),
    Value<String?> destination = const Value.absent(),
    DateTime? flightDate,
    int? flightHour,
    double? temperature,
    double? rain,
    double? cloudCover,
    String? prediction,
    int? predictedClass,
    double? probability,
    String? confidence,
    double? threshold,
    DateTime? createdAt,
    bool? isSynced,
  }) => PredictionHistoryData(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    airline: airline ?? this.airline,
    movementType: movementType ?? this.movementType,
    fltType: fltType ?? this.fltType,
    origin: origin.present ? origin.value : this.origin,
    destination: destination.present ? destination.value : this.destination,
    flightDate: flightDate ?? this.flightDate,
    flightHour: flightHour ?? this.flightHour,
    temperature: temperature ?? this.temperature,
    rain: rain ?? this.rain,
    cloudCover: cloudCover ?? this.cloudCover,
    prediction: prediction ?? this.prediction,
    predictedClass: predictedClass ?? this.predictedClass,
    probability: probability ?? this.probability,
    confidence: confidence ?? this.confidence,
    threshold: threshold ?? this.threshold,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  PredictionHistoryData copyWithCompanion(PredictionHistoryCompanion data) {
    return PredictionHistoryData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      airline: data.airline.present ? data.airline.value : this.airline,
      movementType: data.movementType.present
          ? data.movementType.value
          : this.movementType,
      fltType: data.fltType.present ? data.fltType.value : this.fltType,
      origin: data.origin.present ? data.origin.value : this.origin,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      flightDate: data.flightDate.present
          ? data.flightDate.value
          : this.flightDate,
      flightHour: data.flightHour.present
          ? data.flightHour.value
          : this.flightHour,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      rain: data.rain.present ? data.rain.value : this.rain,
      cloudCover: data.cloudCover.present
          ? data.cloudCover.value
          : this.cloudCover,
      prediction: data.prediction.present
          ? data.prediction.value
          : this.prediction,
      predictedClass: data.predictedClass.present
          ? data.predictedClass.value
          : this.predictedClass,
      probability: data.probability.present
          ? data.probability.value
          : this.probability,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      threshold: data.threshold.present ? data.threshold.value : this.threshold,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PredictionHistoryData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('airline: $airline, ')
          ..write('movementType: $movementType, ')
          ..write('fltType: $fltType, ')
          ..write('origin: $origin, ')
          ..write('destination: $destination, ')
          ..write('flightDate: $flightDate, ')
          ..write('flightHour: $flightHour, ')
          ..write('temperature: $temperature, ')
          ..write('rain: $rain, ')
          ..write('cloudCover: $cloudCover, ')
          ..write('prediction: $prediction, ')
          ..write('predictedClass: $predictedClass, ')
          ..write('probability: $probability, ')
          ..write('confidence: $confidence, ')
          ..write('threshold: $threshold, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    airline,
    movementType,
    fltType,
    origin,
    destination,
    flightDate,
    flightHour,
    temperature,
    rain,
    cloudCover,
    prediction,
    predictedClass,
    probability,
    confidence,
    threshold,
    createdAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PredictionHistoryData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.airline == this.airline &&
          other.movementType == this.movementType &&
          other.fltType == this.fltType &&
          other.origin == this.origin &&
          other.destination == this.destination &&
          other.flightDate == this.flightDate &&
          other.flightHour == this.flightHour &&
          other.temperature == this.temperature &&
          other.rain == this.rain &&
          other.cloudCover == this.cloudCover &&
          other.prediction == this.prediction &&
          other.predictedClass == this.predictedClass &&
          other.probability == this.probability &&
          other.confidence == this.confidence &&
          other.threshold == this.threshold &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class PredictionHistoryCompanion
    extends UpdateCompanion<PredictionHistoryData> {
  final Value<int> id;
  final Value<String?> serverId;
  final Value<String> airline;
  final Value<String> movementType;
  final Value<String> fltType;
  final Value<String?> origin;
  final Value<String?> destination;
  final Value<DateTime> flightDate;
  final Value<int> flightHour;
  final Value<double> temperature;
  final Value<double> rain;
  final Value<double> cloudCover;
  final Value<String> prediction;
  final Value<int> predictedClass;
  final Value<double> probability;
  final Value<String> confidence;
  final Value<double> threshold;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  const PredictionHistoryCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.airline = const Value.absent(),
    this.movementType = const Value.absent(),
    this.fltType = const Value.absent(),
    this.origin = const Value.absent(),
    this.destination = const Value.absent(),
    this.flightDate = const Value.absent(),
    this.flightHour = const Value.absent(),
    this.temperature = const Value.absent(),
    this.rain = const Value.absent(),
    this.cloudCover = const Value.absent(),
    this.prediction = const Value.absent(),
    this.predictedClass = const Value.absent(),
    this.probability = const Value.absent(),
    this.confidence = const Value.absent(),
    this.threshold = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  PredictionHistoryCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required String airline,
    required String movementType,
    required String fltType,
    this.origin = const Value.absent(),
    this.destination = const Value.absent(),
    required DateTime flightDate,
    required int flightHour,
    required double temperature,
    required double rain,
    required double cloudCover,
    required String prediction,
    required int predictedClass,
    required double probability,
    required String confidence,
    required double threshold,
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
  }) : airline = Value(airline),
       movementType = Value(movementType),
       fltType = Value(fltType),
       flightDate = Value(flightDate),
       flightHour = Value(flightHour),
       temperature = Value(temperature),
       rain = Value(rain),
       cloudCover = Value(cloudCover),
       prediction = Value(prediction),
       predictedClass = Value(predictedClass),
       probability = Value(probability),
       confidence = Value(confidence),
       threshold = Value(threshold),
       createdAt = Value(createdAt);
  static Insertable<PredictionHistoryData> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? airline,
    Expression<String>? movementType,
    Expression<String>? fltType,
    Expression<String>? origin,
    Expression<String>? destination,
    Expression<DateTime>? flightDate,
    Expression<int>? flightHour,
    Expression<double>? temperature,
    Expression<double>? rain,
    Expression<double>? cloudCover,
    Expression<String>? prediction,
    Expression<int>? predictedClass,
    Expression<double>? probability,
    Expression<String>? confidence,
    Expression<double>? threshold,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (airline != null) 'airline': airline,
      if (movementType != null) 'movement_type': movementType,
      if (fltType != null) 'flt_type': fltType,
      if (origin != null) 'origin': origin,
      if (destination != null) 'destination': destination,
      if (flightDate != null) 'flight_date': flightDate,
      if (flightHour != null) 'flight_hour': flightHour,
      if (temperature != null) 'temperature': temperature,
      if (rain != null) 'rain': rain,
      if (cloudCover != null) 'cloud_cover': cloudCover,
      if (prediction != null) 'prediction': prediction,
      if (predictedClass != null) 'predicted_class': predictedClass,
      if (probability != null) 'probability': probability,
      if (confidence != null) 'confidence': confidence,
      if (threshold != null) 'threshold': threshold,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  PredictionHistoryCompanion copyWith({
    Value<int>? id,
    Value<String?>? serverId,
    Value<String>? airline,
    Value<String>? movementType,
    Value<String>? fltType,
    Value<String?>? origin,
    Value<String?>? destination,
    Value<DateTime>? flightDate,
    Value<int>? flightHour,
    Value<double>? temperature,
    Value<double>? rain,
    Value<double>? cloudCover,
    Value<String>? prediction,
    Value<int>? predictedClass,
    Value<double>? probability,
    Value<String>? confidence,
    Value<double>? threshold,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
  }) {
    return PredictionHistoryCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      airline: airline ?? this.airline,
      movementType: movementType ?? this.movementType,
      fltType: fltType ?? this.fltType,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      flightDate: flightDate ?? this.flightDate,
      flightHour: flightHour ?? this.flightHour,
      temperature: temperature ?? this.temperature,
      rain: rain ?? this.rain,
      cloudCover: cloudCover ?? this.cloudCover,
      prediction: prediction ?? this.prediction,
      predictedClass: predictedClass ?? this.predictedClass,
      probability: probability ?? this.probability,
      confidence: confidence ?? this.confidence,
      threshold: threshold ?? this.threshold,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (airline.present) {
      map['airline'] = Variable<String>(airline.value);
    }
    if (movementType.present) {
      map['movement_type'] = Variable<String>(movementType.value);
    }
    if (fltType.present) {
      map['flt_type'] = Variable<String>(fltType.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (flightDate.present) {
      map['flight_date'] = Variable<DateTime>(flightDate.value);
    }
    if (flightHour.present) {
      map['flight_hour'] = Variable<int>(flightHour.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (rain.present) {
      map['rain'] = Variable<double>(rain.value);
    }
    if (cloudCover.present) {
      map['cloud_cover'] = Variable<double>(cloudCover.value);
    }
    if (prediction.present) {
      map['prediction'] = Variable<String>(prediction.value);
    }
    if (predictedClass.present) {
      map['predicted_class'] = Variable<int>(predictedClass.value);
    }
    if (probability.present) {
      map['probability'] = Variable<double>(probability.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (threshold.present) {
      map['threshold'] = Variable<double>(threshold.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PredictionHistoryCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('airline: $airline, ')
          ..write('movementType: $movementType, ')
          ..write('fltType: $fltType, ')
          ..write('origin: $origin, ')
          ..write('destination: $destination, ')
          ..write('flightDate: $flightDate, ')
          ..write('flightHour: $flightHour, ')
          ..write('temperature: $temperature, ')
          ..write('rain: $rain, ')
          ..write('cloudCover: $cloudCover, ')
          ..write('prediction: $prediction, ')
          ..write('predictedClass: $predictedClass, ')
          ..write('probability: $probability, ')
          ..write('confidence: $confidence, ')
          ..write('threshold: $threshold, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PredictionHistoryTable predictionHistory =
      $PredictionHistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [predictionHistory];
}

typedef $$PredictionHistoryTableCreateCompanionBuilder =
    PredictionHistoryCompanion Function({
      Value<int> id,
      Value<String?> serverId,
      required String airline,
      required String movementType,
      required String fltType,
      Value<String?> origin,
      Value<String?> destination,
      required DateTime flightDate,
      required int flightHour,
      required double temperature,
      required double rain,
      required double cloudCover,
      required String prediction,
      required int predictedClass,
      required double probability,
      required String confidence,
      required double threshold,
      required DateTime createdAt,
      Value<bool> isSynced,
    });
typedef $$PredictionHistoryTableUpdateCompanionBuilder =
    PredictionHistoryCompanion Function({
      Value<int> id,
      Value<String?> serverId,
      Value<String> airline,
      Value<String> movementType,
      Value<String> fltType,
      Value<String?> origin,
      Value<String?> destination,
      Value<DateTime> flightDate,
      Value<int> flightHour,
      Value<double> temperature,
      Value<double> rain,
      Value<double> cloudCover,
      Value<String> prediction,
      Value<int> predictedClass,
      Value<double> probability,
      Value<String> confidence,
      Value<double> threshold,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
    });

class $$PredictionHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PredictionHistoryTable> {
  $$PredictionHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get airline => $composableBuilder(
    column: $table.airline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fltType => $composableBuilder(
    column: $table.fltType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get flightDate => $composableBuilder(
    column: $table.flightDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flightHour => $composableBuilder(
    column: $table.flightHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rain => $composableBuilder(
    column: $table.rain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cloudCover => $composableBuilder(
    column: $table.cloudCover,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prediction => $composableBuilder(
    column: $table.prediction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get predictedClass => $composableBuilder(
    column: $table.predictedClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get probability => $composableBuilder(
    column: $table.probability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PredictionHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PredictionHistoryTable> {
  $$PredictionHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get airline => $composableBuilder(
    column: $table.airline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fltType => $composableBuilder(
    column: $table.fltType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get flightDate => $composableBuilder(
    column: $table.flightDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flightHour => $composableBuilder(
    column: $table.flightHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rain => $composableBuilder(
    column: $table.rain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cloudCover => $composableBuilder(
    column: $table.cloudCover,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prediction => $composableBuilder(
    column: $table.prediction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get predictedClass => $composableBuilder(
    column: $table.predictedClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get probability => $composableBuilder(
    column: $table.probability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PredictionHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PredictionHistoryTable> {
  $$PredictionHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get airline =>
      $composableBuilder(column: $table.airline, builder: (column) => column);

  GeneratedColumn<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fltType =>
      $composableBuilder(column: $table.fltType, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get flightDate => $composableBuilder(
    column: $table.flightDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get flightHour => $composableBuilder(
    column: $table.flightHour,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rain =>
      $composableBuilder(column: $table.rain, builder: (column) => column);

  GeneratedColumn<double> get cloudCover => $composableBuilder(
    column: $table.cloudCover,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prediction => $composableBuilder(
    column: $table.prediction,
    builder: (column) => column,
  );

  GeneratedColumn<int> get predictedClass => $composableBuilder(
    column: $table.predictedClass,
    builder: (column) => column,
  );

  GeneratedColumn<double> get probability => $composableBuilder(
    column: $table.probability,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<double> get threshold =>
      $composableBuilder(column: $table.threshold, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$PredictionHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PredictionHistoryTable,
          PredictionHistoryData,
          $$PredictionHistoryTableFilterComposer,
          $$PredictionHistoryTableOrderingComposer,
          $$PredictionHistoryTableAnnotationComposer,
          $$PredictionHistoryTableCreateCompanionBuilder,
          $$PredictionHistoryTableUpdateCompanionBuilder,
          (
            PredictionHistoryData,
            BaseReferences<
              _$AppDatabase,
              $PredictionHistoryTable,
              PredictionHistoryData
            >,
          ),
          PredictionHistoryData,
          PrefetchHooks Function()
        > {
  $$PredictionHistoryTableTableManager(
    _$AppDatabase db,
    $PredictionHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PredictionHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PredictionHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PredictionHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> airline = const Value.absent(),
                Value<String> movementType = const Value.absent(),
                Value<String> fltType = const Value.absent(),
                Value<String?> origin = const Value.absent(),
                Value<String?> destination = const Value.absent(),
                Value<DateTime> flightDate = const Value.absent(),
                Value<int> flightHour = const Value.absent(),
                Value<double> temperature = const Value.absent(),
                Value<double> rain = const Value.absent(),
                Value<double> cloudCover = const Value.absent(),
                Value<String> prediction = const Value.absent(),
                Value<int> predictedClass = const Value.absent(),
                Value<double> probability = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<double> threshold = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => PredictionHistoryCompanion(
                id: id,
                serverId: serverId,
                airline: airline,
                movementType: movementType,
                fltType: fltType,
                origin: origin,
                destination: destination,
                flightDate: flightDate,
                flightHour: flightHour,
                temperature: temperature,
                rain: rain,
                cloudCover: cloudCover,
                prediction: prediction,
                predictedClass: predictedClass,
                probability: probability,
                confidence: confidence,
                threshold: threshold,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                required String airline,
                required String movementType,
                required String fltType,
                Value<String?> origin = const Value.absent(),
                Value<String?> destination = const Value.absent(),
                required DateTime flightDate,
                required int flightHour,
                required double temperature,
                required double rain,
                required double cloudCover,
                required String prediction,
                required int predictedClass,
                required double probability,
                required String confidence,
                required double threshold,
                required DateTime createdAt,
                Value<bool> isSynced = const Value.absent(),
              }) => PredictionHistoryCompanion.insert(
                id: id,
                serverId: serverId,
                airline: airline,
                movementType: movementType,
                fltType: fltType,
                origin: origin,
                destination: destination,
                flightDate: flightDate,
                flightHour: flightHour,
                temperature: temperature,
                rain: rain,
                cloudCover: cloudCover,
                prediction: prediction,
                predictedClass: predictedClass,
                probability: probability,
                confidence: confidence,
                threshold: threshold,
                createdAt: createdAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PredictionHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PredictionHistoryTable,
      PredictionHistoryData,
      $$PredictionHistoryTableFilterComposer,
      $$PredictionHistoryTableOrderingComposer,
      $$PredictionHistoryTableAnnotationComposer,
      $$PredictionHistoryTableCreateCompanionBuilder,
      $$PredictionHistoryTableUpdateCompanionBuilder,
      (
        PredictionHistoryData,
        BaseReferences<
          _$AppDatabase,
          $PredictionHistoryTable,
          PredictionHistoryData
        >,
      ),
      PredictionHistoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PredictionHistoryTableTableManager get predictionHistory =>
      $$PredictionHistoryTableTableManager(_db, _db.predictionHistory);
}

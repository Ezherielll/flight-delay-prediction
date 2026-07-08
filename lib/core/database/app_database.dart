import 'package:drift/drift.dart';
import 'connection/connection_stub.dart'
    if (dart.library.js_interop) 'connection/connection_web.dart'
    if (dart.library.io) 'connection/connection_native.dart';

part 'app_database.g.dart';

class PredictionHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  TextColumn get airline => text()();
  TextColumn get movementType => text()();
  TextColumn get fltType => text()();
  TextColumn get origin => text().nullable()();
  TextColumn get destination => text().nullable()();
  DateTimeColumn get flightDate => dateTime()();
  IntColumn get flightHour => integer()();

  // Weather snapshot
  RealColumn get temperature => real()();
  RealColumn get rain => real()();
  RealColumn get cloudCover => real()();

  // Result
  TextColumn get prediction => text()();
  IntColumn get predictedClass => integer()();
  RealColumn get probability => real()();
  TextColumn get confidence => text()();
  RealColumn get threshold => real()();

  // Meta
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [PredictionHistory])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}

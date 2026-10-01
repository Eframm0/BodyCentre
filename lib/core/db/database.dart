import 'package:drift/drift.dart';

part 'database.g.dart';

class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  DateTimeColumn get birthDate => dateTime()();
  BoolColumn get isMale => boolean()();
  IntColumn get heightCm => integer()();
  RealColumn get currentWeightKg => real()();
  TextColumn get goal => text()();
  TextColumn get activityLevel => text()();
  IntColumn get manualKcalTarget => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get kcalPer100g => real()();
  RealColumn get proteinPer100g => real()();
  RealColumn get carbsPer100g => real()();
  RealColumn get fatPer100g => real()();
  RealColumn get portionGrams => real().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

/// Voce del diario alimentare. Kcal e macro sono snapshot immutabili al
/// momento dell'inserimento: modifiche al catalogo non riscrivono la storia.
///
/// N.B. non chiamare mai una colonna `dateTime`: drift_dev (2.35) genera
/// in silenzio uno schema vuoto.
class MealEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get entryDateTime => dateTime()();

  /// 'breakfast' | 'lunch' | 'dinner' | 'snack'
  TextColumn get mealType => text()();
  IntColumn get foodItemId => integer().nullable()();
  TextColumn get foodName => text()();
  RealColumn get grams => real()();
  RealColumn get kcal => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
}

/// Rilevazione del Peso forma: peso, composizione corporea e foto.
class WeightEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get entryDateTime => dateTime()();
  RealColumn get weightKg => real()();

  /// Composizione corporea (se nota): percentuali.
  RealColumn get fatPct => real().nullable()();
  RealColumn get musclePct => real().nullable()();

  /// Percorsi locali della foto (documents dir dell'app).
  TextColumn get photoPath => text().nullable()();
  TextColumn get note => text().nullable()();
}

/// Punti di misura delle circonferenze: predefiniti (vita, petto,
/// bicipiti) e personalizzati creati dall'utente.
class MeasurementPoints extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 'waist' | 'chest' | 'bicep_l' | 'bicep_r' | ``'custom:<nome>'``
  TextColumn get key => text()();
  TextColumn get label => text()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

/// Circonferenza misurata in una rilevazione. Le coordinate della freccia
/// (0..1 relative alla foto) si salvano per ridisegnarle sulla foto.
class WeightMeasurements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get weightEntryId => integer().references(WeightEntries, #id)();
  IntColumn get pointId => integer().references(MeasurementPoints, #id)();
  RealColumn get valueCm => real()();
  RealColumn get arrowX => real().withDefault(const Constant(0.5))();
  RealColumn get arrowY => real().withDefault(const Constant(0.5))();
  RealColumn get arrowAngle => real().withDefault(const Constant(0))();
}

@DriftDatabase(
  tables: [UserProfiles, FoodItems, MealEntries, WeightEntries, MeasurementPoints, WeightMeasurements],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(weightEntries);
        await m.createTable(measurementPoints);
        await m.createTable(weightMeasurements);
      }
    },
  );

  // ---- Profilo ----

  /// Stream del profilo (null finché l'onboarding non è completato).
  Stream<UserProfile?> watchProfile() {
    final query = select(userProfiles)..limit(1);
    return query.watchSingleOrNull();
  }

  Future<UserProfile?> getProfile() async {
    final query = select(userProfiles)..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> saveProfile(UserProfilesCompanion entry) =>
      into(userProfiles).insert(entry);

  // ---- Catalogo alimenti ----

  Future<void> insertFoods(List<FoodItemsCompanion> entries) =>
      batch((b) => b.insertAll(foodItems, entries));

  /// Ricerca per nome (case-insensitive, contiene).
  Future<List<FoodItem>> searchFoods(String query, {int limit = 30}) {
    final q = query.trim().toLowerCase();
    final select$ = select(foodItems)
      ..where((f) => f.name.lower().contains(q))
      ..limit(limit);
    return select$.get();
  }

  Future<int> countFoods() async {
    final count = foodItems.id.count();
    final row = await (selectOnly(foodItems)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  /// Inserisce un cibo personalizzato e ne ritorna l'id.
  Future<int> insertCustomFood(FoodItemsCompanion entry) =>
      into(foodItems).insert(entry);

  // ---- Diario ----

  Future<void> addMealEntry(MealEntriesCompanion entry) =>
      into(mealEntries).insert(entry);

  Future<void> deleteMealEntry(int id) =>
      (delete(mealEntries)..where((e) => e.id.equals(id))).go();

  /// Tutte le voci di un giorno (da mezzanotte a mezzanotte, ora locale).
  Stream<List<MealEntry>> watchDayEntries(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final query =
        select(mealEntries)
          ..where((e) => e.entryDateTime.isBetweenValues(start, end))
          ..orderBy([(e) => OrderingTerm.asc(e.entryDateTime)]);
    return query.watch();
  }

  /// Kcal totali per ciascuno degli ultimi `days` giorni (incluso oggi),
  /// dalla più vecchia alla più recente.
  Future<List<double>> dailyKcalLastDays(int days) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: days - 1));
    final end = start.add(Duration(days: days));
    final y = mealEntries.entryDateTime.year;
    final m = mealEntries.entryDateTime.month;
    final d = mealEntries.entryDateTime.day;
    final kcalSum = mealEntries.kcal.sum();
    final rows =
        await (
          selectOnly(mealEntries)
            ..addColumns([y, m, d, kcalSum])
            ..where(mealEntries.entryDateTime.isBetweenValues(start, end))
            ..groupBy([y, m, d])
        ).get();
    final byDate = <DateTime, double>{
      for (final r in rows)
        DateTime(r.read(y)!, r.read(m)!, r.read(d)!): (r.read(kcalSum) ?? 0).toDouble(),
    };
    return [
      for (var i = 0; i < days; i++)
        byDate[start.add(Duration(days: i))] ?? 0,
    ];
  }

  // ---- Peso forma ----

  /// Tutte le rilevazioni, dalla più recente.
  Stream<List<WeightEntry>> watchWeightEntries() {
    final query =
        select(weightEntries)..orderBy([(w) => OrderingTerm.desc(w.entryDateTime)]);
    return query.watch();
  }

  Future<WeightEntry?> getLastWeightEntry() {
    final query =
        select(weightEntries)..orderBy([(w) => OrderingTerm.desc(w.entryDateTime)])..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> deleteWeightEntry(int id) =>
      (delete(weightEntries)..where((w) => w.id.equals(id))).go();

  /// Salva una rilevazione con le sue circonferenze in un'unica transazione.
  Future<void> saveWeightEntry(
    WeightEntriesCompanion entry,
    List<(int pointId, double cm, double x, double y, double angle)> measurements,
  ) async {
    await transaction(() async {
      final id = await into(weightEntries).insert(entry);
      await batch((b) {
        b.insertAll(
          weightMeasurements,
          [
            for (final m in measurements)
              WeightMeasurementsCompanion.insert(
                weightEntryId: id,
                pointId: m.$1,
                valueCm: m.$2,
                arrowX: Value(m.$3),
                arrowY: Value(m.$4),
                arrowAngle: Value(m.$5),
              ),
          ],
        );
      });
    });
  }

  /// Misure di una rilevazione, join con i punti (label inclusa).
  Future<List<(WeightMeasurement, String)>> getMeasurements(int entryId) async {
    final query =
        select(weightMeasurements).join([
          innerJoin(
            measurementPoints,
            measurementPoints.id.equalsExp(weightMeasurements.pointId),
          ),
        ])
          ..where(weightMeasurements.weightEntryId.equals(entryId));
    final rows = await query.get();
    return [
      for (final r in rows)
        (r.readTable(weightMeasurements), r.readTable(measurementPoints).label),
    ];
  }

  /// Misure dell'ultima rilevazione con foto (per la card con le frecce).
  Future<List<(WeightMeasurement, String)>> getMeasurementsForEntry(int entryId) =>
      getMeasurements(entryId);

  /// Punti di misura: default creati al primo utilizzo + custom.
  Future<List<MeasurementPoint>> getAllPoints() =>
      (select(measurementPoints)..orderBy([(p) => OrderingTerm.asc(p.id)])).get();

  Future<int> ensureDefaultPoints() async {
    final defaults = [
      ('waist', 'Vita'),
      ('chest', 'Petto'),
      ('bicep_l', 'Bicipite sx'),
      ('bicep_r', 'Bicipite dx'),
    ];
    var maxId = 0;
    for (final (key, label) in defaults) {
      final existing =
          await (select(measurementPoints)..where((p) => p.key.equals(key)))
              .getSingleOrNull();
      if (existing == null) {
        maxId = await into(measurementPoints).insert(
          MeasurementPointsCompanion.insert(key: key, label: label),
        );
      } else {
        maxId = maxId < existing.id ? existing.id : maxId;
      }
    }
    return maxId;
  }

  Future<int> addCustomPoint(String label) => into(measurementPoints).insert(
    MeasurementPointsCompanion.insert(key: 'custom:$label', label: label, isCustom: const Value(true)),
  );
}

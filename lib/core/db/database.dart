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

  /// Estremi della linea di misura (null se non rilevati).
  RealColumn get arrowX1 => real().nullable()();
  RealColumn get arrowY1 => real().nullable()();
  RealColumn get arrowX2 => real().nullable()();
  RealColumn get arrowY2 => real().nullable()();
}

/// Serie storica di una circonferenza (per il trend).
class MeasureSeries {
  MeasureSeries(this.label);

  final String label;
  final List<(DateTime, double)> values = [];
}

/// Misura da salvare con posizione e (opzionali) estremi della linea.
class MeasureToSave {  const MeasureToSave(
    this.pointId,
    this.cm,
    this.x,
    this.y, {
    this.x1,
    this.y1,
    this.x2,
    this.y2,
  });

  final int pointId;
  final double cm;
  final double x;
  final double y;
  final double? x1;
  final double? y1;
  final double? x2;
  final double? y2;
}

@DriftDatabase(
  tables: [UserProfiles, FoodItems, MealEntries, WeightEntries, MeasurementPoints, WeightMeasurements],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(weightEntries);
        await m.createTable(measurementPoints);
        await m.createTable(weightMeasurements);
      }
      if (from < 3) {
        await m.addColumn(weightMeasurements, weightMeasurements.arrowX1);
        await m.addColumn(weightMeasurements, weightMeasurements.arrowY1);
        await m.addColumn(weightMeasurements, weightMeasurements.arrowX2);
        await m.addColumn(weightMeasurements, weightMeasurements.arrowY2);
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

  /// Posizione di misura con estremi della linea (0..1 sulla foto).
  /// Gli estremi sono null se non rilevabili.
  static const emptyEnds = (null, null, null, null);

  /// Salva una rilevazione con le sue circonferenze in un'unica transazione.
  Future<void> saveWeightEntry(
    WeightEntriesCompanion entry,
    List<MeasureToSave> measurements,
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
                pointId: m.pointId,
                valueCm: m.cm,
                arrowX: Value(m.x),
                arrowY: Value(m.y),
                arrowX1: m.x1 == null ? const Value.absent() : Value(m.x1!),
                arrowY1: m.y1 == null ? const Value.absent() : Value(m.y1!),
                arrowX2: m.x2 == null ? const Value.absent() : Value(m.x2!),
                arrowY2: m.y2 == null ? const Value.absent() : Value(m.y2!),
              ),
          ],
        );
      });
    });
  }

  /// Misure di una rilevazione, join con i punti (label e key inclusi).
  Future<List<(WeightMeasurement, MeasurementPoint)>> getMeasurements(
    int entryId,
  ) async {
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
        (r.readTable(weightMeasurements), r.readTable(measurementPoints)),
    ];
  }

  /// Elimina una misura dalla foto.
  Future<void> deleteMeasurement(int id) =>
      (delete(weightMeasurements)..where((m) => m.id.equals(id))).go();

  /// Elimina PERMANENTEMENTE un punto utente: tutte le sue misure
  /// (in ogni rilevazione) e il punto stesso.
  Future<void> deletePointCascade(int pointId) async {
    await transaction(() async {
      await (delete(weightMeasurements)
            ..where((m) => m.pointId.equals(pointId)))
          .go();
      await (delete(measurementPoints)
            ..where((p) => p.id.equals(pointId)))
          .go();
    });
  }

  /// Serie storiche delle circonferenze per punto (ordine cronologico),
  /// per il grafico di tendenza. Solo punti con almeno una misura.
  Future<List<MeasureSeries>> getMeasurementSeries() async {
    final query =
        select(weightMeasurements).join([
          innerJoin(
            measurementPoints,
            measurementPoints.id.equalsExp(weightMeasurements.pointId),
          ),
          innerJoin(
            weightEntries,
            weightEntries.id.equalsExp(weightMeasurements.weightEntryId),
          ),
        ])
          ..orderBy([
            OrderingTerm.asc(weightEntries.entryDateTime),
          ]);
    final rows = await query.get();
    final byPoint = <int, MeasureSeries>{};
    for (final r in rows) {
      final point = r.readTable(measurementPoints);
      final entry = r.readTable(weightEntries);
      final m = r.readTable(weightMeasurements);
      byPoint
          .putIfAbsent(point.id, () => MeasureSeries(point.label))
          .values
          .add((entry.entryDateTime, m.valueCm));
    }
    // Prima i punti con più dati (più significativi), poi per nome.
    final list = byPoint.values.toList()
      ..sort((a, b) {
        final cmp = b.values.length.compareTo(a.values.length);
        return cmp != 0 ? cmp : a.label.compareTo(b.label);
      });
    return list;
  }

  /// Elimina un punto di misura se non ha più misure collegate.
  Future<void> deletePointIfUnused(int pointId) async {
    final count = weightMeasurements.id.count();
    final row =
        await (
          selectOnly(weightMeasurements)
            ..addColumns([count])
            ..where(weightMeasurements.pointId.equals(pointId))
        ).getSingle();
    if ((row.read(count) ?? 0) == 0) {
      await (delete(measurementPoints)
            ..where((p) => p.id.equals(pointId)))
          .go();
    }
  }

  /// Punti di misura: default creati al primo utilizzo + custom.
  Future<List<MeasurementPoint>> getAllPoints() =>
      (select(measurementPoints)..orderBy([(p) => OrderingTerm.asc(p.id)])).get();

  /// Aggiorna la posizione della freccia/linea di una misura (coordinate
  /// 0..1 relative alla foto) dopo il drag dell'utente.
  Future<void> updateMeasurementArrow(
    int measurementId,
    double x,
    double y, {
    double? x1,
    double? y1,
    double? x2,
    double? y2,
  }) => (
      update(weightMeasurements)
        ..where((m) => m.id.equals(measurementId))
    ).write(
      WeightMeasurementsCompanion(
        arrowX: Value(x),
        arrowY: Value(y),
        arrowX1: Value(x1),
        arrowY1: Value(y1),
        arrowX2: Value(x2),
        arrowY2: Value(y2),
      ),
    );

  /// Aggiunge una misura a una rilevazione esistente (nuovo punto toccato
  /// sulla foto).
  Future<void> addMeasurement(
    int entryId,
    int pointId,
    double cm,
    double x,
    double y,
  ) => into(weightMeasurements).insert(
    WeightMeasurementsCompanion.insert(
      weightEntryId: entryId,
      pointId: pointId,
      valueCm: cm,
      arrowX: Value(x),
      arrowY: Value(y),
    ),
  );

  /// Prima rilevazione con foto (per il confronto prima/dopo).
  Future<WeightEntry?> getFirstEntryWithPhoto() {
    final query =
        select(weightEntries)
          ..where((w) => w.photoPath.isNotNull())
          ..orderBy([(w) => OrderingTerm.asc(w.entryDateTime)])
          ..limit(1);
    return query.getSingleOrNull();
  }

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

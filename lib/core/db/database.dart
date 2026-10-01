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

@DriftDatabase(tables: [UserProfiles, FoodItems, MealEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

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
}

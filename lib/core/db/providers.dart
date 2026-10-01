import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../formulas/calories.dart';
import 'database.dart';
import 'seed.dart';

export '../formulas/calories.dart' show Calories;

/// Database dell'app (singleton per sessione).
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(driftDatabase(name: 'body_centre'));
  ref.onDispose(db.close);
  return db;
});

/// Inizializzazione one-shot: import del catalogo alimenti e punti di
/// misura predefiniti alla prima apertura.
final appInitProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(databaseProvider);
  await seedFoodsIfEmpty(db);
  await db.ensureDefaultPoints();
});

/// Rilevazioni del Peso forma, dalla più recente.
final weightEntriesProvider = StreamProvider<List<WeightEntry>>((ref) {
  return ref.watch(databaseProvider).watchWeightEntries();
});

/// Ultima rilevazione (null se mai registrata).
final lastWeightEntryProvider = Provider<WeightEntry?>(
  (ref) => ref.watch(weightEntriesProvider).value?.firstOrNull,
);

/// Profilo utente: null finché l'onboarding non è completato.
final profileProvider = StreamProvider<UserProfile?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchProfile();
});

/// Profilo già risolto (non-null dopo l'onboarding).
final userProfileProvider = Provider<UserProfile?>(
  (ref) => ref.watch(profileProvider).value,
);

/// Età anagrafica calcolata.
final ageProvider = Provider<int?>((ref) {
  final profile = ref.watch(userProfileProvider);
  if (profile == null) return null;
  return Calories.ageFromBirthDate(profile.birthDate);
});

/// Obiettivo calorico giornaliero: manuale se impostato, altrimenti
/// calcolato con Mifflin-St Jeor × attività × obiettivo.
final dailyKcalTargetProvider = Provider<int>((ref) {
  final profile = ref.watch(userProfileProvider);
  if (profile == null) return 2000;
  if (profile.manualKcalTarget != null) return profile.manualKcalTarget!;
  final target = Calories.dailyTarget(
    isMale: profile.isMale,
    weightKg: profile.currentWeightKg,
    heightCm: profile.heightCm,
    ageYears: Calories.ageFromBirthDate(profile.birthDate),
    activityLevel: profile.activityLevel,
    goal: profile.goal,
  );
  return target.round();
});

/// Giorno selezionato nella sezione Calorie (normalizzato a mezzanotte).
final selectedDayProvider =
    NotifierProvider<SelectedDayNotifier, DateTime>(SelectedDayNotifier.new);

class SelectedDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void set(DateTime day) =>
      state = DateTime(day.year, day.month, day.day);

  void shift(int days) => set(state.add(Duration(days: days)));
}

/// Voci del diario del giorno selezionato.
final dayEntriesProvider =
    StreamProvider.family<List<MealEntry>, DateTime>((ref, day) {
      return ref.watch(databaseProvider).watchDayEntries(day);
    });

/// Kcal bruciate nel giorno (passi + allenamenti).
/// TODO(M5): alimentato da Health Connect / pedometro.
final burnedKcalProvider = Provider<int>((ref) => 0);

/// Conteggio voci del diario: cambia a ogni inserimento/eliminazione e
/// fa da "versione" per ricalcolare i totali della settimana.
final mealCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  final count = db.mealEntries.id.count();
  return (db.selectOnly(db.mealEntries)..addColumns([count]))
      .watch()
      .map((rows) => rows.first.read(count) ?? 0);
});

/// Kcal assunte per ciascuno degli ultimi 7 giorni (dal diario reale).
final weekIntakeProvider = FutureProvider<List<double>>((ref) async {
  ref.watch(mealCountProvider);
  final db = ref.watch(databaseProvider);
  return db.dailyKcalLastDays(7);
});

/// Totali del giorno a partire dalle voci del diario.
class DayTotals {
  const DayTotals({
    this.kcal = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.fiber = 0,
  });

  final double kcal;
  final double protein;
  final double carbs;
  final double fat;

  /// Stima fibra (non tracciata nel diario): 10% dei carboidrati.
  final double fiber;

  static DayTotals fromEntries(List<MealEntry> entries) {
    var kcal = 0.0, protein = 0.0, carbs = 0.0, fat = 0.0;
    for (final e in entries) {
      kcal += e.kcal;
      protein += e.protein;
      carbs += e.carbs;
      fat += e.fat;
    }
    return DayTotals(
      kcal: kcal,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: carbs * 0.1,
    );
  }
}

/// Obiettivi dei macronutrienti derivati dall'obiettivo kcal
/// (30% proteine, 45% carboidrati, 25% grassi; fibra fissa 30 g).
class MacroTargets {
  const MacroTargets({required this.protein, required this.carbs, required this.fat, this.fiber = 30});

  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  factory MacroTargets.fromKcal(int kcal) => MacroTargets(
    protein: kcal * 0.30 / 4,
    carbs: kcal * 0.45 / 4,
    fat: kcal * 0.25 / 9,
  );
}

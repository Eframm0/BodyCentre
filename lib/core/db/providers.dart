import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../formulas/calories.dart';
import 'database.dart';

export '../formulas/calories.dart' show Calories;

/// Database dell'app (singleton per sessione).
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(driftDatabase(name: 'body_centre'));
  ref.onDispose(db.close);
  return db;
});

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

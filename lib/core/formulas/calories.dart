/// Formule caloriche (PROGETTAZIONE.md §5.3).
abstract final class Calories {
  /// BMR Mifflin-St Jeor.
  static double bmr({
    required bool isMale,
    required double weightKg,
    required int heightCm,
    required int ageYears,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * ageYears;
    return isMale ? base + 5 : base - 161;
  }

  /// Fattore attività.
  static double activityFactor(String activityLevel) => switch (activityLevel) {
    'sedentary' => 1.2,
    'light' => 1.375,
    'moderate' => 1.55,
    'active' => 1.725,
    'veryActive' => 1.9,
    _ => 1.375,
  };

  /// TDEE (mantenimento).
  static double tdee({
    required bool isMale,
    required double weightKg,
    required int heightCm,
    required int ageYears,
    required String activityLevel,
  }) =>
      bmr(
            isMale: isMale,
            weightKg: weightKg,
            heightCm: heightCm,
            ageYears: ageYears,
          ) *
          activityFactor(activityLevel);

  /// Obiettivo giornaliero: deficit -15% / surplus +10% / mantenimento.
  static double dailyTarget({
    required bool isMale,
    required double weightKg,
    required int heightCm,
    required int ageYears,
    required String activityLevel,
    required String goal,
  }) {
    final maintenance = tdee(
      isMale: isMale,
      weightKg: weightKg,
      heightCm: heightCm,
      ageYears: ageYears,
      activityLevel: activityLevel,
    );
    return switch (goal) {
      'loss' => maintenance * 0.85,
      'gain' => maintenance * 1.10,
      _ => maintenance,
    };
  }

  /// Età anagrafica da data di nascita.
  static int ageFromBirthDate(DateTime birthDate, [DateTime? now]) {
    final today = now ?? DateTime.now();
    var age = today.year - birthDate.year;
    final hadBirthday =
        today.month > birthDate.month ||
        (today.month == birthDate.month && today.day >= birthDate.day);
    if (!hadBirthday) age--;
    return age;
  }
}

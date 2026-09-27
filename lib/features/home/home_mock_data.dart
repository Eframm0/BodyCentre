import 'dart:math' as math;

/// Dati fittizi per i GRAFICI della dashboard.
///
/// Il profilo nella Home ora viene dal database reale; questi mock restano
/// solo per il grafico peso e le calorie finché M2 (rilevazioni peso) e
/// Task 3 (diario calorico reale) non li sostituiscono.
abstract final class HomeMockData {
  /// 30 rilevazioni di peso (kg): trend in discesa con oscillazioni.
  static List<double> get weights => List.generate(
    30,
    (i) => 79.6 - 0.048 * i + 0.18 * math.sin(i * 0.9),
  );

  static double get currentWeight => weights.last;

  /// Variazione negli ultimi 30 giorni (negativa = dimagrimento).
  static double get weightDelta30d => currentWeight - weights.first;

  /// Previsione peso a 30 giorni (mock — sarà output del modello AI).
  static double get predictedWeight30d => currentWeight - 1.3;

  static const int dailyKcalTarget = 2400;

  /// Kcal assunte finora oggi.
  static const int todayKcalEaten = 1850;

  /// Settimana: kcal assunte e bruciate totali (ultimo elemento = oggi).
  static const List<int> weekIntake = [2050, 2180, 1920, 2400, 1760, 2280, 1850];
  static const List<int> weekBurned = [2750, 2620, 2810, 2540, 2690, 2880, 2520];
}

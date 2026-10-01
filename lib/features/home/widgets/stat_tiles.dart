import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/design/theme.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Riga con le due tile statistiche: Peso (dal profilo reale) e Calorie
/// del giorno (dal diario reale).
class StatTilesRow extends ConsumerWidget {
  const StatTilesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider);
    final kcalTarget = ref.watch(dailyKcalTargetProvider);

    // Peso: ultima rilevazione reale (o peso del profilo) + delta 30gg.
    final wEntries = ref.watch(weightEntriesProvider).value ?? [];
    final currentWeight = wEntries.isNotEmpty ? wEntries.first.weightKg : profile?.currentWeightKg;
    double? delta30;
    if (wEntries.length >= 2) {
      final newest = wEntries.first;
      final cutoff = newest.entryDateTime.subtract(const Duration(days: 30));
      final reference = wEntries.lastWhere(
        (e) => !e.entryDateTime.isBefore(cutoff),
        orElse: () => wEntries.last,
      );
      delta30 = newest.weightKg - reference.weightKg;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entries = ref.watch(dayEntriesProvider(today)).value ?? [];
    final kcalEaten = DayTotals.fromEntries(entries).kcal;

    return Row(
      children: [
        Expanded(
          child: ClayPressable(
            child: ClayCard(
              key: const ValueKey('weight-tile'),
              color: ClayPalette.weight,
              radius: 24,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Etichetta: icona prima del testo + Baloo2 (pattern
                  // immune al bug del primo glifo) + guardia ZWSP.
                  // Indentata a destra: primo elemento al bordo sinistro
                  // (taglio del renderer del device).
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.scale_rounded,
                          size: 20,
                          color: ClayPalette.accentDark,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          guardFirstGlyph(l.weightTile.toUpperCase()),
                          style: baloo(
                            size: 13,
                            weight: FontWeight.w700,
                            color: ClayPalette.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      currentWeight == null ? '—' : formatKg(currentWeight),
                      style: baloo(size: 25),
                    ),
                  ),
                  if (delta30 != null) ...[
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            delta30 <= 0
                                ? Icons.trending_down_rounded
                                : Icons.trending_up_rounded,
                            size: 16,
                            color: ClayPalette.accentDark,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            guardFirstGlyph(l.weightDelta(formatDelta(delta30))),
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: ClayPalette.accentDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClayPressable(
            child: ClayCard(
              key: const ValueKey('calories-tile'),
              color: ClayPalette.calories,
              radius: 24,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 20,
                          color: ClayPalette.accentDark,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          guardFirstGlyph(l.caloriesTile.toUpperCase()),
                          style: baloo(
                            size: 13,
                            weight: FontWeight.w700,
                            color: ClayPalette.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      formatKcal(kcalEaten.round()),
                      style: baloo(size: 25),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ClayProgress(
                      fraction: kcalEaten / kcalTarget,
                      height: 8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      guardFirstGlyph(
                        l.caloriesProgress(
                          formatKcal(kcalEaten.round()),
                          formatKcal(kcalTarget),
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: ClayPalette.textSoft,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

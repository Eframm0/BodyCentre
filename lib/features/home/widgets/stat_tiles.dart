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
                      profile == null
                          ? '—'
                          : formatKg(profile.currentWeightKg),
                      style: baloo(size: 25),
                    ),
                  ),
                  // La variazione 30 giorni arriverà con lo storico del
                  // Peso forma (M2): per ora si mostra il peso del profilo.
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

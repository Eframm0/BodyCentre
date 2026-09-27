import 'package:flutter/material.dart';

import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/design/theme.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../home_mock_data.dart';

/// Riga con le due tile statistiche: Peso e Calorie di oggi.
class StatTilesRow extends StatelessWidget {
  const StatTilesRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final delta = HomeMockData.weightDelta30d;

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
                  Text(
                    guardFirstGlyph(l.weightTile),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      // w700: a 11px il peso w800 del font variabile perde il
                      // primo glifo nel rendering (bug verificato su device).
                      fontWeight: FontWeight.w700,
                      color: ClayPalette.textSoft,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formatKg(HomeMockData.currentWeight),
                    style: baloo(size: 25),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        delta <= 0
                            ? Icons.trending_down_rounded
                            : Icons.trending_up_rounded,
                        size: 14,
                        color: ClayPalette.accentDark,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        guardFirstGlyph(l.weightDelta(formatDelta(delta))),
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: ClayPalette.accentDark,
                        ),
                      ),
                    ],
                  ),
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
                  Text(
                    guardFirstGlyph(l.caloriesTile),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: ClayPalette.textSoft,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formatKcal(HomeMockData.todayKcalEaten),
                    style: baloo(size: 25),
                  ),
                  const SizedBox(height: 5),
                  ClayProgress(
                    fraction:
                        HomeMockData.todayKcalEaten /
                        HomeMockData.dailyKcalTarget,
                    height: 8,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    guardFirstGlyph(
                      l.caloriesProgress(
                        formatKcal(HomeMockData.todayKcalEaten),
                        formatKcal(HomeMockData.dailyKcalTarget),
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: ClayPalette.textSoft,
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

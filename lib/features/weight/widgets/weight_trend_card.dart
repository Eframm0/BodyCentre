import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/db/database.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Card grafico "Andamento peso" sui dati reali delle rilevazioni.
/// Con meno di due punti mostra un placeholder.
class WeightTrendCard extends StatelessWidget {
  const WeightTrendCard({super.key, required this.entries});

  /// Rilevazioni dalla più recente alla più vecchia.
  final List<WeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final points = entries.reversed.toList();

    if (points.length < 2) {
      return ClayCard(
        key: const ValueKey('weight-chart-card'),
        color: ClayPalette.weight,
        radius: 24,
        padding: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            guardFirstGlyph(l.notEnoughData),
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ClayPalette.textSoft,
            ),
          ),
        ),
      );
    }

    final weights = points.map((e) => e.weightKg).toList();
    final minY = weights.reduce((a, b) => a < b ? a : b) - 0.4;
    final maxY = weights.reduce((a, b) => a > b ? a : b) + 0.4;

    // Previsione NAIVA a 30 giorni: regressione lineare sui punti.
    final n = weights.length.toDouble();
    final meanX = (n - 1) / 2;
    final meanY = weights.reduce((a, b) => a + b) / n;
    var num = 0.0, den = 0.0;
    for (var i = 0; i < weights.length; i++) {
      num += (i - meanX) * (weights[i] - meanY);
      den += (i - meanX) * (i - meanX);
    }
    final slope = den == 0 ? 0.0 : num / den;
    final predicted = (weights.last + slope * (30 / (n - 1))).toDouble();

    return ClayCard(
      key: const ValueKey('weight-chart-card'),
      color: ClayPalette.weight,
      radius: 24,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_down_rounded,
                  size: 20,
                  color: ClayPalette.accentDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    guardFirstGlyph(l.weightTrendTitle),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: ClayPalette.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 130,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: LineChart(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                LineChartData(
                  minX: 0,
                  maxX: n - 1,
                  minY: minY,
                  maxY: maxY,
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < weights.length; i++)
                          FlSpot(i.toDouble(), weights[i]),
                      ],
                      isCurved: true,
                      curveSmoothness: 0.25,
                      preventCurveOverShooting: true,
                      barWidth: 3.5,
                      color: ClayPalette.accent,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ClayPalette.accent.withValues(alpha: 0.28),
                            ClayPalette.accent.withValues(alpha: 0.02),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ClayChip(
              accent: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 13, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    guardFirstGlyph(
                      l.aiPredictionWeight(formatKg(predicted)),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

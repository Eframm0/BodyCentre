import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../home_mock_data.dart';

/// Card grafico "Andamento peso" (30 giorni) con previsione AI a 30 giorni.
class WeightChartCard extends StatelessWidget {
  const WeightChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final weights = HomeMockData.weights;
    final minY = weights.reduce((a, b) => a < b ? a : b) - 0.3;
    final maxY = weights.reduce((a, b) => a > b ? a : b) + 0.3;

    return ClayCard(
      key: const ValueKey('weight-chart-card'),
      color: ClayPalette.weight,
      radius: 24,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.monitor_weight_rounded,
                size: 20,
                color: ClayPalette.accentDark,
              ),
              const SizedBox(width: 8),
              Text(
                guardFirstGlyph(l.weightTrendTitle),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: ClayPalette.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            child: LineChart(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              LineChartData(
                minX: 0,
                maxX: weights.length - 1.0,
                minY: minY,
                maxY: maxY,
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
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
                    curveSmoothness: 0.3,
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
          const SizedBox(height: 12),
          ClayChip(
            accent: true,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 15,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  guardFirstGlyph(
                    l.aiPredictionWeight(
                      formatKg(HomeMockData.predictedWeight30d),
                    ),
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
        ],
      ),
    );
  }
}

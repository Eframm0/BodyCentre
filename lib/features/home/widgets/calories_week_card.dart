import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../home_mock_data.dart';

/// Card "Calorie · ultimi 7 giorni": barre assunte vs bruciate.
class CaloriesWeekCard extends StatelessWidget {
  const CaloriesWeekCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final letters = l.weekdayLetters;
    final days = [
      for (var i = 6; i >= 0; i--)
        DateTime.now().subtract(Duration(days: i)),
    ];

    return ClayCard(
      key: const ValueKey('calories-week-card'),
      color: ClayPalette.calories,
      radius: 24,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                size: 18,
                color: ClayPalette.accentDark,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.caloriesWeekTitle,
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
          const SizedBox(height: 14),
          SizedBox(
            height: 140,
            child: BarChart(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              BarChartData(
                maxY: 3000,
                alignment: BarChartAlignment.spaceAround,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: const BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i > 6) return const SizedBox.shrink();
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            letters[days[i].weekday - 1],
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: ClayPalette.textSoft,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < 7; i++)
                    BarChartGroupData(
                      x: i,
                      barsSpace: 3,
                      barRods: [
                        BarChartRodData(
                          toY: HomeMockData.weekIntake[i].toDouble(),
                          color: ClayPalette.amber,
                          width: 6.5,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: HomeMockData.weekBurned[i].toDouble(),
                          color: ClayPalette.accent,
                          width: 6.5,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _LegendDot(color: ClayPalette.amber, label: l.legendIntake),
              const SizedBox(width: 14),
              _LegendDot(color: ClayPalette.accent, label: l.legendBurned),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: ClayPalette.textSoft,
          ),
        ),
      ],
    );
  }
}

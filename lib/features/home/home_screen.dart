import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'widgets/calories_week_card.dart';
import 'widgets/profile_header.dart';
import 'widgets/quick_actions.dart';
import 'widgets/stat_tiles.dart';
import 'widgets/weight_chart_card.dart';

/// Dashboard Home: header profilo, tile Peso/Calorie, grafico peso con
/// previsione AI, calorie della settimana e azioni rapide.
///
/// Gli elementi entrano in sequenza (fade + slide) a ogni visita della
/// sezione — parte del linguaggio animato dell'app.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      const ProfileHeaderCard(),
      const StatTilesRow(),
      const WeightChartCard(),
      const CaloriesWeekCard(),
      const QuickActions(),
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 6, bottom: 24),
      children: [
        for (final (i, section) in sections.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: section
                .animate(delay: (90 * i).ms)
                .fadeIn(
                  duration: 320.ms,
                  curve: Curves.easeOutCubic,
                )
                .slideY(
                  begin: 0.07,
                  end: 0,
                  duration: 380.ms,
                  curve: Curves.easeOutCubic,
                ),
          ),
      ],
    );
  }
}

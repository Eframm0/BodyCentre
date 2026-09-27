import 'package:flutter/material.dart';

import '../../../core/design/clay.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Azioni rapide in fondo alla Home: nuovo pasto, nuova rilevazione peso,
/// nuovo allenamento. Le azioni verranno collegate alle rispettive sezioni.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: ClayButton(
            icon: Icons.restaurant_rounded,
            label: l.quickAddMeal,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClayButton(
            icon: Icons.monitor_weight_rounded,
            label: l.quickAddWeight,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClayButton(
            icon: Icons.play_circle_rounded,
            label: l.quickNewWorkout,
          ),
        ),
      ],
    );
  }
}

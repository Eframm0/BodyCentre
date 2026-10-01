import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/clay.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../calories/widgets/add_food_sheet.dart';
import '../../shell/nav_provider.dart';

/// Azioni rapide in fondo alla Home: nuovo pasto (apre direttamente il
/// pannello di aggiunta), peso e allenamento (portano alla sezione).
class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final select = ref.read(appSectionProvider.notifier).select;

    return Row(
      children: [
        Expanded(
          child: ClayButton(
            icon: Icons.restaurant_rounded,
            label: l.quickAddMeal,
            onTap: () {
              select(AppSection.calories);
              showAddFoodSheet(context);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClayButton(
            icon: Icons.monitor_weight_rounded,
            label: l.quickAddWeight,
            onTap: () => select(AppSection.weight),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClayButton(
            icon: Icons.play_circle_rounded,
            label: l.quickNewWorkout,
            onTap: () => select(AppSection.workout),
          ),
        ),
      ],
    );
  }
}

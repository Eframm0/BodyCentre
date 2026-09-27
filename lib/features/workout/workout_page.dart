import 'package:flutter/material.dart';

import '../../core/design/palette.dart';
import '../../l10n/generated/app_localizations.dart';
import '../common/coming_soon_page.dart';

/// Sezione Allenamento — da implementare (M3).
class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ComingSoonPage(
      icon: Icons.fitness_center_rounded,
      title: l.navWorkout,
      color: ClayPalette.workout,
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/design/palette.dart';
import '../../l10n/generated/app_localizations.dart';
import '../common/coming_soon_page.dart';

/// Sezione Calorie — da implementare (M1).
class CaloriesPage extends StatelessWidget {
  const CaloriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ComingSoonPage(
      icon: Icons.local_fire_department_rounded,
      title: l.navCalories,
      color: ClayPalette.calories,
    );
  }
}

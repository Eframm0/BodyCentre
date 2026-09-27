import 'package:flutter/material.dart';

import '../../core/design/palette.dart';
import '../../l10n/generated/app_localizations.dart';
import '../common/coming_soon_page.dart';

/// Sezione Peso forma — da implementare (M2).
class WeightPage extends StatelessWidget {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ComingSoonPage(
      icon: Icons.water_drop_rounded,
      title: l.navWeight,
      color: ClayPalette.weight,
    );
  }
}

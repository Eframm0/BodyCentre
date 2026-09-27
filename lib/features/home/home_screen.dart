import 'package:flutter/material.dart';

import '../../core/design/palette.dart';
import '../../l10n/generated/app_localizations.dart';
import '../common/coming_soon_page.dart';

/// Schermata Home — da implementare (prossimo task).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ComingSoonPage(
      icon: Icons.home_rounded,
      title: l.navHome,
      color: ClayPalette.card,
    );
  }
}

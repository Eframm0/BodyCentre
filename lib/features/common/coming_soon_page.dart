import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/design/clay.dart';
import '../../core/design/palette.dart';
import '../../core/design/theme.dart';
import '../../l10n/generated/app_localizations.dart';

/// Pagina segnaposto per le sezioni non ancora implementate.
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({
    super.key,
    required this.icon,
    required this.title,
    this.color = ClayPalette.card,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayCard(
              color: color,
              radius: 34,
              padding: const EdgeInsets.all(36),
              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.lerp(color, Colors.white, 0.5)!,
                          color,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ClayPalette.shadow,
                          blurRadius: 12,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: 38,
                      color: ClayPalette.accentDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(title, style: baloo(size: 26)),
                  const SizedBox(height: 6),
                  Text(
                    l.comingSoonMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ClayPalette.textSoft,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(key: ValueKey(title)).fadeIn(duration: 320.ms).scale(
      begin: const Offset(0.94, 0.94),
      end: const Offset(1, 1),
      curve: Curves.easeOutBack,
      duration: 380.ms,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/design/theme.dart';
import '../../../core/utils/text_guard.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../home_mock_data.dart';

/// Header della Home: card profilo con avatar, nome, dati anagrafici ed
/// età biologica (chip accento con leggera "respirazione").
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final initials =
        '${HomeMockData.firstName[0]}${HomeMockData.lastName[0]}';

    return ClayCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(ClayPalette.accent, Colors.white, 0.4)!,
                  ClayPalette.accent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: ClayPalette.accent.withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(4, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: baloo(size: 22, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${HomeMockData.firstName} ${HomeMockData.lastName}',
                  style: baloo(size: 21),
                ),
                const SizedBox(height: 2),
                Text(
                  guardFirstGlyph(l.dashboardSubtitle),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ClayPalette.textSoft,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    ClayChip(text: l.ageChip(HomeMockData.age)),
                    ClayChip(text: l.heightChip(HomeMockData.heightCm)),
                    ClayChip(
                      key: const ValueKey('bio-age-chip'),
                      text: l.bioAgeChip(HomeMockData.bioAge),
                      accent: true,
                    )
                        .animate(
                          onPlay: (c) => c.repeat(reverse: true),
                        )
                        .scale(
                          begin: const Offset(0.97, 0.97),
                          end: const Offset(1.045, 1.045),
                          duration: 1300.ms,
                          curve: Curves.easeInOut,
                        ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

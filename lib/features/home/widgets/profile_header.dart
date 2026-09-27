import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/providers.dart';
import '../../../core/design/clay.dart';
import '../../../core/design/palette.dart';
import '../../../core/design/theme.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Header della Home: card profilo con avatar, nome, dati anagrafici ed
/// età biologica (chip accento con leggera "respirazione").
///
/// I dati vengono dal profilo reale nel database (post-onboarding).
class ProfileHeaderCard extends ConsumerStatefulWidget {
  const ProfileHeaderCard({super.key});

  @override
  ConsumerState<ProfileHeaderCard> createState() => _ProfileHeaderCardState();
}

class _ProfileHeaderCardState extends ConsumerState<ProfileHeaderCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))
        ..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final l = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider);
    final age = ref.watch(ageProvider);

    final firstName = profile?.firstName ?? '';
    final lastName = profile?.lastName ?? '';
    final initials =
        firstName.isNotEmpty && lastName.isNotEmpty
            ? '${firstName[0]}${lastName[0]}'
            : '·';

    // TODO(M5): età biologica calcolata sui fattori reali (attività,
    // composizione corporea, FC a riposo). Per ora = età anagrafica.
    final bioAge = age ?? 0;

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
                Text('$firstName $lastName', style: baloo(size: 21)),
                const SizedBox(height: 2),
                Text(
                  l.dashboardSubtitle,
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
                    ClayChip(
                      text: age != null ? l.ageChip(age) : '—',
                    ),
                    ClayChip(
                      text:
                          profile != null ? l.heightChip(profile.heightCm) : '—',
                    ),
                    ScaleTransition(
                      scale: Tween(begin: 0.97, end: 1.045).animate(
                        CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                      ),
                      child: ClayChip(
                        key: const ValueKey('bio-age-chip'),
                        text: l.bioAgeChip(bioAge),
                        accent: true,
                      ),
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
